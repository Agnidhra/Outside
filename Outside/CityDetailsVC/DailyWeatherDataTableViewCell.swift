//
//  DailyWeatherDataTableViewCell.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/21/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class DailyWeatherDataTableViewCell: UITableViewCell {
    
    class var identifier: String {
        return "WeekDayDetails"
    }
     
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var dayiCon: UIImageView!
    @IBOutlet weak var dayMaxTemp: UILabel!
    @IBOutlet weak var dayMinTemp: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
