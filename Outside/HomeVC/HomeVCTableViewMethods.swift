//
//  HomeVCTableViewMethods.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/27/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

extension HomeVC {
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
                checkAndDeleteData(latitude: (weatherData[indexPath.row]?.coord?.lat)!, longitude: (weatherData[indexPath.row]?.coord?.lon)!)
                self.weatherData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
        }
}
