//
//  JsonUtil.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/13.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import Foundation
class JsonUtil {
    
    
    func convertArrToJsonStr(_ consArr:[Consumption])->String{
        var json :String = ""
        do {
            
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(consArr)
            json = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
            
        }catch
        {
            print("convert to json Str err")
        }
        
        return json
    }
    
    
    // Convert from NSData to json object
    func nsdataToJSON(data: NSData) -> AnyObject? {
        do {
            return try JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers) as AnyObject
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil
    }
    
    // Convert from JSON to nsdata
    func jsonToNSData(json: AnyObject) -> NSData?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
    
    //convert any to json
    func convertToJson(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    func parseCurrencyResJsonByhand(_ jsonStr:String)->(rate:Double,updateTime:String){
        //去除[、]、"、:和{
        var  originStr = jsonStr.replacingOccurrences(of: "]", with: "")
        originStr = originStr.replacingOccurrences(of: "{", with: "")
        originStr = originStr.replacingOccurrences(of: "\"", with: "")
        originStr = originStr.replacingOccurrences(of: "}", with: "")
        var subStr0 = originStr.components(separatedBy: "rate:")
        var subStr1 = subStr0[1].components(separatedBy: ",update:")
        let rate = Double(subStr1[0])
        let time = subStr1[1]

        return (rate!,time)
    }
    
    
    func parseDetailsJsonByhand(_ jsonStr:String)->[Consumption]{
        //去除[、]、"、:和{

      var  originStr = jsonStr.replacingOccurrences(of: "]", with: "")
        originStr = originStr.replacingOccurrences(of: "{", with: "")
        originStr = originStr.replacingOccurrences(of: "\"", with: "")
    
        
        var cons = [Consumption]()
        
        let str = originStr.components(separatedBy: "},")
        for subStr in str{
            //最后一个数据有个}
            let subStrStart  = subStr.replacingOccurrences(of: "}", with: "")
            //去除id
            let   subStr0 = subStrStart.replacingOccurrences(of: "[id:", with: "")
            var subStr1 = subStr0.components(separatedBy: ",user_id:")
            let id = subStr1[0] //得到id值
            subStr1 = subStr1[1].components(separatedBy: ",name:")
            let user_id = subStr1[0] //得到user_id
            subStr1 = subStr1[1].components(separatedBy: ",kind:")
            let name = subStr1[0]//得到name
            subStr1 = subStr1[1].components(separatedBy: ",price:")
            let kind = subStr1[0]//得到kind
            subStr1 = subStr1[1].components(separatedBy: ",date:")
            let price = subStr1[0]//得到price
            let dateStr = subStr1[1]//得到dateStr
            let consTemp : Consumption =   Consumption(id: id, user_id: user_id, name: name, kind: kind, price: Double(price)!, date: dateStr)
            cons.append(consTemp)
        }
        
        
        return cons
        
    }
    
}
