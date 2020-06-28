//
//  UnitAndAddFooterTableViewCell.swift
//  Outside
//
//  Created by Agnidhra Gangopadhyay on 6/22/20.
//  Copyright © 2020 Agnidhra Gangopadhyay. All rights reserved.
//

import UIKit

class UnitAndAddFooterTableViewCell: UITableViewCell {

    @IBOutlet weak var celsius:UIButton?
    @IBOutlet weak var farenhite:UIButton?
    @IBOutlet weak var add:UIButton?
      
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
