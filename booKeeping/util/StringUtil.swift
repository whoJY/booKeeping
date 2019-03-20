//
//  StringUtil.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/28.
//  Copyright © 2019 hujinyu. All rights reserved.
//

/// 随机字符串生成
extension String{
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len : Int) -> String{
        var ranStr = ""
        for _ in 0..<len {
            let index = random_str_characters.count.arc4random
        ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    static let random_kinds = ["eat","pets","traffic","others","clothes","study","health","communication"]
    static func randomKind() -> String{
        return random_kinds[((random_kinds.count).arc4random)]
    }
    
   
    
}
import Foundation
class StringUtil {

    //将data转为string
    func dataToNSString(data:Data?)->NSString?{
        
        return NSString(data:data! ,encoding: String.Encoding.utf8.rawValue)
    }
    
    
}
//String.randomStr(len: 30)
