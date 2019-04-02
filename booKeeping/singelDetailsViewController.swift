//
//  singelDetailsViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/4/1.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import  CoreData

class singelDetailsViewController: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    static var presentDetails:EverydayDetails? = nil
    
    
    
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var kindImg: UIImageView!
    
    @IBOutlet weak var moneyText: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesText: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let request: NSFetchRequest<EverydayDetails> = EverydayDetails.fetchRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        setViewStyle(totalView)
        totalView.backgroundColor =   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setViewStyle(topView)
        setBtnStyle()
        setInfo()
        self.showAnimate()
        // Do any additional setup after loading the view.
    }
    
    
    /// 设置各种信息
    func setInfo(){
        if (singelDetailsViewController.presentDetails != nil){
            let temp = singelDetailsViewController.presentDetails
            kindLabel.text = temp?.kind
            moneyText.text = String((temp?.price)!)
            timeLabel.text = String(DateUtil().DateToString((temp?.date)!))
            notesText.text = temp?.name
            kindImg.image = UIImage(named: String((temp?.kind)!+".png"))
        }
    }
    
    
    /// 显示动画
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    
    /// 点击“完成”按钮执行的操作。 保存修改内容（如果有）到context，同时刷新主界面的cell
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func done(_ sender: Any) {
        
        let price = moneyText.text
        let note = notesText.text
        
        if (price != nil){
            
            //计算cellID
            singelDetailsViewController.presentDetails?.price = Double(price!)!
            singelDetailsViewController.presentDetails?.name = note
            EverydayDetailsViewController.presentDetails = singelDetailsViewController.presentDetails
            let cellID = DateUtil().DateToStringYMD((singelDetailsViewController.presentDetails?.date)!)
            EverydayDetailsViewController.presentTableView!.register(EverydayDetailsTableViewCell.self, forCellReuseIdentifier: cellID)//此行代码保证程序不崩🌚
            let cell = EverydayDetailsViewController.presentTableView!.cellForRow(at: EverydayDetailsViewController.presentIndexPath!) as? EverydayDetailsTableViewCell
            
            let activityNameLabel = UILabel()
            activityNameLabel.frame = CGRect.init(x: 112, y: 10, width: 140, height: 20)
            
            let activityPrice = UILabel()
            activityPrice.frame = CGRect.init(x: 288, y: 10, width: 73, height: 20)
            
            let activityIcon = UIImageView()
            activityIcon.frame = CGRect.init(x: 20, y: 10, width: 25, height: 25)
            
            //填数据
            activityNameLabel.text = note
            activityPrice.text = Double(price!)!.cleanZero() //去除多余0
            activityIcon.image = UIImage(named: (singelDetailsViewController.presentDetails?.kind!)!+".png" )
            
            
            cell!.contentView.addSubview(activityNameLabel)
            cell!.contentView.addSubview(activityPrice)
            cell!.contentView.addSubview(activityIcon)
            do {
                try context.save() //保存到context
            }catch{
                
            }
        }
        self.removeAnimate()
    }
    
    @IBOutlet weak var totalView: UIView!
    
    
    @IBOutlet weak var doneBtn: UIButton!
    
    func setBtnStyle(){
        doneBtn.layer.cornerRadius = 10
        doneBtn.layer.borderColor =   #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        
    }
    
    func setViewStyle(_ view:UIView){
        //为轮廓添加阴影和圆角
        
        view.layer.shadowOffset = CGSize.init()//(0,0)时是四周都有阴影
        //        view.layer.shadowColor =   #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1);
        //        view.layer.shadowOpacity = 0.8;
        //        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = false
        view.layer.borderColor =   #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.layer.borderWidth = 0.05//设置边框线条粗细
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
