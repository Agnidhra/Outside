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
    
    
    
    let locationManager = CLLocationManager()

    var weatherData: [WeatherData?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(getTime(timeZone: 1592657648))
        // Do any additional setup after loading the view.
        
        if !CLLocationManager.locationServicesEnabled() && !isCoordinateUpdated {
            // Ask for Authorisation from the User.
            self.locationManager.requestAlwaysAuthorization()

            // For use in foreground
            self.locationManager.requestWhenInUseAuthorization()
            
        }
            
        

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if locationManager.location != nil {
            if !isCoordinateUpdated {
                isCoordinateUpdated = true
                loadData(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
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
                loadData(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!)
//                BaseAPI.sharedInstance().getWeatherData(latitude: (locationManager.location?.coordinate.latitude)!,
//                        longitude: (locationManager.location?.coordinate.longitude)!,
//                        unit: isCelsius! ? "metric" : "imperial") { (weatherData, error) in
//                    if let weatherData = weatherData {
//                        print(weatherData.timezone as Any)
//                        self.weatherData.append(weatherData)
//                        DispatchQueue.main.async {
//                            self.cities.reloadData()
//                        }
//
//                    } else {
//                        print(error.debugDescription)
//                    }
//                }
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
        if(section == 0) {
            return weatherData.count
        } else {
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CityShortDetails", for: indexPath) as! CityShortDetailsCell
            cell.timeLabel?.text =  String(self.getTime(timeZone: weatherData[indexPath.row]?.timezone ?? nil).prefix(5))
            if let place = weatherData[indexPath.row]?.name, (weatherData[indexPath.row]?.name!.count)!>0 {
                cell.cityLabel?.text = place
            } else {
                cell.cityLabel?.text = "\(String(describing: weatherData[indexPath.row]!.coord!.lat!))\u{00B0} \(String(describing: weatherData[indexPath.row]!.coord!.lon!))\u{00B0}"
            }
            
            cell.temperatureLabel?.text = "\(String(describing: weatherData[indexPath.row]!.main!.temp!).prefix(2))\u{00B0}"
            
            if let backgroundImage = getImage(weather: weatherData[indexPath.row]?.weather[0]?.main) {
                       cell.customeBackground?.image = backgroundImage
                   }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UnitAndAddFooterTableViewCell", for: indexPath) as! UnitAndAddFooterTableViewCell
            cell.add?.setTitle("+", for: .normal)
            cell.celsius?.setTitle("\u{00B0}C  ", for: .normal)
            cell.celsius?.setTitle("\u{00B0}C  ", for: .highlighted)
            cell.farenhite?.setTitle("\u{00B0}F", for: .normal)
            cell.farenhite?.setTitle("\u{00B0}F", for: .highlighted)
            if isCelsius! {
//                cell.celsius?.titleLabel?.textColor = UIColor.yellow
//                cell.farenhite?.titleLabel?.textColor = UIColor.white
//                cell.celsius!.isHighlighted = false
//                cell.farenhite!.isHighlighted = false
            } else {
//                cell.celsius?.titleLabel?.textColor = UIColor.white
//                cell.farenhite?.titleLabel?.textColor = UIColor.yellow
//                cell.celsius?.isHighlighted = false
//                cell.farenhite?.isHighlighted = true
            }
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
            vc.weatherData = weatherData
            vc.cityRow = indexPath.row
            vc.isCelsius = self.isCelsius
            //vc.weatherData = weatherData[indexPath.row]
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            //numbers.remove(at: indexPath.row)
            weatherData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
    }
    
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        if(indexPath.row == 0 ){
//            return UITableViewCell.EditingStyle.none
//        } else {
//            return UITableViewCell.EditingStyle.delete
//        }
//    }
    
    
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
        switch sender.tag {
        case 1:
            isCelsius = true
            updateData()
            
        case 2:
            isCelsius = false
            updateData()
        default:
            isCelsius = true
        }
    }
    
    
    func loadData(latitude: Double, longitude: Double) {
        BaseAPI.sharedInstance().getWeatherData(latitude: (locationManager.location?.coordinate.latitude)!,
                longitude: (locationManager.location?.coordinate.longitude)!,
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
    
    func updateData() {
        if (weatherData.count > 0) {
            for index in 0..<weatherData.count {
            //for weather in weatherData {
                BaseAPI.sharedInstance().getWeatherData(latitude: weatherData[index]!.coord!.lat!,
                        longitude: weatherData[index]!.coord!.lon!,
                        unit: isCelsius! ? "metric" : "imperial") { (weatherData, error) in
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
    
}

