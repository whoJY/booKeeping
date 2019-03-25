//
//  Finger.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/2.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import Foundation
import  UIKit
import  LocalAuthentication
class Finger {
    
    static var result = false
    public static  var finished = false
    
    func userFigerprintAuthenticationTipStr(_ tipsStr: String){
        let context = LAContext()
        var error: NSError? = nil
        var res = false
        // 判断设备是否支持指纹解锁
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error){
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: tipsStr, reply: { (success, error) in
                if success {
                    //结果为true，完成为true。
                    res = true
                    Finger.result = true
                    Finger.finished = true
                    
                    print("TouchID/FaceID验证成功,error is \(String(describing: error)) ,res is \(res)")
                } else {  //其他所有情况结果为false，完成为true。
                    switch Int32(error!._code) {
                    // 身份验证失败
                    case kLAErrorAuthenticationFailed:
                        print("LAErrorAuthenticationFailed")
                        
                        //
                        Finger.result = false
                        Finger.finished = true
                        break;
                    case kLAErrorUserCancel :
                        
                        print("kLAErrorUserCancel")
                        // 用户取消
                        Finger.result = false
                        Finger.finished = true
                        break
                        
                        //验证失败
                        
                    case kLAErrorUserFallback:
                        
                        print("LAErrorUserFallback")
                        
                        Finger.result = false
                        Finger.finished = true
                        
                        break;
                        
                        // 被系统取消，例如按下电源键
                        
                    case kLAErrorSystemCancel:
                        
                        print("kLAErrorSystemCancel")
                        
                        Finger.result = false
                        Finger.finished = true
                        break;
                        
                        // 设备上并不具备密码设置信息，也就是说Touch ID功能处于被禁用状态
                        
                    case kLAErrorPasscodeNotSet:
                        
                        print("kLAErrorPasscodeNotSet")
                        
                        Finger.result = false
                        Finger.finished = true
                        break;
                        
                        // 设备本身并不具备指纹传感装置
                        
                    case kLAErrorTouchIDNotAvailable:
                        
                        print("kLAErrorTouchIDNotAvailable")
                        Finger.result = false
                        Finger.finished = true
                        break;
                        
                        // 已经设定有密码机制，但设备配置当中还没有保存过任何指纹内容
                        
                    case kLAErrorTouchIDNotEnrolled:
                        
                        print("kLAErrorTouchIDNotEnrolled")
                        Finger.result = false
                        Finger.finished = true
                        break;
                        
                        // 输入次数过多验证被锁
                        
                    case kLAErrorTouchIDLockout:
                        
                        print("kLAErrorTouchIDLockout")
                        break;
                        
                        // app取消验证
                        
                    case kLAErrorAppCancel:
                        
                        print("LAErrorAppCancel")
                        Finger.result = false
                        Finger.finished = true
                        break;
                        
                        // 无效的上下文
                        
                    case kLAErrorInvalidContext:
                        
                        print("LAErrorAppCancel")
                        Finger.result = false
                        Finger.finished = true
                        break;
                        
                    default:
                        
                        break
                        
                    }
                    
                }
                
            })
            
        } else {
            print("您的设备不支持touch id")
            
        }
        
    }
    
    
    
}
