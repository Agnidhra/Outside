//
//  CityDetailsVCExtensionForHourlyWeatherCollectionView.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import Foundation
import UIKit

extension CityDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Show Value of Next 24 Hours
        return 24
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyWeatherCollectionViewCell.identifier, for: indexPath) as! HourlyWeatherCollectionViewCell
        if weatherDataDetailedCollection.count > 0 {
            let hourly: Hourly = (weatherDataDetailedCollection[0]?.hourly[indexPath.row])!
            DispatchQueue.main.async {
                cell.sizeToFit()
                cell.hourlyTime.text = String(self.getTimeOfForecast(timeZone: self.weatherDataDetailedCollection[0]?.timezoneOffset, time: hourly.dt).prefix(2))
                cell.weatherIcon.image = UIImage(named: hourly.weather[0].icon)
                cell.weatherIcon.isHidden = false
                cell.weatherIcon.isHighlighted = false
                cell.weatherIcon.reloadInputViews()
                cell.hourlyTemperature.text = "\(String("\(hourly.temp)".prefix(2)))\u{00B0}"
            }
        }
        return cell
    }
}
