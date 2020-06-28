//
//  CityDetailsVC.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/19/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class CityDetailsVC: UIViewController {
    
    //var weatherData: WeatherData?
    var weatherData: [WeatherData?] = []
    var cityRow: Int?
    var isCelsius: Bool? = true
    var weatherDataDetailedCollection: [WeatherDataDetailed?] = []
    var currentOtherWeatherInformation:[[[String:String]]] = [] //= [[[:]]]
    
    
    @IBOutlet weak var customBackground: UIImageView!
    
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
        
        if let backgroundImage = getImage(weather: weatherData[cityRow!]?.weather[0]?.main) {
            customBackground.image = backgroundImage
        }
        
        if let place = weatherData[cityRow!]?.name, (weatherData[cityRow!]!.name!.count)>0 {
            cityName.text = place
        } else {
            cityName.text = "\(String(describing: weatherData[cityRow!]!.coord!.lat!))\u{00B0} \(String(describing: weatherData[cityRow!]!.coord!.lon!))\u{00B0}"
        }
        
        //cityName.text = weatherData[cityRow!]?.name
        weather.text = weatherData[cityRow!]?.weather[0]?.main
        //currentTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.temp!).prefix(2))\u{00B0}"
        currentTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.temp!).strstr(needle: ".", beforeNeedle: true)!)\u{00B0}"
        
        BaseAPI.sharedInstance().getDetailedWeatherData(latitude: (weatherData[cityRow!]!.coord?.lat)!,
                                                        longitude: (weatherData[cityRow!]!.coord?.lon)!,
                                                        unit: isCelsius! ? "metric" : "imperial"
        ) { (weatherDetailedData, error) in
            if let weatherDetailedData = weatherDetailedData {
                self.weatherDataDetailedCollection.append(weatherDetailedData)
                DispatchQueue.main.async {
                    self.hourlyWeatherData.reloadData()
                    self.updateCurrentOtherWeatherInformation(weatherDataDetailedCollection: weatherDetailedData)
                    self.weekDayTemperatureTable.reloadData()
                }
            } else {
                print(error.debugDescription)
            }
        }
        
        day.text = "\(DateFormatter().standaloneWeekdaySymbols![NSCalendar.current.component(.weekday, from: NSDate(timeIntervalSince1970: (weatherData[cityRow!]!.dt!)) as Date)-1]) today"
        maximumTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.tempMax!))\u{00B0}"
        minimumTemperature.text = "\(String(describing: weatherData[cityRow!]!.main!.tempMin!))\u{00B0}"
        
        //let screenSize: CGRect = UIScreen.main.bounds
        //scrollDataView.contentSize = CGSize(width: self.view.frame.width, height: screenSize.height)
    }
    
    
    
    
    override func viewDidLayoutSubviews() {
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getTimeOfForecast(timeZone: Int?, time: Int?) -> String{
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullTime]
        f.timeZone = TimeZone(secondsFromGMT: timeZone!)
        return f.string(from:
            NSDate(timeIntervalSince1970: Double(time!)) as Date)
    }

    
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
        
        
//        self.currentOtherWeatherInformation.append([["SUNRISE": String(getTimeOfForecast(timeZone: weatherDataDetailedCollection.timezoneOffset
//            , time: Int(weatherDataDetailedCollection.current!.sunrise!)).prefix(5))],`
//
//                                                    ["SUNSET":String(getTimeOfForecast(timeZone: weatherDataDetailedCollection.timezoneOffset, time: Int(weatherDataDetailedCollection.current!.sunset!)).prefix(5))]])
        
        if let current = weatherDataDetailedCollection.current {
            if let feelsLike = current.feelsLike, let pressure = current.pressure {
                self.currentOtherWeatherInformation.append([["FEELS LIKE":"\(String("\(feelsLike)".strstr(needle: ".", beforeNeedle: true)!))\u{00B0}"],
                ["PRESSURE":"\(round(Double(pressure) * 0.02953)) inHg"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["FEELS LIKE":"--"],
            ["PRESSURE":"--"]])
        }
        
//        self.currentOtherWeatherInformation.append([["FEELS LIKE":"\(String("\(weatherDataDetailedCollection.current!.feelsLike!)".prefix(2)))\u{00B0}"],
//                                                ["PRESSURE":"\(round(Double(weatherDataDetailedCollection.current!.pressure!) * 0.02953)) inHg"]])
        
        if let current = weatherDataDetailedCollection.current {
            if let humidity = current.humidity, let visibility = current.visibility {
                self.currentOtherWeatherInformation.append([["HUMIDITY":"\(humidity)%"],
                ["VISIBILITY":"\(String(describing: round(Double(visibility) * 0.000621371))) mi"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["HUMIDITY":"--"],
            ["VISIBILITY":"--"]])
        }

//        self.currentOtherWeatherInformation.append([["HUMIDITY":"\(weatherDataDetailedCollection.current!.humidity!)%"],
//                                                ["VISIBILITY":"\(String(describing: round(Double(weatherDataDetailedCollection.current!.visibility!) * 0.000621371))) mi"]])
        
        if let current = weatherDataDetailedCollection.current {
            if let windSpeed = current.windSpeed, let clouds = current.clouds {
                self.currentOtherWeatherInformation.append([["WIND SPEED":"\(windSpeed) mph"],
                ["CHANCES OF RAIN":"\(String(describing: clouds))%"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["WIND SPEED":"--"],
            ["CHANCES OF RAIN":"--"]])
        }
        
//        self.currentOtherWeatherInformation.append([["WIND SPEED":"\(weatherDataDetailedCollection.current!.windSpeed!) mph"],
//                                                ["CHANCES OF RAIN":"\(String(describing: weatherDataDetailedCollection.current!.clouds!))%"]])
        if let current = weatherDataDetailedCollection.current {
            if let uvi = current.uvi, let dewPoint = current.dewPoint {
                self.currentOtherWeatherInformation.append([["UV INDEX":"\(String(uvi))"],
                ["DEW POINT":"\(String(dewPoint))\u{00B0}"]])
            }
        } else {
            self.currentOtherWeatherInformation.append([["UV INDEX":"--"],
                                                    ["DEW POINT":"--"]])
        }
        
//        self.currentOtherWeatherInformation.append([["UV INDEX":"\(String(describing: weatherDataDetailedCollection.current!.uvi!))"],
//                                                ["DEW POINT":"\(String(describing: weatherDataDetailedCollection.current!.dewPoint!))\u{00B0}"]])
        
    }
    
    
    @IBAction func dismissCityDetailsPage(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        let vc:HomeVC
                if #available(iOS 13.0, *) {
                    vc = storyboard?.instantiateViewController(identifier: "HomeVC") as! HomeVC
                } else {
                   vc = storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                }
        //        vc.weatherData = self.weatherDataCollection
        //        vc.isCoordinateUpdated = true
                vc.isCelsius = self.isCelsius
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Code to be written to hide section on scrolling
        //print(scrollView.contentOffset)
    }
}
