//
//  CityDetailsVC.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/19/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class CityDetailsVC: UIViewController {
    
    var weatherData: WeatherData?
    var weatherDataDetailedCollection: [WeatherDataDetailed?] = []
    var currentOtherWeatherInformation:[[[String:String]]] = [] //= [[[:]]]
    
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
        cityName.text = weatherData?.name
        weather.text = weatherData?.weather[0].main
        currentTemperature.text = "\(String(describing: weatherData!.main.temp).prefix(2))\u{00B0}"
        
        BaseAPI.sharedInstance().getDetailedWeatherData(latitude: (weatherData?.coord.lat)!,
                longitude: (weatherData?.coord.lon)!) { (weatherDetailedData, error) in
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
        day.text = "\(DateFormatter().standaloneWeekdaySymbols![NSCalendar.current.component(.weekday, from: NSDate(timeIntervalSince1970: Double(weatherData!.dt)) as Date)-1]) today"
        maximumTemperature.text = "\(weatherData!.main.tempMax)\u{00B0}"
        minimumTemperature.text = "\(weatherData!.main.tempMin)\u{00B0}"
        
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
        self.currentOtherWeatherInformation.append([["SUNRISE": String(getTimeOfForecast(timeZone: weatherDataDetailedCollection.timezoneOffset
            , time: weatherDataDetailedCollection.current.sunrise).prefix(5))],
                                                    ["SUNSET":String(getTimeOfForecast(timeZone: weatherDataDetailedCollection.timezoneOffset, time: weatherDataDetailedCollection.current.sunset).prefix(5))]])
        
        self.currentOtherWeatherInformation.append([["FEELS LIKE":"\(String("\(weatherDataDetailedCollection.current.feelsLike)".prefix(2)))\u{00B0}"],
                                                ["PRESSURE":"\(round(Double(weatherDataDetailedCollection.current.pressure) * 0.02953)) inHg"]])
        
    
        self.currentOtherWeatherInformation.append([["HUMIDITY":"\(weatherDataDetailedCollection.current.humidity)%"],
                                                ["VISIBILITY":"\(String(describing: round(Double(weatherDataDetailedCollection.current.visibility!) * 0.000621371))) mi"]])
        
        self.currentOtherWeatherInformation.append([["WIND SPEED":"\(weatherDataDetailedCollection.current.windSpeed) mph"],
                                                ["CHANCES OF RAIN":"\(String(describing: weatherDataDetailedCollection.current.clouds!))%"]])
        self.currentOtherWeatherInformation.append([["UV INDEX":"\(String(describing: weatherDataDetailedCollection.current.uvi))"],
                                                ["DEW POINT":"\(String(describing: weatherDataDetailedCollection.current.dewPoint))\u{00B0}"]])
        
    }
    
    
    @IBAction func dismissCityDetailsPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
