//
//  validateTouchIDViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/21.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import CoreData

class validateTouchIDViewController: UIViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var userPortrait: UIImageView!
    var timer:Timer? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        print("进入验证")
        initUI()
        
        passed = !locked() //已上锁就未通过，需要验证
        print(passed)
 
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(validateTouchIDViewController.validateTouchID), userInfo: nil, repeats: false)
    }
    
    //验证用户是否设置锁
    func locked()->Bool{
        var  locked = false;
        do {
            let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
            locked = try self.context.fetch(request)[0].touchIDLocked
        }catch{
            print("无法获取是否上锁")
        }
        return locked
    }
    
    func initUI(){
        //获取用户图片
        do {
            let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
            let portrait = try self.context.fetch(request)[0].portraitPath ?? "unknown_user.png"
            userPortrait.image = ImgUtil().getSavedImage(named: portrait)
            
        }catch{
            
        }
        initPortrait()
        
    }
    
    
    var passed = false
    
    
    @IBAction func clickToValidate(_ sender: UIButton) {
        validateTouchID()
    }
    
    
    @objc func validateTouchID(){
        
        if (passed){//验证通过，进入主界面
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: rootViewController())))
                as! rootViewController
            if (vc.isKind(of: rootViewController.self)){
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        if (!passed){
            Finger().userFigerprintAuthenticationTipStr("请验证指纹")
            print("等待验证结果")
            while (true){//等待指纹验证结果
                print("")
                if (Finger.finished){
                    break
                }
            }
            print("验证已完成")
            passed = Finger.result//获取验证结果
            if (passed){//验证通过，进入主界面
                let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of: rootViewController())))
                    as! rootViewController
                if (vc.isKind(of: rootViewController.self)){
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
    //设置头像框为圆形
    func initPortrait(){
        userPortrait.layer.cornerRadius = userPortrait.frame.size.height/2
        userPortrait.layer.masksToBounds = true
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
