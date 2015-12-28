//
//  customCell.swift
//  kugpa222
//
//  Created by Ekin Akyürek and Ali Mert Türker  on 7.10.2015.
//  Copyright © 2015 Mellon App. All rights reserved.
//
import UIKit


class customCell: UITableViewCell {
    
    @IBOutlet var title: UILabel!
    @IBOutlet var plus: UIButton!
    @IBOutlet var textField: UILabel!
    @IBOutlet var minus: UIButton!
    @IBOutlet var detail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
