//
//  CityDetailsVC.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/19/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class CityDetailsVC: UIViewController {
    
    //MARK:- Properties
    var weatherData: [WeatherData?] = []
    var cityRow: Int?
    
    //Below property is kept as collection to enhance the Details view for collection fo Cities for now it shows a single city
    var weatherDataDetailedCollection: [WeatherDataDetailed?] = []
    var currentOtherWeatherInformation:[[[String:String]]] = []
    
    //MARK:- Outlets
    
    //Custom background and Activity Indicator
    @IBOutlet weak var customBackground: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //City Name And Weather Outlet
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var currentTemperature: UILabel!
    
    //Day Section Outlets
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var maximumTemperature: UILabel!
    @IBOutlet weak var minimumTemperature: UILabel!
    
    
    //Hourly Data Outlets
    @IBOutlet weak var hourlyWeatherData: UICollectionView!
    @IBOutlet weak var hourlyWeatherDataView: UIView!
    
    //Weekly Weather Data
    @IBOutlet weak var weekDayTemperatureTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        //Setting Custom background based on Api Data.
        if let backgroundImage = getImage(weather: weatherData[cityRow!]?.weather[0]?.main) {
            customBackground.image = backgroundImage
        }
        
        //Updating different fields based on API data.
        if let place = weatherData[cityRow!]?.name, (weatherData[cityRow!]!.name!.count)>0 {
            cityName.text = place
        } else {
            cityName.text = "\(String(describing: weatherData[cityRow!]!.coord!.lat!))\u{00B0} \(String(describing: weatherData[cityRow!]!.coord!.lon!))\u{00B0}"
        }
        weather.text = weatherData[cityRow!]?.weather[0]?.main
        currentTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.temp!).strstr(needle: ".", beforeNeedle: true)!)\u{00B0}"
        
        //Calling API to get and set the City Hourly and weekly data
        BaseAPI.sharedInstance().getDetailedWeatherData(latitude: (weatherData[cityRow!]!.coord?.lat)!,
                                                        longitude: (weatherData[cityRow!]!.coord?.lon)!,
                                                        unit: UserDefaults.standard.bool(forKey: "isCelsius") ? "metric" : "imperial"
        ) { (weatherDetailedData, error) in
            if let weatherDetailedData = weatherDetailedData {
                self.weatherDataDetailedCollection.append(weatherDetailedData)
                DispatchQueue.main.async {
                    self.hourlyWeatherData.reloadData()
                    self.updateCurrentOtherWeatherInformation(weatherDataDetailedCollection: weatherDetailedData)
                    self.weekDayTemperatureTable.reloadData()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
            } else {
                print(error.debugDescription)
            }
        }
        
        //Code to Calculate and update the day and Max / Min Temperature field based on the Api Response.
        day.text = "\(DateFormatter().standaloneWeekdaySymbols![NSCalendar.current.component(.weekday, from: NSDate(timeIntervalSince1970: (weatherData[cityRow!]!.dt!)) as Date)-1]) today"
        maximumTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.tempMax!))\u{00B0}"
        minimumTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.tempMin!))\u{00B0}"
    }
    
    
    //MARK:- Method to Calculate Local Time zone based out of GMT Offset data from Api.
    func getTimeOfForecast(timeZone: Int?, time: Int?) -> String{
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullTime]
        f.timeZone = TimeZone(secondsFromGMT: timeZone!)
        return f.string(from:
            NSDate(timeIntervalSince1970: Double(time!)) as Date)
    }

    //MARK:- Method to Update City Sepcific Weather Details for the day. Sunrise / Sunset / Feels Like / Pressure / Wind speed / Chance of Rain / Humidity / Visibility / UV Index / Dew POint
    func updateCurrentOtherWeatherInformation(weatherDataDetailedCollection: WeatherDataDetailed) {
       
        if let timezoneOffset = weatherDataDetailedCollection.timezoneOffset {
            if let current = weatherDataDetailedCollection.current {
                if let sunrise = current.sunrise, let sunset = current.sunset {
                    self.currentOtherWeatherInformation.append([["SUNRISE": String(getTimeOfForecast(timeZone: timezoneOffset, time: Int(sunrise)).prefix(5))],
                            ["SUNSET":String(getTimeOfForecast(timeZone: timezoneOffset, time: Int(sunset)).prefix(5))]])
                }
            }
        } else {
            self.currentOtherWeatherInformation.append([["SUNRISE": "--"], ["SUNSET": "--"]])
        }
        
        if let current = weatherDataDetailedCollection.current {
            if let feelsLike = current.feelsLike, let pressure = current.pressure {
                self.currentOtherWeatherInformation.append([["FEELS LIKE":"\(String("\(feelsLike)".strstr(needle: ".", beforeNeedle: true)!))\u{00B0}"],
                ["PRESSURE":"\(round(Double(pressure) * 0.02953)) inHg"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["FEELS LIKE":"--"], ["PRESSURE":"--"]])
        }

        if let current = weatherDataDetailedCollection.current {
            if let humidity = current.humidity, let visibility = current.visibility {
                self.currentOtherWeatherInformation.append([["HUMIDITY":"\(humidity)%"],
                ["VISIBILITY":"\(String(describing: round(Double(visibility) * 0.000621371))) mi"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["HUMIDITY":"--"], ["VISIBILITY":"--"]])
        }
        
        if let current = weatherDataDetailedCollection.current {
            if let windSpeed = current.windSpeed, let clouds = current.clouds {
                self.currentOtherWeatherInformation.append([["WIND SPEED":"\(windSpeed) mph"],
                ["CHANCES OF RAIN":"\(String(describing: clouds))%"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["WIND SPEED":"--"], ["CHANCES OF RAIN":"--"]])
        }

        if let current = weatherDataDetailedCollection.current {
            if let uvi = current.uvi, let dewPoint = current.dewPoint {
                self.currentOtherWeatherInformation.append([["UV INDEX":"\(String(uvi))"],
                ["DEW POINT":"\(String(dewPoint))\u{00B0}"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["UV INDEX":"--"], ["DEW POINT":"--"]])
        }
    }
    
    //MARK:- Navigation Method to Home Page
    @IBAction func dismissCityDetailsPage(_ sender: Any) {
        let vc:HomeVC
        if #available(iOS 13.0, *) {
            vc = storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
        } else {
           vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    //var zeroHeightConstraint: NSLayoutConstraint?
    
    //MARK:- Scroll Method WIP
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        //Code to be written to hide section on scrolling
//        if (scrollView == weekDayTemperatureTable) {
//            let scrollViewContentHeight = scrollView.contentSize.height
//            let scrollViewHeight = scrollView.frame.height
//            if scrollView.contentOffset.y < (scrollViewContentHeight - scrollViewHeight){
//                //Custom view show
//                var newFrame : CGRect = hourlyWeatherData.frame
//                  newFrame.size.height = 100
//
//                  UIView.animate(withDuration: 0.25, animations:{
//                    self.hourlyWeatherData.frame = newFrame;
//                    self.hourlyWeatherData.isHidden = false
//                  },completion : nil)
//                hourlyWeatherDataView.frame = CGRect(x: hourlyWeatherDataView.frame.maxX, y: hourlyWeatherDataView.frame.maxY, width: hourlyWeatherDataView.frame.width, height: 100)
//                
//            }else{
//                var newFrame : CGRect = hourlyWeatherData.frame
//                newFrame.size.height = 0
//                
//                UIView.animate(withDuration: 0.25, animations:{
//                    self.hourlyWeatherData.frame = newFrame;
//                    self.hourlyWeatherData.isHidden = true
//                },completion : nil)
//                hourlyWeatherDataView.frame = CGRect(x: hourlyWeatherDataView.frame.maxX, y: hourlyWeatherDataView.frame.maxY, width: hourlyWeatherDataView.frame.width, height: 0)
//
//                weekDayTemperatureTable.readableContentGuide
//                //hourlyWeatherDataView.reloadInputViews()
//                
//            }
//        }
//    }
    
}
