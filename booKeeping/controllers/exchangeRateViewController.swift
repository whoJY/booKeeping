//
//  exchangeRateViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/2.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import Charts

class exchangeRateViewController: UIViewController {
    
    @IBOutlet weak var countryAImg: UIImageView!
    @IBOutlet weak var countryBImg: UIImageView!
    @IBOutlet weak var countryAMoney: UITextField!
    @IBOutlet weak var countryBMoney: UITextField!
    @IBOutlet weak var transImg: UIImageView!
    
    
    func initUI(){
        countryAImg.image = UIImage(named: "zhongguoguoqi.png")
        countryBImg.image = UIImage(named: "meiguoguoqi.png")
        transImg.image = UIImage(named: "doubleArrow.png")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        addListener()
//        f()
        
        // Do any additional setup after loading the view.
    }
    
    //添加监听
    func addListener(){
        
        countryAMoney.addTarget(self, action: #selector(exchangeRateViewController.textFieldADidChange(_:)), for: .editingChanged)
        countryBMoney.addTarget(self, action: #selector(exchangeRateViewController.textFieldBDidChange(_:)), for: .editingChanged)
    }
    
    //此处转换
    func calculateA(_ input:Double,_ rate: Double)->Double{
        return rate*input
    }
    
    //...
    @objc func textFieldADidChange(_ textField: UITextField) {
        let moneyA = Double(textField.text ?? "0")
        
        countryBMoney.text = String (format: "%.2f", calculateA(moneyA ?? 0, 0.142))
        
    }
    
    @objc func textFieldBDidChange(_ textField: UITextField) {
        let moneyB = Double(textField.text ?? "0")
        print("输入是\(moneyB),结果是\(calculateA(moneyB ?? 0, 0.142))")
        countryAMoney.text = String (format: "%.2f", calculateA(moneyB ?? 0, 7))
        
    }
    
    //折线图
    var chartView: LineChartView!
    
    func f(){
        //创建折线图组件对象
        chartView = LineChartView()
        chartView.frame = CGRect(x: 20, y: 80, width: self.view.bounds.width - 40,
                                 height: 300)
        self.view.addSubview(chartView)
        
        //折线图背景色
        chartView.backgroundColor = UIColor.yellow
        
        //折线图无数据时显示的提示文字
        chartView.noDataText = "暂无数据"
        
        //折线图描述文字和样式
        chartView.chartDescription?.text = "考试成绩"
        chartView.chartDescription?.textColor = UIColor.red
        
        //设置交互样式
        chartView.scaleYEnabled = false //取消Y轴缩放
        chartView.doubleTapToZoomEnabled = true //双击缩放
        chartView.dragEnabled = true //启用拖动手势
        chartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView.dragDecelerationFrictionCoef = 0.9 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
        //生成8条随机数据
        var dataEntries = [ChartDataEntry]()
        for i in 0..<8 {
            let y = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        //这50条数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "李子明")
        //生成第二条折线数据
        var dataEntries2 = [ChartDataEntry]()
        for i in 0..<8 {
            let y = arc4random()%100
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries2.append(entry)
        }
        let chartDataSet2 = LineChartDataSet(entries: dataEntries2, label: "王大锤")
        
        //目前折线图包括2根折线
        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSet2])
        
        //设置折现图数据
        chartView.data = chartData
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
