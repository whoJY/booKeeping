//
//  DateUtil.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/1.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import Foundation
class DateUtil {

//将String转为date，返回yyyy-MM-dd
func StringToDate(_ dateStr:String)->Date{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyy-MM-dd"
    let dateTime = dateFormatter.date(from: dateStr)
    return dateTime!
}

    //将String转为date，返回yyyy-MM-dd
    func StringToDateYMDHMS(_ dateStr:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss" 
        let dateTime = dateFormatter.date(from: dateStr)
        return dateTime!
    }
    
    
//dateh转String  yyyy-MM-dd
func DateToString(_ date:Date)->String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
    let stringTime = dateFormatter.string(from: date)
    return stringTime
}

    //dateh转String  yyyy-MM-dd
    func DateToStringYMD(_ date:Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyy-MM-dd"
        let stringTime = dateFormatter.string(from: date)
        return stringTime
    }

    
    //date转时间戳
    func dateToInt(_ date:Date)->Int{
       
        
        let interval = Int(date.timeIntervalSince1970)
        return interval
    }

    
    func StringToInt(_ dateString:String)->NSDate{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let res = formatter.date(from: dateString)
        return res! as NSDate
    }
    
    func  nsDateToInt(_ date1:String)->Int{
        //传入带微秒的日期格式
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd"
        let date = formater.date(from: date1)
        let interval = ((date ?? Date()).timeIntervalSince1970)/2.70458
        
        return Int(interval)
    }
    
    

//给定一个日期计算是周几
func getWeekDay(dateTime:String)->Int{
    let dateFmt = DateFormatter()
    dateFmt.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let date = dateFmt.date(from: dateTime)
    let interval = Int(date!.timeIntervalSince1970)
    let days = Int(interval/86400) // 24*60*60
    let weekday = ((days + 4)%7+7)%7
    print("weekday is \(weekday)")
    return weekday
}



//本周开始日期（星期天）
func startOfThisWeek(_ date:Date) -> Date {
    let calendar = NSCalendar.current
    let components = calendar.dateComponents(
        Set<Calendar.Component>([.yearForWeekOfYear, .weekOfYear]), from: date)
    let startOfWeek = calendar.date(from: components)!
    print("本周开始于:\(DateToString(startOfWeek))")
    return startOfWeek
}

    //本月开始日期
    func startOfCurrentMonth(_ date:Date) -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(
            Set<Calendar.Component>([.year, .month]), from: date)
        let startOfMonth = calendar.date(from: components)!
        return startOfMonth
    }

    
    //指定年月的开始日期
    func startOfMonth(year: Int, month: Int) -> Date {
        let calendar = NSCalendar.current
        var startComps = DateComponents()
        startComps.day = 1
        startComps.month = month
        startComps.year = year
        let startDate = calendar.date(from: startComps)!
        return startDate
    }
    
    //指定年月的结束日期
    func endOfMonth(year: Int, month: Int, returnEndTime:Bool = false) -> Date {
        let calendar = NSCalendar.current
        var components = DateComponents()
        components.month = 1
        if returnEndTime {
            components.second = -1
        } else {
            components.day = -1
        }
        
        let endOfYear = calendar.date(byAdding: components,
                                      to: startOfMonth(year: year, month:month))!
        return endOfYear
    }
    
    
    //本年开始日期
    func startOfCurrentYear(_ date:Date) -> Date {
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(Set<Calendar.Component>([.year]), from: date)
        let startOfYear = calendar.date(from: components)!
        return startOfYear
    }
    
    
//    //本年结束日期
//    func endOfCurrentYear(returnEndTime:Bool = false) -> Date {
//        let calendar = NSCalendar.current
//        var components = DatefComponents()
//        components.year = 1
//        if returnEndTime {
//            components.second = -1
//        } else {
//            components.day = -1
//        }
//        
//        let endOfYear = calendar.date(byAdding: components, to: startOfCurrentYear())!
//        return endOfYear
//    }
    
}


