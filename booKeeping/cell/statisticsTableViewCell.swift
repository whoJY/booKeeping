//
//  statisticsTableViewCell.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/6.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

class statisticsTableViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var money: UILabel!
    @IBOutlet weak var percent: UILabel!
    @IBOutlet weak var sliderPercent: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
