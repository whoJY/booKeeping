//
//  shareDateTableViewCell.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/9.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

class shareDateTableViewCell: UITableViewCell {

    @IBOutlet weak var tips: UILabel!
    
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
