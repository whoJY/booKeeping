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
    
    var activity = ["体检","感冒药","洗牙","买牛奶","买水果","吃烧烤","滴滴打车","机票","充话费","流量包","买衣服","买裤子","鞋","考研英语","考研政治","考研数学","考研专业课","购物","捐款给红十字会","猫粮","猫砂","狗粮"]
    
    func randomData()->(name:String,kind:String,price:Double){
        let ran = 21.arc4random
        let name  = activity[ran]
        var kind = ""
        if (ran<=2){
            kind = "health"
        }else if (ran <= 5){
            kind = "eat"
        }else if (ran <= 7){
            kind = "traffic"
        }else if (ran <= 9){
            kind = "communication"
        }else if (ran <= 12){
         kind = "clothes"
        }else if (ran <= 16){
            kind = "study"
        }else if (ran <= 18){
            kind = "others"
        }else {
            kind = "pets"
        }
        let price = 370.arc4random + 30
        
        return (name,kind,Double(price))
        
    }
    
    
    /// 将ncr转为string
    ///
    /// - Parameter ncr: ncr 字符
    /// - Returns: 转换后的string
    func ncrToString(_ ncr:String)->String{
        let data = ncr.data(using: .utf8)
        
        do {
            let attributedString = try NSAttributedString(data: data!, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            return attributedString.string
        } catch {
            return ""
        }
    }
    
    
    
    
    
    
    
    
    
}
//String.randomStr(len: 30)
