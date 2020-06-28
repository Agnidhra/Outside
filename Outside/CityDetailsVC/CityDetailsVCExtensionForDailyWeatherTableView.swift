//
//  CityDetailsVCExtensionForDailyWeatherTableView.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/21/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

extension CityDetailsVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            if(weatherDataDetailedCollection.count>0 && section == 0) {
                print(weatherDataDetailedCollection[0]!.daily.count)
                return weatherDataDetailedCollection[0]!.daily.count
            } else {
                return 0
            }
        } else {
            return self.currentOtherWeatherInformation.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WeekDayDetails", for: indexPath) as! DailyWeatherDataTableViewCell
            cell.dayName.text = "\(DateFormatter().standaloneWeekdaySymbols![NSCalendar.current.component(.weekday, from: NSDate(timeIntervalSince1970: Double(weatherDataDetailedCollection[0]!.daily[indexPath.row]!.dt!)) as Date)-1])"
            cell.dayiCon.image = UIImage(named: weatherDataDetailedCollection[0]!.daily[indexPath.row]!.weather[0]!.icon!)
            cell.dayMaxTemp.text = String("\(weatherDataDetailedCollection[0]!.daily[indexPath.row]!.temp!.max!)".strstr(needle: ".", beforeNeedle: true)!)
            cell.dayMinTemp.text = String("\(weatherDataDetailedCollection[0]!.daily[indexPath.row]!.temp!.min!)".strstr(needle: ".", beforeNeedle: true)!)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentOtherWeatherInformation", for: indexPath) as! CurrentOtherWeatherInformationTableViewCell
            cell.keyOne.text = "\(String(describing: self.currentOtherWeatherInformation[indexPath.row][0].keys.first!))"
            cell.valueOne.text = "\(String(describing: (self.currentOtherWeatherInformation[indexPath.row][0].values.first!)))"
            cell.keyTwo.text = "\(self.currentOtherWeatherInformation[indexPath.row][1].keys.first!)"
            cell.valueTwo.text = "\(String(describing: (self.currentOtherWeatherInformation[indexPath.row][1].values.first!)))"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return CGFloat(85)
        } else {
            return CGFloat(35)
        }
    }
    
    
    
    
}
