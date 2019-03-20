//
//  toolsViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/1.
//  Copyright © 2019 hujinyu. All rights reserved.
//
import CoreData
import UIKit

class toolsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    @IBOutlet weak var menuTableView: UITableView!
 
    
  
    var menu =  [ ["汇率换算","预算设置"],["dollar.png","budget.png"] ]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu[0].count
    }
    
    //加载table view数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "toolMenuTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! toolMenuTableViewCell
        cell.menuName.text = menu[0][indexPath.row]
        cell.menuIcon.image = UIImage(named: menu[1][indexPath.row]) ?? nil
        //空行设置AccessoryType为None,禁止用户交互
        if (cell.menuIcon.image == nil){
            cell.accessoryType = UITableViewCell.AccessoryType(rawValue: 0)!
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    //点击菜单cell跳转指定页面
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  (indexPath.row == 0){
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: type(of:exchangeRateViewController())))
                as! exchangeRateViewController
            if (vc.isKind(of: exchangeRateViewController.self)){
                self.present(vc, animated: true, completion: nil)
                
            }
        }else if (indexPath.row == 1){
            //弹出输入框
            showInputDialog()
            
        }
        print("\(indexPath.row)")
    }
    
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    func showInputDialog(){
         let request: NSFetchRequest<UserSettings> = UserSettings.fetchRequest()
        
        
        //初始化UITextField
        var inputText:UITextField = UITextField();
        let msgAlertCtr = UIAlertController.init(title: "提示", message: "请输入预算", preferredStyle: .alert)
        let ok = UIAlertAction.init(title: "确定", style:.default) { (action:UIAlertAction) ->() in
            if((inputText.text) != ""){
                
                do{
                    //更新数据
                    try self.context.fetch(request)[0].setValue(Double((inputText.text)!), forKey: "budget")
                    try self.context.save()
                    print("已保存预算数据")
                    self.showMsgbox(_message: "已保存👀")
                }catch{
                    print("保存预算context失败")
                }
                
            }
        }
        
        let cancel = UIAlertAction.init(title: "取消", style:.cancel) { (action:UIAlertAction) -> ()in
            print("取消输入")
        }
        
        msgAlertCtr.addAction(ok)
        msgAlertCtr.addAction(cancel)
        //添加textField输入框
        msgAlertCtr.addTextField { (textField) in
            //设置传入的textField为初始化UITextField
            inputText = textField
            inputText.placeholder = "输入每月预算"
        }
        //设置到当前视图
        self.present(msgAlertCtr, animated: true, completion: nil)
    }
    
    
    //显示提示信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidLoad() {
        menuTableView.delegate = self
        menuTableView.dataSource = self
        super.viewDidLoad()
        menuTableView.tableFooterView = UIView()

     
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(segue: UIStoryboardSegue) {
        
        
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
