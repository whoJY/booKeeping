//
//  Consumption.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/21.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import Foundation
struct Consumption:Codable {
    var id :String
    var user_id :String
    var name :String
    var kind :String
    var price :Double
    var date :String
}
