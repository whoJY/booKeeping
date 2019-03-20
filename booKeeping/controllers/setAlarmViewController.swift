//
//  setAlarmViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/19.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import  CoreData
import  UserNotifications

class setAlarmViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var alarmTableView: UITableView!
    static var alarms  = [String]()
    @IBOutlet weak var addAlarmBtn: UIButton!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var chooseTimeView: UIView!
    
    
    override func viewDidLoad() {
        
        alarmTableView.delegate = self
        alarmTableView.dataSource = self
        
        print("this is setAlarmVC")
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        super.viewDidLoad()
        initUI()
        loadSettingsData()
        
        //设置推送内容r
        let content = UNMutableNotificationContent()
        content.title = "hujinyu"
        content.body = "hello!"
        
        //设置通知触发器
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 15, repeats: false)
        
        //设置请求标识符
        let requestIdentifier = "hujinyu.booKeeping"
        
        //设置一个通知请求
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        //将通知请求添加到发送中心
        UNUserNotificationCenter.current().add(request) { error in
            if error == nil {
                print("Time Interval Notification scheduled: \(requestIdentifier)")
            }
        }
        
        
        
        
        
    }
    
    func initUI(){
        chooseTimeView.isHidden = true
        
    }
    
    
    static var settings :[UserSettings]?
    static var setting:UserSettings?
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    //载入数据
    func loadSettingsData(){
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        do {
            //获取数据
            setAlarmViewController.settings = try context.fetch(request)
            //获取闹钟时间数据
            if (setAlarmViewController.settings?.count != 0){
                setAlarmViewController.alarms = getAlarmNums(alarmStr: setAlarmViewController.settings![0].alarmTime
                    ?? "")
            }else{
                let temp = UserSettings(context: context)
                temp.alarmTime=""
                temp.touchIDLocked = false
            }
        }catch{
            print("从context获取数据错误")
        }
    }
    
    //
    func getAlarmNums(alarmStr:String)->[String]{
        let strs = alarmStr.components(separatedBy: "&")
        return strs
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //返回闹钟数
        setAlarmViewController.alarmCount = setAlarmViewController.alarms.count
        return setAlarmViewController.alarms.count
    }
    
    
    //加载table view数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "alarmTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! alarmTableViewCell
        
        cell.tips.text = "提醒时间"
        cell.alarmTime.text = "每天" + setAlarmViewController.alarms[indexPath.row]
        return cell
    }
    static var alarmCount = 0
    
    
    //确认添加
    @IBAction func ensureTime(_ sender: UIButton?) {
        let date = dataPicker.date
        
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        // 为日期格式器设置格式字符串
        dformatter.dateFormat = "HH:mm"
        // 使用日期格式器格式化日期、时间
        let datestr = dformatter.string(from: date)
        print("\(datestr)")
        //加入数组
        setAlarmViewController.alarms.insert(datestr, at:setAlarmViewController.alarmCount)
        
        //保存到数据库
        let alarmStr = mergeAlarmStr(alarms: setAlarmViewController.alarms)
        
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        do{
            //更新数据
            try context.fetch(request)[0].setValue(alarmStr, forKey: "alarmTime")
            try context.save()
            print("已保存")
        }catch{
            print("保存context失败")
        }
        
        
        loadSettingsData()
        alarmTableView.reloadData()
        
        chooseTimeView.isHidden = true
        addAlarmBtn.isHidden = false
        
    }
    
    func mergeAlarmStr(alarms:[String])->String{
        var res = ""
        for i in 0...alarms.count-1{
            
            res.append("&")
            
            res.append(alarms[i])
            
        }
        if res[res.startIndex] == "&"{
            res.remove(at: res.startIndex)
        }
        
        print("res is \(res)")
        //        res.remove(at: res.startIndex)
        return res
        
    }
    
    
    //取消添加
    @IBAction func cancelAdd(_ sender: UIButton) {
        chooseTimeView.isHidden = true
        addAlarmBtn.isHidden = false
    }
    
    //添加动作
    @IBAction func addAlarm(_ sender: UIButton?) {
        chooseTimeView.isHidden = false
        dataPicker.isHidden = false
        addAlarmBtn.isHidden = true
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

