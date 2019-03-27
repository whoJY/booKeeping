//
//  shareDataViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/9.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit


class shareDataViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var exportDate: UIButton!
    @IBOutlet weak var chooseTimeView: UIView!
    
    @IBOutlet weak var chooseTimeTableView: UITableView!
    @IBOutlet weak var dataPicker: UIDatePicker!
    @IBOutlet weak var ensureBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var exportBtn: UIButton!
    
    override func viewDidLoad() {
        chooseTimeTableView.delegate=self
        chooseTimeTableView.dataSource = self
        super.viewDidLoad()
        initUI()
        
        // Do any additional setup after loading the view.
    }
    
    func initUI(){
        //默认选择时间区域不可见
        hiddenGetTime(true)
        
        
    }
    
    
    
    var tips = ["开始时间","结束时间"]
    var times = ["点击设置","点击设置"]
    
    //加载table view数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        chooseTimeTableView.tableFooterView = UIView()
        let cellIdentifier = "shareDateCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! shareDateTableViewCell
        //设置cell
        cell.tips.text? = tips[indexPath.row]
        cell.time.text? = times[indexPath.row]
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //设置标签的tag
        btnTag = indexPath.row
        //显示选择时间区域
        hiddenGetTime(false)
        
    }
    
    var btnTag = -1
    
    //隐藏选择时间区域
    func hiddenGetTime(_ show:Bool){
        //隐藏导出数据按钮
        exportBtn.isHidden = !show
        //显示导出数据区域
        chooseTimeView.isHidden = show
    }
    
    //确认时间
    @IBAction func ensure(_ sender: UIButton) {
        let date = dataPicker.date
        times[btnTag] = DateUtil().DateToStringYMD(date)
        chooseTimeTableView.reloadData()
        hiddenGetTime(true)
        
    }
    
    @IBAction func cancel(_ sender:UIButton){
        //不显示选择时间区域
        hiddenGetTime(true)
        
    }
    
    
    
    
    //点击导出按钮
    @IBAction func export(_ sender: UIButton) {
        if (times[0] != "点击设置" && times[1] != "点击设置"){//确保用户选择后
            
            let startTime = DateUtil().StringToDate(times[0])//开始时间
            let endTime = DateUtil().StringToDate(times[1])//结束时间
            let exportData = DetailsDao().searchByDate(startTime, endTime)
            if (exportData.count == 0){
                //提示此时间段没有数据
                showMsgbox(_message: "这段时间没有数据~")
            }else{
                //创建文件
                createPDF(data: exportData)
                createCSV(data: exportData)
                shareSheet()  //出现分享sheet
            }
            
        }
    }
  
    
    //分享
    func  shareSheet(){
        
        let fileName = "booKeeping历史数据.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        let objectsToShare = [path]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        
        
        
    }
    
    var tasks=["1","2","3","4"]
    //生成csv文件
    func createCSV(data:[EverydayDetails]){
        let fileName = "booKeeping历史数据.csv"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "name\t kind\t price\t data\t\n"
        
        for i in data {
            
            let newLine = "\(String(describing: i.name!))\t \(String(describing: i.kind!))\t \(i.price)\t \(DateUtil().DateToString(i.date!))\t\n"
            
            csvText.append(newLine)
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf16)
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
        print("created CSV success")
    }
    //生成pdf
    func createPDF(data:[EverydayDetails]) {
        let html = "<b>Hello <i>World!</i></b> <p>Generate PDF file from HTML in Swift</p>"
        let fmt = UIMarkupTextPrintFormatter(markupText: html)
        
        // 2. Assign print formatter to UIPrintPageRenderer
        
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(fmt, startingAtPageAt: 0)
        
        // 3. Assign paperRect and printableRect
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8) // A4, 72 dpi
        let printable = page.insetBy(dx: 0, dy: 0)
        
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, .zero, nil)
        
        for i in 1...render.numberOfPages {
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        
        UIGraphicsEndPDFContext();
        
        // 5. Save PDF file
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        pdfData.write(toFile: "\(documentsPath)/file.pdf", atomically: true)
        print("created PDF success")
    }
    
    //显示提示信息
    func showMsgbox(_message: String, _title: String = "提示"){
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertController.Style.alert)
        let btnOK = UIAlertAction(title: "好的", style: .default, handler: nil)
        alert.addAction(btnOK)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
