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
    
    @IBOutlet weak var cities: UITableView!
    var isCoordinateUpdated:Bool = false
    var isCelsius: Bool? = true
    @IBOutlet weak var customBackground: UIImageView!
    
    
    
    let locationManager = CLLocationManager()

    var weatherData: [WeatherData?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCelsius = UserDefaults.standard.bool(forKey: "isCelsius")
        print("AfterLoadData",weatherData.count)
        if locationManager.location == nil && !isCoordinateUpdated && weatherData.count == 0 {
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        if CLLocationManager.locationServicesEnabled() && weatherData.count == 0 {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
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
        
        
        print("getAllPinDetails()!.count", getAllPinDetails()!.count)
        for Coordinates in 0..<getAllPinDetails()!.count {
            print("***************************************")
            print(getAllPinDetails()![Coordinates].latitude)
            print(getAllPinDetails()![Coordinates].longitude)
            print("***************************************")
        }
        for weather in weatherData {
            print(weather?.coord?.lat, weather?.coord?.lon)
        }
        
        
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!self.isCoordinateUpdated) && !isCoordinateUpdated {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
                return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            isCoordinateUpdated = true
            if weatherData.count == 0 && !checkIfDataIsAlreadySaved(((locationManager.location?.coordinate.latitude)!*100).rounded()/100,
                    ((locationManager.location?.coordinate.longitude)!*100).rounded()/100){
                checkAndSaveData(latitude: ((locationManager.location?.coordinate.latitude)!*100).rounded()/100,
                longitude: ((locationManager.location?.coordinate.longitude)!*100).rounded()/100)
                loadData()
            }
        }
    }
    
    func getTime(timeZone: Int?) -> String{
        let f = ISO8601DateFormatter()
        f.formatOptions = .withFullTime
        f.timeZone = TimeZone(secondsFromGMT: timeZone!)
        
      return f.string(from: Date())
    }
   
    
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if(indexPath.section == 0 ){
            return UITableViewCell.EditingStyle.delete
        } else {
            return UITableViewCell.EditingStyle.none
        }
    }
    
    
    @IBAction func addCity(_ sender: Any) {
        let vc:MapSelectionViewController
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "MapSelectionViewController") as! MapSelectionViewController
        } else {
           vc = storyboard?.instantiateViewController(withIdentifier: "MapSelectionViewController") as! MapSelectionViewController
        }
        vc.weatherDataCollection = self.weatherData
        vc.isCelsius = self.isCelsius
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func setUnit(_ sender: UIButton) {
        print("setUnit", sender.tag)
        switch sender.tag {
            case 11:
                if !isCelsius! {
                    UserDefaults.standard.set(true, forKey: "isCelsius")
                    isCelsius = true
                    updateData()
                    self.cities.reloadData()
                }
            case 12:
                if isCelsius! {
                    UserDefaults.standard.set(false, forKey: "isCelsius")
                    isCelsius = false
                    updateData()
                    self.cities.reloadData()
                }
            default:
//                isCelsius = true
//                self.cities.reloadData()
            return

        }
        
    }
    
    func loadData() {
        print(weatherData.count)
        self.weatherData.removeAll()
        print(weatherData.count)
        for Coordinates in 0..<getAllPinDetails()!.count {
            BaseAPI.sharedInstance().getWeatherData(latitude: getAllPinDetails()![Coordinates].latitude,
                    longitude: getAllPinDetails()![Coordinates].longitude,
                    unit: isCelsius! ? "metric" : "imperial") { (weatherData, error) in
                if let weatherData = weatherData {
                    print(weatherData.timezone as Any)
                    self.weatherData.append(weatherData)
                    DispatchQueue.main.async {
                        self.cities.reloadData()
                    }

                } else {
                    print(error.debugDescription)
                }
            }
       }
    
    }
    
    func updateData() {
        print("updateData", isCelsius)
        if (weatherData.count > 0) {
            for index in 0..<weatherData.count {
            //for weather in weatherData {
                BaseAPI.sharedInstance().getWeatherData(latitude: weatherData[index]!.coord!.lat!,
                        longitude: weatherData[index]!.coord!.lon!,
                        unit: self.isCelsius! ? "metric" : "imperial") { (weatherData, error) in
                    if let weatherData = weatherData {
                        self.weatherData[index] = weatherData
                        DispatchQueue.main.async {
                            self.cities.reloadData()
                        }
                    } else {
                        print(error.debugDescription)
                    }
                }
            }
        }
        
    }
    
    public func getAllPinDetails() -> [SavedCoordinates]? {
        var pinDetails: [SavedCoordinates]?
        do {
            try pinDetails = CoreDataStackMethods.getSharedInstance().getAllCoordinates(entityName: SavedCoordinates.tableName) //CoreDataStackDetails.getSharedInstance().getAllPinDetails(entityName: PinDetails.tableName)
        } catch {
            showAlert(withTitle: "Error", message: "Error While Getting All The Pin coordinates: \(error)")
            
        }
        return pinDetails
    }
    
    
   
    
}

