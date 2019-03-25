//
//  rootViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/21.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import CoreData

class rootViewController: UITabBarController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    static var passed = false
    
    override func viewDidLoad() {
        print("root view")
        super.viewDidLoad()
    }


}
