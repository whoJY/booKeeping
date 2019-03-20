//
//  registerViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/17.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit


class loginViewController: UIViewController {

    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var styleView: UIView!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var validateCode: UITextField!
    @IBOutlet weak var getValidateCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    static var tel :String? = nil
    
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        HttpUtil().PostRequest(data: "", str1: "")
        
       
        
        
//        //首先创建一个模糊效果
//        let blurEffect = UIBlurEffect(style: .light)
//        //接着创建一个承载模糊效果的视图
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        //设置模糊视图的大小（全屏）
//        blurView.frame.size = CGSize(width: styleView.frame.width-15, height: styleView.frame.height-15)
//        //添加模糊视图到页面view上（模糊视图下方都会有模糊效果）
//        self.styleView.addSubview(blurView)
        
        initUI()
        // Do any additional setup after loading the view.
    }
    
    var timer:Timer? = nil
    
    
    //请求验证码
    @IBAction func askForValidate(sender:UIButton?){
        
        let phoneNumber = tel.text
        
        if (phoneNumber != nil  && isvalitemobile(phoneNumber!)){
            print("电话号码合法")
            let response = HttpUtil().askWebService("askValidate", phoneNumber!,"")
            print("response is \(response)")
            if ( response == "waitForSMS"){//如果请求成功，
                  timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(loginViewController.setValidateBtn), userInfo: nil, repeats: true)
                
            }else if (response == "phoneNumberUsed"){
                showMsgbox(_message: "此号码已经注册")
                //载入账号数据
            }else{
                showMsgbox(_message: "未知错误")
            }
            
        }else{
            //弹出电话号码非法提醒
            showMsgbox(_message: "请输入正确的电话号码!")
        }
        
    }
    
    
    //登录按钮
    @IBAction func login(_ sender: UIButton) {
        let phoneNumber = tel.text
        let code = validateCode.text
        if (phoneNumber != nil  && isvalitemobile(phoneNumber!)){
        print("电话号码合法")
            let response = HttpUtil().askWebService("validataCode", phoneNumber!,code!)
            
            switch response{
            case "passed"://跳转设置密码界面
                loginViewController.tel = phoneNumber
                let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: pwdViewController())))
                    as! pwdViewController
                if (vc.isKind(of: pwdViewController.self)){
                    self.present(vc, animated: true, completion: nil)
                }
                break
            case  "registered"://跳转我的界面，获取所有信息
                //获取数据
                
                backBtn.sendActions(for: .touchUpInside)
                break;
            case "failed"://验证失败，提示信息
                showMsgbox(_message: "验证失败")
                break
            case "notTheSame"://提示信息
                showMsgbox(_message: "请确保手机号一致")
                break
            default://提示信息
                showMsgbox(_message: "未知错误")
                break
            }
            
        }
        else{
            //弹出电话号码非法提醒
            showMsgbox(_message: "请输入正确的电话号码!")
        }
        
    }
    

    static  var second = 60
    //设置验证码倒计时
    @objc func setValidateBtn(){
        getValidateCodeBtn.setTitle("输入验证码("+String(loginViewController.second)+"s)", for: .normal)
        loginViewController.second -= 1
        getValidateCodeBtn.isUserInteractionEnabled = false
        if (loginViewController.second <= 0){
            getValidateCodeBtn.setTitle("获取验证码", for: .normal)
            getValidateCodeBtn.isUserInteractionEnabled = true
            stopTimer()
        }
    }
    
    
    // 停止计时
    func stopTimer() {
        if timer != nil {
            timer!.invalidate() //销毁timer
            timer = nil
        }
    }
    
    
    
    //验证号码是否合法
    func isvalitemobile(_ phoneNumber:String) -> Bool {
        let mobileRegex = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let mobileTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileRegex)
        return mobileTest.evaluate(with: phoneNumber)
    }
    
    
    //显示提示信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //初始化UI
    func initUI(){
        
        //定义渐变的颜色（从黄色渐变到橙色）
        let topColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let buttomColor = #colorLiteral(red: 0.9971700311, green: 0.7983285785, blue: 0.1761142612, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.view.frame
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        
        //设置viewe风格
        setViewRoundAndShadow(view: styleView)
    }

    
    @IBAction func back(segue: UIStoryboardSegue) {
        //再次返回
        backBtn.sendActions(for: .touchUpInside)
        
    }
    
    
    //设置view风格
    func setViewRoundAndShadow(view : UIView){
        //为轮廓添加阴影和圆角
//        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowOffset = CGSize.init()//(0,0)时是四周都有阴影
        view.layer.shadowColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1);
        view.layer.shadowOpacity = 0.2;
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = false
        view.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 0.05//设置边框线条粗细
        
    }
}
