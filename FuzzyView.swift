//
//  FuzzyView.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/17.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

/**
 *  毛玻璃效果的View
 */
class FuzzyView : UIView {
    private let view: UIToolbar!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
        
        self.view = UIToolbar(frame: self.bounds)
        self.view.backgroundColor = UIColor.clearColor()
        self.view.userInteractionEnabled = false
        self.layer.addSublayer(self.view.layer)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.view.frame = self.bounds
    }
    
    //MARK:- Touch Event
    // 让其支持拖动
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {}
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        if touches.count >= 1 {
            let touch = touches.anyObject() as UITouch
            let pointPrevious = touch.previousLocationInView(self)
            let point = touch.locationInView(self)
            
            var center = self.center
            center.x += point.x - pointPrevious.x
            center.y += point.y - pointPrevious.y
            self.center = center
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {}
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
    }
    
}
