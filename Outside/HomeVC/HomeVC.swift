//
//  ViewController.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/17/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit
import CoreLocation
class HomeVC: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK:- Properties
    var isCoordinateUpdated:Bool = false
    var weatherData: [WeatherData?] = []
    let locationManager = CLLocationManager()
    
    //MARK:- Outlets
    @IBOutlet weak var cities: UITableView!
    @IBOutlet weak var customBackground: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Ask User for Authorization for Location Permission
        if locationManager.location == nil && !isCoordinateUpdated && weatherData.count == 0 {
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        
        //Code to get coordinates if the permision is given.
        if CLLocationManager.locationServicesEnabled() && weatherData.count == 0 {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //Code to update UI Data based on the location permission and cooordinate dataData
        if locationManager.location != nil && !isCoordinateUpdated && weatherData.count == 0 &&  !checkIfDataIsAlreadySaved(((locationManager.location?.coordinate.latitude)!*100).rounded()/100, ((locationManager.location?.coordinate.longitude)!*100).rounded()/100){
            
            if !isCoordinateUpdated {
                isCoordinateUpdated = true
                checkAndSaveData(latitude: ((locationManager.location?.coordinate.latitude)!*100).rounded()/100,
                longitude: ((locationManager.location?.coordinate.longitude)!*100).rounded()/100)
                loadData()
            }
        } else {
            loadData()
        }
    }

    //MARK:- Method to monitor location in background if not available at the time of launcha and once available to show weather data based on coordinated.
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.isCoordinateUpdated{
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
                return }
            isCoordinateUpdated = true
            if weatherData.count == 0 && !checkIfDataIsAlreadySaved(((locValue.latitude)*100).rounded()/100, ((locValue.longitude)*100).rounded()/100){
                checkAndSaveData(latitude: ((locValue.latitude)*100).rounded()/100, longitude: ((locValue.longitude)*100).rounded()/100)
                loadData()
            }
        }
    }
    
    //MARK:- Code to Get Current Local Time based on GMT offset from API
    func getTime(timeZone: Int?) -> String{
        let f = ISO8601DateFormatter()
        f.formatOptions = .withFullTime
        f.timeZone = TimeZone(secondsFromGMT: timeZone!)
        return f.string(from: Date())
    }
   
    //MARK:- Method to Add City from Map to Show Weather Detalils
    @IBAction func addCity(_ sender: Any) {
        let vc:MapSelectionViewController
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "MapSelectionViewController") as! MapSelectionViewController
        } else {
           vc = storyboard?.instantiateViewController(withIdentifier: "MapSelectionViewController") as! MapSelectionViewController
        }
        vc.weatherDataCollection = self.weatherData
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- Method to Set Unit for Temperature Celsius / Farenhite Using property and UserDefaults.
    @IBAction func setUnit(_ sender: UIButton) {
        switch sender.tag {
            case 11:
                if !UserDefaults.standard.bool(forKey: "isCelsius") {
                    UserDefaults.standard.set(true, forKey: "isCelsius")
                    updateData()
                    self.cities.reloadData()
                }
            case 12:
                if UserDefaults.standard.bool(forKey: "isCelsius") {
                    UserDefaults.standard.set(false, forKey: "isCelsius")
                    updateData()
                    self.cities.reloadData()
                }
            default:
                return
        }
    }
    
    //MARK:- Method to Reload Data in case of changes in Selection from User.
    func loadData() {
        self.weatherData.removeAll()
        for Coordinates in 0..<getAllPinDetails()!.count {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            BaseAPI.sharedInstance().getWeatherData(latitude: getAllPinDetails()![Coordinates].latitude,
                    longitude: getAllPinDetails()![Coordinates].longitude,
                    unit: UserDefaults.standard.bool(forKey: "isCelsius") ? "metric" : "imperial") { (weatherData, error) in
                if let weatherData = weatherData {
                    self.weatherData.append(weatherData)
                    DispatchQueue.main.async {
                        self.cities.reloadData()
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.isHidden = true                    }
                } else {
                    print(error.debugDescription)
                }
            }
       }
    }
    
    //MARK:- Method to Update Data in case of changes in Unit for Temperature - Celsius / Farenhite
    func updateData() {
        if (weatherData.count > 0) {
            for index in 0..<weatherData.count {
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
                BaseAPI.sharedInstance().getWeatherData(latitude: weatherData[index]!.coord!.lat!,
                        longitude: weatherData[index]!.coord!.lon!,
                        unit: UserDefaults.standard.bool(forKey: "isCelsius") ? "metric" : "imperial") { (weatherData, error) in
                    if let weatherData = weatherData {
                        self.weatherData[index] = weatherData
                        DispatchQueue.main.async {
                            self.cities.reloadData()
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                        }
                    } else {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
    
    //MARK:- Method to Get All the Selection from Data Base
    public func getAllPinDetails() -> [SavedCoordinates]? {
        var pinDetails: [SavedCoordinates]?
        do {
            try pinDetails = CoreDataStackMethods.getSharedInstance().getAllCoordinates(entityName: SavedCoordinates.tableName)
        } catch {
            showAlert(withTitle: "Error", message: "Error While Getting All The Pin coordinates: \(error)")
        }
        return pinDetails
    }
}

