//
//  pwdViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/17.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

class pwdViewController: UIViewController {

    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var ensurePwd: UITextField!
    @IBOutlet weak var ensureBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ensure(_ sender: UIButton) {
       
        
        let pwd1 = pwd.text
        let pwd2 = ensurePwd.text;
        if (pwd1 != nil && pwd2 != nil){
            if (pwd1 == pwd2){
                let response = HttpUtil().askWebService("setUserPwd", loginViewController.tel!,pwd1!)
                switch response{
                case "successSetPwd"://成功设置密码
                    //同步数据
                    
                    //跳转我的界面
                    backBtn.sendActions(for: .touchUpInside)
                    break
                case "error"://出现错误
                    showMsgbox(_message: "未知错误")
                    break;
                default :
                    showMsgbox(_message: "未知错误")
                    break;
                    //跳转我的界面，且提示
                    
                }
                
                
            }
        }
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
        
       
    }

    //显示提示信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
        
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
