//
//  HourlyWeatherCollectionViewCell.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/20/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class HourlyWeatherCollectionViewCell: UICollectionViewCell {
    class var identifier: String {
        return "HourlyWeather"
    }
    
    @IBOutlet weak var hourlyTime: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var hourlyTemperature: UILabel!

}
