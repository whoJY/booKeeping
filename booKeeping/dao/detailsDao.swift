//
//  detailsDao.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/28.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import CoreData
import Realm
import RealmSwift

class DetailsDao{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //存账单数据
    func saveDao(_ detailName:String,_ detailPrice:Double,_ detailDate:Date,_ kind:String,_ photoName:String){
        let newDetail =  EverydayDetails(context: context)
        newDetail.name = detailName
        newDetail.price = detailPrice
        newDetail.date = detailDate
        newDetail.kind = kind
//        newDetail.photoName = photoName
        do{
            try context.save()
            print("已保存")
        }catch{
            print("保存context失败")
        }
        
    }

    
    
    //计算每单位时间内（可以是年月日）的花费,返回花费值，以及各个时间段的名称(注意此方法对于按月/天分尚未指定月份，为上级数组中的第0个元素)
    func calculateEachTimeSpend(style: String)->(spend:[Double],timeScale:[String]){
        var differentYear = [[EverydayDetails]]()
        var spend = [Double]()
        var timeScale = [String]()
        
        var tempEverydayDetails = [EverydayDetails]()
        
        let request: NSFetchRequest<EverydayDetails> = EverydayDetails.fetchRequest()
        do {
            //获取数据
             tempEverydayDetails = try context.fetch(request)
            if (tempEverydayDetails.count != 0){
            //按日期排序
            tempEverydayDetails = DetailsDao().sortByDate(tempEverydayDetails)
            }
        }catch{
            print("从context获取数据错误")
        }
        
        //如果有数据存在
        if (tempEverydayDetails.count != 0 ){
        
        differentYear = DetailsDao().groupDetailsBy(tempEverydayDetails, style: "byYear")
        
        //按年份从小到大排序
        for i in 0...(differentYear.count-1)/2{
            let temp = differentYear[i]
            differentYear[i] = differentYear[differentYear.count-1-i]
            differentYear[differentYear.count-1-i] = temp
        }
        
        
        
        if (style == "byMonth"){//如果按月分，再次分组
            
            var temp = [[EverydayDetails]]()
            //将每年按月份分
            for i in differentYear{
            temp +=  DetailsDao().groupDetailsBy(i, style: "byMonth")
            }
            
        }
         if (style == "byDay"){//如果按天分，先按月分（上面已经分了），再按天分
            var temp = [[EverydayDetails]]()
            //将每月按天分
            for i in differentYear{
                temp +=  DetailsDao().groupDetailsBy(i, style: "byDay")
            }
            differentYear = temp
        }
        
        for i in 0...differentYear.count-1{
            var singleSpend:Double = 0
            let presentYear = DetailsDao().getYMDOfDate(differentYear[i][0].date!).year
            var presentMonth : String = ""
            var presentDay :String = ""
            if (style == "byMonth"){//如果还要按月分
                presentMonth = DetailsDao().getYMDOfDate(differentYear[i][0].date!).month
            }else if(style == "byDay"){//如果还要按天分
                presentMonth = DetailsDao().getYMDOfDate(differentYear[i][0].date!).month
                presentDay = DetailsDao().getYMDOfDate(differentYear[i][0].date!).day
            }
            
            print("在\(presentYear)年,\(presentMonth)月，\(presentDay)天")
            for j in differentYear[i]{
                singleSpend += j.price
            }
            print("花费了\(singleSpend)")
            let singleTimeScale  = presentYear+presentMonth+presentDay
            timeScale.append(singleTimeScale)
            spend.append(singleSpend)
        }
        return (spend,timeScale)
        }
        return ([0.0],[])
    }
    
    //搜索两个时间段之间的数据
    func searchByDate( _ startDate: Date,_ endDate: Date)->[EverydayDetails]{
        let manyDetails  = EverydayDetailsViewController.everydayDetails
        var resDetails = [EverydayDetails]()
//        print("manyDetails is \(manyDetails)")
        for i in manyDetails{
//            print("now i is \(i)")
            if (((i.date!) >= startDate) && ((i.date!) <= endDate)){
//                print("i is \(i)")
                resDetails.append(i)
            }
        }
        return resDetails
    }
    
    //判断给定日期的年月日时分秒。用元组返回
    func getYMDOfDate(_ date:Date)->(year:String,month:String,day:String,hours:String,minute:String,second:String){
        //创建一个DateFormatter来作为转换的桥梁
        let dateFormatter = DateFormatter()
        //设置时间格式（这里的dateFormatter对象在上一段代码中创建）
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        //DateFormatter对象的string方法执行转换(参数now为之前代码中所创建)
        var convertedDate0 = dateFormatter.string(from: date)
        //调用string方法进行转换
        convertedDate0 = dateFormatter.string(from: date)
        //输出转换结果
        var convertArray = convertedDate0.split(separator: " ")
        var convertArray0 = convertArray[0].split(separator: "-")
        var convertArray1 = convertArray[1].split(separator: ":")
        //        print("现在是\(convertArray0[0])年...")
        return (String(convertArray0[0]),String(convertArray0[1]),String(convertArray0[2]),String(convertArray1[0]),String(convertArray1[1]),String(convertArray1[2]))
    }
    
    //判断给定日期是一年中的第几周
    func GetWeekByDate(_ date:Date) ->String{
        guard let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) else {
            return ""
        }
        let components = calendar.components([.weekOfYear,.weekOfMonth,.weekday,.weekdayOrdinal], from: date)
        //今年的第几周
        let weekOfYear = components.weekOfYear!
        
        //这个月第几周
        let weekOfMonth = components.weekOfMonth!
        //周几
        let weekday = components.weekday!
        //这个月第几周
        let weekdayOrdinal = components.weekdayOrdinal!
        print(weekOfYear)
        print(weekOfMonth)
        print(weekday)
        print(weekdayOrdinal)
        print("第\(components.weekOfYear!)周")
        return "\(components.weekOfYear!)";
        
    }
    
    //将数据按日期排序
    func sortByDate( _ details:[EverydayDetails])->[EverydayDetails]{
        var result = details
        for i in 0...result.indices.count-1{
            for j in 0...i{
                if (result[i].date! > result[j].date!){
                    let temp = result[i]
                    result[i] = result[j]
                    result[j] = temp
                }
            }
            
        }
//        print("result is \(result)")
       
        return result
    }
    
    //将数据按年或者月或者天划分，存入数组
    func groupDetailsBy(_ manyDetails:[EverydayDetails],style:String)->[[EverydayDetails]]{
        
        var pattern: String = ""
        
        if (style == "byYear" ){
            pattern = "yyyy"
        }else if (style == "byMonth"){
            pattern = "MM"
        }else if (style == "byDay"){
            pattern = "dd"
        }else{
            print("error paremeter!")
            exit(0)
        }
        let groups = DetailsDao().sortItemBySpecialDatePattern(manyDetails,datePattern: pattern)
        //        print("now group is \(groups)")
        var res = groupDetails(manyDetails, sortedGroups: groups)
        
        //按时间顺序排序
        for i in 0...res.count-1 {
            for j in 0...res[i].count-1{
                for k in 0...j{
                    if (res[i][k].date! > res[i][j].date!){
                        let temp = res[i][k]
                        res[i][k] = res[i][j]
                        res[i][j] = temp
                    }
                }
            }
        }
        return res
    }

    //将索引从sortedGroup中取出，然后根据索引将数据存入数组
    private func groupDetails(_ manyDetails:[EverydayDetails],sortedGroups:[[String]])->[[EverydayDetails]]{
        var res = [[EverydayDetails]]()
        for i in 0...sortedGroups.count-1{
            var singleYearArray = [EverydayDetails]()
            for j in 1...sortedGroups[i].count-1{
                singleYearArray.append(manyDetails[Int(sortedGroups[i][j])!])
            }
            res.append(singleYearArray)
        }
        return res
        
    }
    
    //将数据按照日期分组,返回记录年份和序号的数组
    func sortItemBySpecialDatePattern(_ allData: [EverydayDetails],datePattern:String)->[[String]]{
        var groups  = [[String]]()
        var existDate : [String] = []
        var count = 0
        for (index,eachData) in allData.enumerated(){
            let dateFormatter = DateFormatter()
            //设置时间格式（这里的dateFormatter对象在上一段代码中创建）
            dateFormatter.dateFormat = datePattern
            let convertedDate0 = dateFormatter.string(from: eachData.date!)
            
            //若已有日期不包含此项数据的日期,则将z此数据放入一个新的维当中
            let existIndex = isContain(array: existDate, element: convertedDate0)
            if ( existIndex == -1 ){
                groups += [[]]
                //存入新日期
                existDate.append(convertedDate0)
                //0存日期，1存索引(此数据在alldata中的序号)
                groups[count].insert(convertedDate0, at: 0)
                groups[count].insert(String(index), at: 1)
                count += 1
                //                print("groups are \(groups)")
            }else{
                
                var findPos: Int = -1
                for k in 0...groups.count-1{
                    if (groups[k][0] == convertedDate0){
                        findPos = k
                    }
                }
                //否则将此数据索引存入已有数据末尾
                groups[findPos].insert(String(index), at: groups[findPos].count)
            }
        }
        return groups
    }
    
    //判断String数组是否包含某个元素，包含则返回index，不包含返回-1
    func isContain(array: [String],element: String)->Int{
        for (index,i) in array.enumerated(){
            if (i == element){
                return index
            }
        }
        return -1
    }
    
    func query(){
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EverydayDetails")
        let str = "2019-03-11 00:00:00"
        
        DetailsDao().saveDao("test", 1, DateUtil().StringToDate(str), "others", "")
        
        let date = DateUtil().StringToDate(str)
        
        let interval = DateUtil().dateToInt(date)
        
        print("interval is \(interval)")
        
        let interval2  = DateUtil().nsDateToInt(str)
        print("interval2 is \(interval2)")
        
        fetchRequest.predicate = NSPredicate(format: "date >= %@", NSDate(timeIntervalSinceReferenceDate: TimeInterval(interval2)))
        
        
        
        
        let asyncFecthRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { (result: NSAsynchronousFetchResult!) in
            
            
            
            //对返回的数据做处理。
            
            let fetchObject  = result.finalResult! as! [EverydayDetails]
            
            print("查询结果是:\(String(describing: result.finalResult))")
        }
        // 执行异步请求调用execute
        do {
            try context.execute(asyncFecthRequest)
        } catch  {
            print("error")
        }
        
        
        
    }
    
    func deleteAll(){
         let request: NSFetchRequest<EverydayDetails> = EverydayDetails.fetchRequest()
        do {
            //获取数据
            let tempEverydayDetails = try context.fetch(request)
            for i  in tempEverydayDetails{
                context.delete(i)
            }
             try context.save()
            print("已全部删除")
        }catch{
            print("从context获取数据错误")
        }
        
        
    }

    
    
    
}
