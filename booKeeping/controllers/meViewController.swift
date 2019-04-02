//
//  meViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/17.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import LocalAuthentication
import CoreData
import SwiftyJSON

class meViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    
    @IBOutlet weak var portrait: UIImageView!
    @IBOutlet weak var meMenuTableView: UITableView!
    @IBOutlet weak var headBtn: UIButton!
    
    @IBOutlet weak var testBtn1: UIButton!
    @IBOutlet weak var testBtn2: UIButton!
    
    @IBOutlet weak var testBtn3: UIButton!
    @IBOutlet weak var testBtn4: UIButton!
    
    @IBOutlet weak var testImg: UIImageView!
    
    @IBOutlet weak var allDays: UILabel! //记账总天数
    @IBOutlet weak var allCounts: UILabel! //记账总笔数
    
    
    
    var menu =  [ ["定时提醒","导出数据","解锁密码","","帮助","关于"],["alarm.png","share.png","touchID.png","","help.png","about.png"] ]
    
    //设置头像框为圆形
    func initPortrait(){
        portrait.layer.cornerRadius = portrait.frame.size.height/2
        portrait.layer.masksToBounds = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu[0].count
    }
    
    //加载table view数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "meMenuTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! menuTableViewCell
        
        cell.menuName.text = menu[0][indexPath.row]
        cell.menuIcon.image = UIImage(named: menu[1][indexPath.row]) ?? nil
        //空行设置AccessoryType为None,禁止用户交互
        if (cell.menuIcon.image == nil){
            cell.accessoryType = UITableViewCell.AccessoryType(rawValue: 0)!
            cell.isUserInteractionEnabled = false
        }
        
        if (indexPath.row == 2){
            cell.accessoryType = .none
            let lockSwitch = UISwitch()
            lockSwitch.frame =  CGRect.init(x: 350, y: 5, width: 20, height: 15)
            lockSwitch.addTarget(self, action: #selector(switchDidChange(_:)), for: .valueChanged)
            cell.addSubview(lockSwitch)
            //如果用户已经设置上锁，设置开关打开，否则关闭
            lockSwitch.isOn = locked()
        }
        return cell
    }
    
    @objc func switchDidChange(_ sender: UISwitch){
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        if (!sender.isOn){//若开关打开，要关闭开关，则需验证
            // 验证指纹，保存到设置
            var res: Bool = false
            Finger().userFigerprintAuthenticationTipStr("请验证指纹")
            while (true){//等待指纹验证结果
                print("")
                if (Finger.finished){
                    break
                }
            }
            res = Finger.result//获取验证结果
            print("验证结果\(res)")
            if (res == true){//验证通过，关闭按钮
                //保存设置
                sender.isOn = false
                do {
                    try self.context.fetch(request)[0].touchIDLocked = false
                    try  context.save()
                }catch{
                    print("保存设置出错")
                }
            }else{//验证未通过，按钮仍然打开
                sender.isOn = true
            }
            
        }else{
            
            //保存设置
            do {
              try self.context.fetch(request)[0].touchIDLocked = true
                try  context.save()
            }catch{
              print("保存设置出错")
            }
            
        }
        //重置验证结果标志位
        Finger.result = false
        Finger.finished = false
    }
    
    //NSCode方法传递数据
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "touchIDLockSegue"){
            
            
            //            print("input Text is \(inputNameTextFd.text!)")
            
        }
    }
    
    //点击菜单cell跳转指定页面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  (indexPath.row == 0){//跳转到定时提醒
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: setAlarmViewController())))
                as! setAlarmViewController
            if (vc.isKind(of: setAlarmViewController.self)){
                self.present(vc, animated: true, completion: nil)
                
            }
        }else if (indexPath.row == 1){//跳转到分享数据
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: shareDataViewController())))
                as! shareDataViewController
            if (vc.isKind(of: shareDataViewController.self)){
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        print("\(indexPath.row)")
    }
    
    func jumpToPage(_ pageIndex: Int){
        
        self.tabBarController?.selectedIndex = pageIndex
    }
    
    override func viewDidLoad() {
        print("this is mevc")
        meMenuTableView.delegate = self
        meMenuTableView.dataSource = self
        super.viewDidLoad()
        //去除table view多余行数
        self.meMenuTableView.tableFooterView = UIView()
        initPortrait()
        initUI()
       
        
    }
    
    
    //初始化ui
    public func initUI(){
       
        allDays.text = String(EverydayDetailsViewController.groupsCount)
        allCounts.text = String(EverydayDetailsViewController.everydayDetails.count)
        
        let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        do {
            let userSetting = try self.context.fetch(request)
            if (userSetting.count == 0){
                print("portrait")
                portrait.image = UIImage(named: "head portrait.jpg")
            }else{
                let portraitPath = userSetting[0].portraitPath
                print("取出头像")
                if (portraitPath == ""){
                    print(1)
                    portrait.image = UIImage(named: "uu.png")
                }else{
                    print(2)
                     portrait.image = getSavedImage(named: portraitPath ?? "portrait.jpg")
                }
                
               
            }
        }catch{
            
        }
    }
    
    
    @IBAction func back(segue: UIStoryboardSegue) {
        
        //刷新ui
        initUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //刷新记账天数和记账笔数
        allDays.text = String(EverydayDetailsViewController.groupsCount)
        allCounts.text = String(EverydayDetailsViewController.everydayDetails.count)
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    @IBAction func gotoLogin(_ sender: UIButton) {
        var logged : Bool = false
            logged = getUsersettings().isLogined
            if (logged){//如果已经登录
                
                let alertC = UIAlertController(title: "选择操作", message: nil, preferredStyle: .actionSheet)
                //相册
                let action1 = UIAlertAction(title: "相册", style: .default) { (_) in
                    //打开相册
                    self.pickImage()
                    
                }
                //相机
                let action2 = UIAlertAction(title: "相机", style: .default) { (_) in
                    //打开相机
                    self.openCamera()
                    
                }
                
                //相机
                let action3 = UIAlertAction(title: "修改密码", style: .default) { (_) in
                    //跳转设置密码界面
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: pwdViewController())))
                        as! pwdViewController
                    if (vc.isKind(of: pwdViewController.self)){
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                }
                let action4 = UIAlertAction(title: "退出登录", style: .default) { (_) in
                    //退出登录，清除数据
                    self.logOut()
                }
                
                let action5 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alertC.addAction(action1)
                alertC.addAction(action2)
                alertC.addAction(action3)
                alertC.addAction(action4)
                alertC.addAction(action5)
                self.present(alertC, animated: true, completion: nil)
                
            }else{//如果没有登录,跳转登录界面
                let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: loginViewController())))
                    as! loginViewController
                if (vc.isKind(of: loginViewController.self)){
                    self.present(vc, animated: true, completion: nil)
                }
            }
   
        
       
        
    }
    
    
    //退出登录
    func logOut(){
        //清除所有数据
        let alarmTime = ""
        let budget = 0.0
        let isLogined = false
        let portraitPath = ""
        let touchIDLocked = false
        let userID = ""
        setUserSetting(isLogined: isLogined, touchIDLocked: touchIDLocked, budget: budget, portraitPath: portraitPath, userID: userID, alarmTime: alarmTime)
        print("已删除全部设置")

        DetailsDao().deleteAll()
        reloadDataOfEVC()
        //刷新界面
        meMenuTableView.reloadData()
        initUI()
        allCounts.text = "0"
        allDays.text = "0"
        portrait.image = UIImage(named:"uu.png")
    }
    
    
    /// 图片选择完成
    ///
    /// - Parameters:
    ///   - picker: 图片选择控制器
    ///   - info: 图片信息
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        print("选择图片")
        //获取选择的原图
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        portrait.image = pickedImage
        
        //将选择的图片保存到Document目录下
        if (ImgUtil().saveImage(image: pickedImage, name: "portrait.jpg") ){
            do {
                let oldSettings = getUsersettings()
                oldSettings.portraitPath = "portrait.jpg"
                setUserSetting(isLogined: oldSettings.isLogined, touchIDLocked: oldSettings.touchIDLocked, budget: oldSettings.budget, portraitPath: oldSettings.portraitPath!, userID: oldSettings.userID!, alarmTime: oldSettings.alarmTime!)
                //将图片上传到服务器(取出个人id即电话号码)
                let id = try self.context.fetch(request)[0].userID ?? "unknown id"
                let imgBase64 = ImgUtil().convertImageToBase64(image: pickedImage)
                DispatchQueue.global().async {//多线程上传图片
                    HttpUtil().askWebService("uploadImg", id, imgBase64)
                }  
            }catch{
                print("图片路径存储失败")
            }
            
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
 
    /// 取消选择图片
    ///
    /// - Parameter picker: 图片选择控制器
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("取消选择")
        self.dismiss(animated: true, completion: nil)
    }

    
    var imagePickerController:UIImagePickerController? = nil
    
    //选择图片
     func pickImage() {
        self.imagePickerController = UIImagePickerController()
        //设置代理
        self.imagePickerController!.delegate = self
        //允许用户对选择的图片或影片进行编辑
        self.imagePickerController!.allowsEditing = true
        //设置image picker的用户界面
        self.imagePickerController!.sourceType = .photoLibrary
        //设置图片选择控制器导航栏的背景颜色
        self.imagePickerController!.navigationBar.barTintColor = UIColor.orange
        //设置图片选择控制器导航栏的标题颜色
        self.imagePickerController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        //设置图片选择控制器导航栏中按钮的文字颜色
        self.imagePickerController!.navigationBar.tintColor = UIColor.white
        //显示图片选择控制器
        self.present(self.imagePickerController!, animated: true, completion: nil)
    }
 
    var testImage:UIImage? = nil
    var temp : String? = nil
    
   
    @IBOutlet weak var image2: UIImageView!
    
    @IBAction func test2(_ sender: UIButton) {
        var jsonStr = HttpUtil().askWebService("downloadDetails", "", "")
//         let jsonData = JSON.init(jsonStr as Any)
         jsonStr = jsonStr.replacingOccurrences(of: "&quot;", with: "\"")
      
        print("jsonstr is \(jsonStr)")
         var cons = [Consumption]()
        cons = JsonUtil().parseDetailsJsonByhand(jsonStr)
        //删除所有旧数据
        DetailsDao().deleteAll()
        //插入新数据
        for i in cons{
            DetailsDao().saveDao(i.name, i.price, DateUtil().StringToDateYMDHMS(i.date), i.kind, "clothes.png")
        }
        //重载数据
        reloadDataOfEVC()
    }
    
    
    func reloadDataOfEVC(){
        EverydayDetailsViewController.everydayDetails = []
        EverydayDetailsViewController.everydayTotalArr = [UIView]()
        EverydayDetailsViewController.eachdayBaseViewArr = [UIView]()
        EverydayDetailsViewController.tableViewArr = [UITableView]()
        EverydayDetailsViewController.lastTableView = UITableView()
        EverydayDetailsViewController.lastViewHeight = 0
        EverydayDetailsViewController.totalHeight = 0
        EverydayDetailsViewController.staticCellID = [String]()
        EverydayDetailsViewController.loadPos = 0
        EverydayDetailsViewController.groupsCount = 0
        //设置标志位，代表重载
        meViewController.loadFlag = 1
    }
    
    
    
    static var loadFlag = -1
    //变成汇率换算了
    @IBAction func uploadImg(_ sender: UIButton) {

        //下载图片
//     let base64Str = HttpUtil().askWebService("downloadImg","unknown id","")
//
//        if(base64Str.contains("ERROR")){//如果网络请求失败
//            showMsgbox(_message: base64Str) //提示错误信息
//        }else{
//     image2.image =  ImgUtil.convertBase64ToImage(imageString: base64Str)
//        }

        var jsonStr = HttpUtil().askWebService("exchangeRate", "USD", "EUR")
        jsonStr = jsonStr.replacingOccurrences(of: "&quot;", with: "\"")
        
       let res = JsonUtil().parseCurrencyResJsonByhand(jsonStr)
       print(res)
        
    }
    
    @IBAction func test(_ sender: UIButton) {
                       chooseKindandInputViewController().createRealDate()
   reloadDataOfEVC()

    }
    
    @IBAction func uploadDate(_ sender: UIButton) {
    
    let consArr = transUtil(EverydayDetailsViewController.everydayDetails)
    let jsonStr = JsonUtil().convertArrToJsonStr(consArr)
    let res = HttpUtil().askWebService("uploadConsumption", jsonStr, "")
    print(res)
    }
    
    
    //将coredata数据数组转为consumption(codable)数组
    func transUtil(_ details:[EverydayDetails])->[Consumption]{
        var res:[Consumption] = []
        for i in details {
                let temp : Consumption = Consumption(id: i.id ?? "unknown id", user_id: i.user_id ?? "unknown userID", name: i.name ?? "unknow name", kind: i.kind ?? "unknown kind", price: i.price, date: DateUtil().DateToString(i.date!))
            res.append(temp)
            }
        return res
    }

    //获取存储的照片
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    
    func openCamera(){
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //创建图片控制器
            
            let picker = UIImagePickerController()
            
            //设置代理
            
            picker.delegate = self
            
            //设置来源
            
            picker.sourceType = UIImagePickerController.SourceType.camera
            
            //允许编辑
            
            picker.allowsEditing = true
            
            //打开相机
            
            self.present(picker, animated:true, completion: { () -> Void in
            })
            
        }else{
            
            debugPrint("找不到相机")
            
        }
        
    }
   
    
    let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
    
    //验证用户是否设置锁
    func locked()->Bool{
        return getUsersettings().touchIDLocked
    }
    
    //获取设置信息
    func getUsersettings()->UserSettings{
        var res: UserSettings = UserSettings()
        do{
            let  userSetting = try context.fetch(request)
            if (userSetting.count != 0 ){
                res = userSetting[0]
            }else{
                let newSetting = UserSettings(context: context)
                newSetting.alarmTime = ""
                newSetting.budget = 0.0
                newSetting.isLogined = false
                newSetting.portraitPath = ""
                newSetting.touchIDLocked = false
                newSetting.userID = "unknown id"
                try context.save()
                res = newSetting
            }
        }catch{
            print("无法获取设置信息")
        }
        return res
    }
    
    //保存新的设置
    func setUserSetting(isLogined:Bool,touchIDLocked:Bool,budget:Double,portraitPath:String,userID:String,alarmTime:String){
        do {
            var  userSetting = try context.fetch(request)
            if (userSetting.count != 0){
                userSetting[0].isLogined = isLogined
                userSetting[0].touchIDLocked = touchIDLocked
                userSetting[0].budget = budget
                userSetting[0].portraitPath = portraitPath
                userSetting[0].userID = userID
                userSetting[0].alarmTime = alarmTime
                try context.save()
            }else{
                let createSettings = UserSettings(context: context)
                createSettings.isLogined = isLogined
                createSettings.touchIDLocked = touchIDLocked
                createSettings.budget = budget
                createSettings.portraitPath = portraitPath
                createSettings.userID = userID
                createSettings.alarmTime = alarmTime
                try context.save()
            }
        }catch{
            print("保存新的设置信息出错")
        }
    }
    
    
    //显示提示信息
    func showMsgbox(_message: String, _title: String = "提示"){
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

