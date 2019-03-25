//
//  ViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/1/17.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import CoreData
import SABlurImageView

class ViewController: UIViewController{
    
    @IBOutlet weak var orange: UIImageView!
    
    @IBOutlet var view1: UIView!
    
    var imageView:UIImage? = nil
    
    var timer:Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
//        imageView = SABlurImageView(image: orange.image)
//        imageView!.frame = CGRect.init(x: 0, y: 0, width: 414, height: 600)
//        imageView!.addBlurEffect(90, times: 1)
//
//        self.view1.addSubview(imageView!)
 
        //定时刷新设置的时间
//        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(ViewController.a), userInfo: nil, repeats: true)
        
    }
    
//    @objc func a(){
//
//        imageView!.configrationForBlurAnimation()
//        imageView!.startBlurAnimation(1.5)
//    }
   
    
}



