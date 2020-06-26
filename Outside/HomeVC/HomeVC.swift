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
    
    let locationManager = CLLocationManager()

    var weatherData: [WeatherData?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getTime(timeZone: 1592657648))
        // Do any additional setup after loading the view.
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if locationManager.location != nil {
            if !isCoordinateUpdated {
                isCoordinateUpdated = true
                BaseAPI.sharedInstance().getWeatherData(latitude: (locationManager.location?.coordinate.latitude)!,
                        longitude: (locationManager.location?.coordinate.longitude)!) { (weatherData, error) in
                    if let weatherData = weatherData {
                        print(weatherData.timezone)
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
    }

    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(!self.isCoordinateUpdated) {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
                return }
            print("locations = \(locValue.latitude) \(locValue.longitude)")
            isCoordinateUpdated = true
            if weatherData.count == 0 {
                BaseAPI.sharedInstance().getWeatherData(latitude: (locationManager.location?.coordinate.latitude)!,
                        longitude: (locationManager.location?.coordinate.longitude)!) { (weatherData, error) in
                    if let weatherData = weatherData {
                        print(weatherData.timezone)
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
        
        
    }
    
    func getTime(timeZone: Int?) -> String{
        let f = ISO8601DateFormatter()
        f.formatOptions = .withFullTime
        f.timeZone = TimeZone(secondsFromGMT: timeZone!)
        
      return f.string(from: Date())
    }
   
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityShortDetails", for: indexPath) as! CityShortDetailsCell
            cell.timeLabel?.text =  String(self.getTime(timeZone: weatherData[0]?.timezone ?? nil).prefix(5))
            cell.cityLabel?.text = weatherData[0]?.name
            cell.temperatureLabel?.text = "\(String(describing: weatherData[0]!.main.temp) )\u{00B0}"
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnitAndAddFooterTableViewCell", for: indexPath) as! UnitAndAddFooterTableViewCell
            cell.add?.setTitle("+", for: .normal)
            cell.celsius?.setTitle("\u{00B0}C  ", for: .normal)
            cell.farenhite?.setTitle("\u{00B0}F", for: .normal)
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 0) {
            let vc:CityDetailsVC
            if #available(iOS 13.0, *) {
                vc = storyboard?.instantiateViewController(identifier: "CityDetails") as! CityDetailsVC
            } else {
               vc = storyboard?.instantiateViewController(withIdentifier: "CityDetails") as! CityDetailsVC
            }
            vc.weatherData = weatherData[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
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
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
        
    }
    
    
}

