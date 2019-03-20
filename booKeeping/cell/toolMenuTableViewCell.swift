//
//  toolMenuTableViewCell.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/1.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

class toolMenuTableViewCell: UITableViewCell {
    @IBOutlet weak var menuIcon: UIImageView!
    
    @IBOutlet weak var menuName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
