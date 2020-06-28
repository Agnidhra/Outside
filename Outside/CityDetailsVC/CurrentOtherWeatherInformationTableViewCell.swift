//
//  CurrentOtherWeatherInformationTableViewCell.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/21/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class CurrentOtherWeatherInformationTableViewCell: UITableViewCell {
    class var identifier: String {
        return "CurrentOtherWeatherInformation"
    }
    
    @IBOutlet weak var keyOne: UILabel!
    @IBOutlet weak var valueOne: UILabel!
    @IBOutlet weak var keyTwo: UILabel!
    @IBOutlet weak var valueTwo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
