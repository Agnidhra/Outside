//
//  CityShortDetailsCell.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/19/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class CityShortDetailsCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel:UILabel?
    @IBOutlet weak var cityLabel:UILabel?
    @IBOutlet weak var temperatureLabel:UILabel?
    @IBOutlet weak var customeBackground:UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
