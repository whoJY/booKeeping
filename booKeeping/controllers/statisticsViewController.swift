//
//  statisticsViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/28.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import Charts
class statisticsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var showChartArea: UIView!
    @IBOutlet weak var payOUT: UIButton!
    @IBOutlet weak var payIN: UIButton!
    @IBOutlet weak var week: UIButton!
    @IBOutlet weak var month: UIButton!
    @IBOutlet weak var year: UIButton!
    @IBOutlet weak var totalCost: UILabel!
    @IBOutlet weak var averCost: UILabel!
    @IBOutlet weak var rankingTableView: UITableView!
    
    
    //所有点的颜色
    var circleColors: [UIColor] = []
    //折线图
    var chartView: LineChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始化ui
        initBtn()
        //载入数据
        loadData()
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        
        //        calculateEachYearSpend()
    }
    
    func initBtn(){
        payOUT.isSelected = true
        week.isSelected = true
        
        week.setBtnStyle()
        month.setBtnStyle()
        year.setBtnStyle()
        payIN.setBtnStyle()
        payOUT.setBtnStyle()
        
        payIN.tag = 0
        payOUT.tag = 1
        week.tag = 2
        month.tag = 3
        year.tag = 4
    }
    

    
    //默认查询每天的数据
    func loadData(){
        //查询每天的数据
        showMsg("byDay")
    }
    
    var showPayOut = false
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        ranking = calRankingListDate(EverydayDetailsViewController.everydayDetails)
        return ranking?.count ?? 0
    }
    
    //加载table view数据
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "statisticsTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! statisticsTableViewCell

        
        cell.name.text = ranking?[indexPath.row][0]//取出种类名称
        cell.money.text = ranking?[indexPath.row][1] //取出种类花费
        var percent:Double = Double(ranking![indexPath.row][2])! //百分比（小数形式）
        percent = percent < 0.001 ? 0.001:percent //当percent低于0.001，设置为0.001
        let percentStr = String(format: "%.2f", percent)
//        print("percentStr is \(percentStr)")
        cell.percent.text = String(Double(percentStr)!*100)+"%" //设置种类比例数值
        cell.sliderPercent.setProgress(Float(percent), animated: true)//设置百分比进度条
        cell.icon.image = UIImage(named: (ranking?[indexPath.row][0])!+".png")//设置种类Icon
//        cell.sliderPercent.va
        return cell
       


    }
    
    //点击任一button刷新视图
    @IBAction  func refresh(sender:UIButton?){
        
        let tag = sender?.tag
        switch(tag!)
        {
            
        case 0://点击 收入 按钮
            payOUT.isSelected = false
            payIN.isSelected = true
            break;
        case 1://点击 支出 按钮
            payOUT.isSelected = true
            payIN.isSelected = false
            break;
        case 2://点击 周 按钮
            week.isSelected = true
            month.isSelected = false
            year.isSelected = false
            break;
        case 3://点击 月 按钮
            week.isSelected = false
            month.isSelected = true
            year.isSelected = false
            break;
        case 4://点击 年 按钮
            week.isSelected = false
            month.isSelected = false
            year.isSelected = true
            break;
        default:
            break;
        }
        week.setBtnStyle()
        month.setBtnStyle()
        year.setBtnStyle()
        payIN.setBtnStyle()
        payOUT.setBtnStyle()
//       print("已经更改")
        //查询方式
        var queryStyle = ""
        if (payOUT.isSelected){
            showPayOut = true
        }
        if (week.isSelected){
            queryStyle = "byDay"
        }else if (month.isSelected){
            queryStyle = "byMonth"
        }else{
            queryStyle = "byYear"
        }
        showMsg(queryStyle)
    }
    
    //所有种类的名字
    var kind=["eat","health","learn","traffic","clothes","communication","pets","others"]
    
    var ranking : [[String]]? = nil
    
    //计算排行榜（种类，比例，花费）
    func calRankingListDate(_ details:[EverydayDetails])->[[String]]{
        var spendsOfDifferentKinds=[[Double]]()
        var result=[[String]]()
        
        //初始化为0
        for i in 0...kind.count{
            spendsOfDifferentKinds += [[0.0,Double(i)]] //0寸数据，1存种类名称索引
        }
        //统计数据
        for i in 0...kind.count-1{
            for j in details{
                if (j.kind == kind[i]){//如果找到种类
                    spendsOfDifferentKinds[i][0]+=j.price
        
                }
            }
        }

        //先排序(从大到小)
        for i in 0...spendsOfDifferentKinds.count-1{
            for j in 0...spendsOfDifferentKinds.count-1{
                if (spendsOfDifferentKinds[i][0]>spendsOfDifferentKinds[j][0]){
                    let temp = spendsOfDifferentKinds[i]
                    spendsOfDifferentKinds[i] = spendsOfDifferentKinds[j]
                    spendsOfDifferentKinds[j] = temp
                }
            }
        }
        
        var totalCount = 0.0
        //算消费总额
        for i in 0...spendsOfDifferentKinds.count-1{
            totalCount += spendsOfDifferentKinds[i][0]
        }
        
        //算各个种类花费总和以及占比
        var count=0
        var others = 0.0
        for i in 0...spendsOfDifferentKinds.count-1{
            if (spendsOfDifferentKinds[i][0] != 0.0 && count <= 4){//取最多前四个种类（最大的四个）
                result += [["","",""]]
                result[i][0] = kind[Int(spendsOfDifferentKinds[i][1])]//0存种类名称
                result[i][1] = String(spendsOfDifferentKinds[i][0]) //1存价格
                result[i][2] = String(Double(result[i][1])!/totalCount)//2存百分比
                count += 1
            }else{//计算others消费数据
                for j in count...spendsOfDifferentKinds.count-1{
                    others += spendsOfDifferentKinds[j][0]
                }
                break
            }
        }
        
        
        //存入others数据
        result += [["","",""]]//数组增加一位
        result[count][0] = "others"//0存种类名称(others)
        result[count][1] = String(others)//1存价格
        result[count][2] = String(Double(result[count][1])!/totalCount)//2存百分比
        
//        print("result is \(result)")
        return result
        
    }
    
    
    //设置各种信息
    func showMsg(_ queryStyle: String){
        var spendAndYear = DetailsDao().calculateEachTimeSpend(style: queryStyle)
        var total = 0.0
        for i in 0...spendAndYear.timeScale.count-1 {
            total += spendAndYear.spend[i]
        }
        let averageCost = total/Double(spendAndYear.timeScale.count)
        totalCost.text = String(format: "%.2f",  total)//保留两位小数
        averCost.text = String(format: "%.2f", averageCost)//保留两位小数
        createChart(queryStyle: queryStyle)
        
    }
    
    //创建折线图
    func createChart(queryStyle:String){
        
        //创建折线图组件对象
        chartView = LineChartView()
        chartView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width-10,
                                 height: 280)
        showChartArea.addSubview(chartView)
        
        //折线图无数据时显示的提示文字
        chartView.noDataText = "暂无数据"
        //折线图背景色
        chartView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //设置交互样式
        chartView.scaleYEnabled = false //取消Y轴缩放
        chartView.doubleTapToZoomEnabled = true //双击缩放
        chartView.dragEnabled = true //启用拖动手势
        chartView.dragDecelerationEnabled = true //拖拽后是否有惯性效果
        chartView.dragDecelerationFrictionCoef = 0.8 //拖拽后惯性效果摩擦系数(0~1)越小惯性越不明显
        
        
        //插入数据
        var dataEntries = [ChartDataEntry]()
        var spendAndYear = DetailsDao().calculateEachTimeSpend(style: queryStyle)
        
        for i in 0...spendAndYear.timeScale.count-1 {
            let y = spendAndYear.spend[i]
            let entry = ChartDataEntry.init(x: Double(i), y: Double(y))
            dataEntries.append(entry)
        }
        
        let xValues = spendAndYear.timeScale
//        xValues = ["一月","二月","三月","四月","五月"]
        print("xvalue is \(xValues)")
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xValues)
        
        chartView.xAxis.labelCount = xValues.count
        //这50条数据作为1根折线里的所有数据
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        chartView.legend.formSize = 0
        
        //设置线条颜色
        chartDataSet.colors = [#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)]
        //设置线条粗细
        chartDataSet.lineWidth = 0.8
        
        chartView.xAxis.drawGridLinesEnabled = false//不绘制网格线(竖线)
        chartView.leftAxis.drawGridLinesEnabled = false //不绘制网格线（横线）
        
        //播放x轴方向动画，持续时间2秒.先快后慢
        chartView.animate(xAxisDuration: 1.5)
        
        //开启填充色绘制
        chartDataSet.drawFilledEnabled = true
        //渐变颜色数组
        let gradientColors = [UIColor.orange.cgColor, UIColor.white.cgColor] as CFArray
        //每组颜色所在位置（范围0~1)
        let colorLocations:[CGFloat] = [1.0, 0.0]
        //生成渐变色
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                       colors: gradientColors, locations: colorLocations)
        //将渐变色作为填充对象
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        
        
        //目前折线图只包括1根折线
        let chartData = LineChartData(dataSets: [chartDataSet])
        
        //指定最小、最大刻度值
        chartView.xAxis.axisMinimum = 0 //最小刻度值
        chartView.xAxis.axisMaximum = Double(xValues.count)//最大刻度值
        chartView.xAxis.granularity = 1//间隔
        chartView.xAxis.granularityEnabled = true//勿删
        
        //修改折点样式
        chartDataSet.circleColors = [UIColor.init(cgColor: #colorLiteral(red: 0.9928546548, green: 0.8518775105, blue: 0.265756309, alpha: 1))]//外圆颜色
        chartDataSet.circleHoleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)  //内圆颜色
        chartDataSet.circleRadius = 2 //外圆半径
        chartDataSet.circleHoleRadius = 1 //内圆半径
        chartDataSet.highlightColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) //十字线颜色
        
        //修改x轴样式
        chartView.xAxis.labelPosition = .bottom //x轴显示在下方
        
        //图表最多显示10个点
        chartView.setVisibleXRangeMaximum(6)
        //设置默认显示的数据
        chartView.moveViewToX(Double(6-xValues.count))
        
        //下面不显示右侧 Y 轴的刻度文字。
        chartView.rightAxis.drawLabelsEnabled = false//不绘制右侧Y轴文字
        
        //指定最小、最大刻度值
        chartView.leftAxis.axisMinimum = 0 //最小刻度值
        
        //设置折现图数据
        chartView.data = chartData
        
    }

    //折线上的点选中回调
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry,
                            highlight: Highlight) {
        print("选中了一个数据")
        
        //将选中的数据点的颜色改成黄色
        var chartDataSet = LineChartDataSet()
        chartDataSet = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        let values = chartDataSet.entries
        let index = values.index(where: {$0.x == highlight.x})  //获取索引
        chartDataSet.circleColors = circleColors //还原
        chartDataSet.circleColors[index!] = .orange
        
        //重新渲染表格
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    //折线上的点取消选中回调
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        print("取消选中的数据")
        
        //还原所有点的颜色
        var chartDataSet = LineChartDataSet()
        chartDataSet = (chartView.data?.dataSets[0] as? LineChartDataSet)!
        chartDataSet.circleColors = circleColors
        
        //重新渲染表格
        chartView.data?.notifyDataChanged()
        chartView.notifyDataSetChanged()
    }
    
    
}
extension UIButton{
    
    func setBtnStyle(){
        if (self.isSelected){
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .selected)
            self.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }else{
            self.backgroundColor = #colorLiteral(red: 0.9928546548, green: 0.8518775105, blue: 0.265756309, alpha: 1)
            self.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.tintColor  = #colorLiteral(red: 0.9928546548, green: 0.8518775105, blue: 0.265756309, alpha: 1)
            
    
        }
      
    }
   
}
