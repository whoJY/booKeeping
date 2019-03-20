//
//  EverydayDetailsTableViewCell.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/4.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

class EverydayDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var activityNameLabel: UILabel!
    
    @IBOutlet weak var activityIcon: UIImage!
    
    @IBOutlet weak var activityPrice: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
