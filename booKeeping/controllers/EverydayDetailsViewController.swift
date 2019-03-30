//
//  ViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/1/17.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import CoreData

class EverydayDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var  tempDetailsData = EverydayDetails()
    public static var everydayDetails = [EverydayDetails]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("details.plist")
    
    static  var totalHeight: Double = 0
    
    
    @IBOutlet weak var dayOfData:UILabel!
    @IBOutlet weak var monthOfData:UILabel!
    @IBOutlet weak var yearOfData:UILabel!
    @IBOutlet weak var hours:UILabel!
    @IBOutlet weak var mornigOrAfternoonLabel:UILabel!
    @IBOutlet weak var whichDayLabel: UILabel!
    //每天的视图
    @IBOutlet weak var everydayTotal: UIView!
    //每天视图子视图
    @IBOutlet weak var eachView: UIView!
    @IBOutlet weak var eachDayTableView: UITableView!
    @IBOutlet weak var addThingsBtn: UIButton!
    @IBOutlet weak var addThingsView: UIView!
    
    //总的滚动视图
    @IBOutlet weak var scroll: UIScrollView!
    //约束的高度
    @IBOutlet weak var scrollHeightRS: NSLayoutConstraint!
    @IBOutlet weak var ScrollViewBottomValue: NSLayoutConstraint!
    @IBOutlet weak var EverydayTotalHeight:NSLayoutConstraint!
    
    //loading图标
    var activityIndicator:UIActivityIndicatorView? = nil
    
    @IBAction func jump(_ addThingsBtn: UIButton){
        //NSCoder方法
        //  performSegue(withIdentifier: "sendDataSegue", sender: nil)
        
        
    }
    
    var monthInChinese = [["01","02","03","04","05","06","07","08","09","10","11","12"],["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"]]
    
    //设置scroll高度
    func setRSHeight(){
        ScrollViewBottomValue.constant = CGFloat(EverydayDetailsViewController.totalHeight+10)
    }
    
    //存入每天的table view  cell id
    static var staticCellID = [String]()
    //上一天视图的高度
    static var lastViewHeight = 300
    //数据分组
    var groups  = [[String]]()
    //用来记录加载到哪一位了
    static var loadPos = 0
    
    static var lastEverydayTotal:UIView? = nil//最后一天的view
    static var lastEachBaseView:UIView? = nil
    static var lastTableView :UITableView? = nil
    static var lastEverydayTotalHeight:Int? = nil //高度
    static var lastEachBaseViewHeight:Int? = nil //高度
    static var lastTableViewHeight:Int? = nil //高度
    
    
    static var everydayTotalArr = [UIView]()
    static var everydayTotalArrCopy = [UIView]()
    static var eachdayBaseViewArr = [UIView]()
    static var tableViewArr = [UITableView]()
    static var getMoneyArr=[UILabel]()//存每天收入
    static var putMoneyArr=[UILabel]()//存每天支出
    static var allDeleted = false  //记录一张表是否删完了
    public static var timer : Timer?//计时器
    
    static var added = false;//记录是否添加了新的一天的数据
    static var finished3Count = 0
    static var hasUpdatedGetAndPutLabel = false
    static var lastIndexpath :IndexPath? = nil
    
    
    static var deletedViewsTag : [Int] = []
    static var operateDelete = false
    static var hasDeletedOneTable = false //如果删除了一天，借此判断是删除了一条数据还是一天的table
    
    
    //添加一天的视图,若按顺序生成，则按顺序排，否则拍第一个
    func addOneDay(_ singleGroup: [String],_ tag :Int,_ isCreatedByOrder:Bool)->UIView{
        
        let itemsNumber = singleGroup.count-1   //要展示的数据数量
        let tableHeight = itemsNumber*40+44 //计算tableview  高度
        let eachViewHeight = tableHeight + 45  //计算包含table view 的view的高度
        let everyTotalHeight = eachViewHeight + 60 //计算每张卡片总高度
        var beginY = 0
        
        if (isCreatedByOrder){//如果是按照顺序生成，则要根据以前的卡片高度确定位置，否则从0开始
            EverydayDetailsViewController.totalHeight += Double(EverydayDetailsViewController.lastViewHeight)  //计算卡片的起始位置
            EverydayDetailsViewController.lastViewHeight = (everyTotalHeight) //记录上一张卡片高度
            beginY = Int(EverydayDetailsViewController.totalHeight)
            //56px以上是搜索框
            beginY += 56
        }
        
        //每天的总视图
        let everyTotalCopy = UIView()
        everyTotalCopy.frame = CGRect.init(x: 0, y: beginY, width: 414, height: everyTotalHeight)
        
        
        EverydayDetailsViewController.lastEverydayTotalHeight = everyTotalHeight
        //设置日期标签
        let whichDayLabelCopy = UILabel().setUILabelStyle()
        whichDayLabelCopy.frame = CGRect.init(x: 41, y: 10, width: 100, height: 45)
        //0号存了日期
        whichDayLabelCopy.text = singleGroup[0]
        
        //总视图的子视图
        let eachBaseViewCopy = UIView()
        eachBaseViewCopy.frame = CGRect.init(x: 20, y: 35, width: 374, height: eachViewHeight)
        EverydayDetailsViewController.lastEachBaseViewHeight = eachViewHeight
        setViewRoundAndShadow(view: eachBaseViewCopy)
        
        //每天收入支出
        let getTips = UILabel().miniFont()
        getTips.frame = CGRect.init(x:154,y:8,width: 27, height: 16)
        getTips.text = "收入"
        
        
        
        //计算支出金额
        var putTemp = 0.0
        //收入金额
        var getTemp = 0.0
        for i in 1...groups[tag].count-1{//0存年份，因此从1开始
            //计算过程
            let thisDayGet = EverydayDetailsViewController.everydayDetails[Int(groups[tag][i])!]
            if (thisDayGet.price > 0 ){//大于零支出
                putTemp  += thisDayGet.price
            }else{//小于0收入，特别注意
                getTemp += thisDayGet.price
            }
        }
        
        
        let getMoney = UILabel().miniFont()
        getMoney.frame = CGRect.init(x:180,y:8,width: 70, height: 16)
        getMoney.text = String(getTemp.cleanZero()) //去除多余0
        
        let putTips = UILabel().miniFont()
        putTips.frame = CGRect.init(x:260,y:8,width: 27, height: 16)
        putTips.text = "支出"
        
        let putMoney = UILabel().miniFont()
        putMoney.frame = CGRect.init(x:287,y:8,width: 70, height: 16)
        putMoney.text = String(putTemp.cleanZero()) //去除多余0
        //每天的table  view
        let eachDayTableViewCopy = UITableView()
        eachDayTableViewCopy.frame = CGRect.init(x: 0, y: 34, width: 374, height: tableHeight)
        
        EverydayDetailsViewController.lastTableViewHeight = tableHeight
        
        eachDayTableViewCopy.backgroundColor =   #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        eachDayTableViewCopy.isScrollEnabled = true
        //去除多余行
        eachDayTableViewCopy.tableFooterView = UIView()
        
        //设置代理和tag值
        eachDayTableViewCopy.delegate = self
        eachDayTableViewCopy.dataSource = self
        eachDayTableViewCopy.tag = tag
        
        //每天的table view cell
        let tableCellCopy = EverydayDetailsTableViewCell()
        
        EverydayDetailsViewController.staticCellID.insert(singleGroup[0], at: tag)
        let cellID : String = EverydayDetailsViewController.staticCellID[tag]
        //        print("cellID is \(cellID),ids are \(EverydayDetailsViewController.staticCellID)")
        //用日期作为cell的id
        eachDayTableViewCopy.register(EverydayDetailsTableViewCell.self, forCellReuseIdentifier: cellID)
        
        eachDayTableViewCopy.addSubview(tableCellCopy)
        eachBaseViewCopy.addSubview(eachDayTableViewCopy)
        eachBaseViewCopy.addSubview(getTips)
        eachBaseViewCopy.addSubview(getMoney)
        eachBaseViewCopy.addSubview(putTips)
        eachBaseViewCopy.addSubview(putMoney)
        everyTotalCopy.addSubview(eachBaseViewCopy)
        everyTotalCopy.addSubview(whichDayLabelCopy)
        
        //设置scroll的高度
        setRSHeight()
        
        EverydayDetailsViewController.everydayTotalArr.append(everyTotalCopy)
        EverydayDetailsViewController.eachdayBaseViewArr.append(eachBaseViewCopy)
        EverydayDetailsViewController.tableViewArr.append(eachDayTableViewCopy)
        EverydayDetailsViewController.getMoneyArr.append(getMoney)
        EverydayDetailsViewController.putMoneyArr.append(putMoney)
        
        EverydayDetailsViewController.lastEverydayTotal = everyTotalCopy//记录最后一天的 view
        EverydayDetailsViewController.lastEachBaseView = eachBaseViewCopy//
        return everyTotalCopy
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == eachDayTableView ){
            return EverydayDetailsViewController.everydayDetails.count
        }else{
            //根据不同组返回不同行数
            let pos = tableView.tag
            //                    print("finished4,EverydayDetailsViewController.allDeleted is \(EverydayDetailsViewController.allDeleted)")
            if (pos == 0){
                print("返回了 \(groups[pos].count-1)")
            }
            
            if (EverydayDetailsViewController.allDeleted){//如果该table view已经删光了，返回0
                print("全删完了，返回0")
                EverydayDetailsViewController.allDeleted = false
                return 0
            }else{
                
                //                print("在返回行数方法这里，groupsCopy[pos] 是\(groupsCopy[pos])")
                //首先判断是在添加操作还是删除操作
                if (EverydayDetailsViewController.operateDelete){//如果是在进行删除操作
                    print("B2返回了\(groupsCopy[pos].count-1),groupsCopy[pos] is \(groupsCopy[pos])")
                    return groupsCopy[pos].count - 1
                    
                }else{//如果不是在进行删除数据操作
                    print("C返回了\(groups[pos].count-1)")
                    return groups[pos].count - 1
                }
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //pos为数组中的第x组
        let pos = tableView.tag
        let cellID  =  EverydayDetailsViewController.staticCellID[pos]
        //注册到class
        tableView.register(EverydayDetailsTableViewCell.self, forCellReuseIdentifier: cellID)//此行代码保证程序不崩🌚
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? EverydayDetailsTableViewCell
        let everydayDetail = EverydayDetailsViewController.everydayDetails[Int(groups[pos][indexPath.row+1])!]
        //向table  view cell填控件和数据
        let activityNameLabel = UILabel()
        activityNameLabel.frame = CGRect.init(x: 112, y: 10, width: 140, height: 20)
        
        let activityPrice = UILabel()
        activityPrice.frame = CGRect.init(x: 288, y: 10, width: 73, height: 20)
        
        let activityIcon = UIImageView()
        activityIcon.frame = CGRect.init(x: 20, y: 10, width: 25, height: 25)
        
        if (EverydayDetailsViewController.added){//如果添加了数据
            if (indexPath.row == 0){
                EverydayDetailsViewController.lastIndexpath = indexPath
                
                if (!EverydayDetailsViewController.hasUpdatedGetAndPutLabel){//如果还没有更新收入支出，就更新收入支出
                    if (everydayDetail.price < 0){ //如果小于零，说明是收入
                        EverydayDetailsViewController.getMoneyArr[pos].text = String(Double(EverydayDetailsViewController.getMoneyArr[pos].text!)!+everydayDetail.price )//重新计算每天收入
                    }else{//说明是支出
                        EverydayDetailsViewController.putMoneyArr[pos].text = String(Double(EverydayDetailsViewController.putMoneyArr[pos].text!)!+everydayDetail.price )//重新计算每天支出
                    }
                    EverydayDetailsViewController.hasUpdatedGetAndPutLabel = true//置更新标志位为已更新
                }
            }
            print("index path row is \(indexPath.row)")
            cell = nil
            cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? EverydayDetailsTableViewCell
            print("移除1")
            print("finished3")
        }
        //填数据
        activityNameLabel.text = everydayDetail.name
        activityPrice.text = everydayDetail.price.cleanZero() //去除多余0
        activityIcon.image = UIImage(named: everydayDetail.kind!+".png" )
        
        
        cell!.contentView.addSubview(activityNameLabel)
        cell!.contentView.addSubview(activityPrice)
        cell!.contentView.addSubview(activityIcon)
        
        //使加号按钮始终悬浮
        scroll.bringSubviewToFront(addThingsView)
        EverydayDetailsViewController.lastTableView = tableView//记忆第一天的table view,因为上面更新数据时是最新的table view
        
        return cell!
        
        
    }
    
    //选择此行数据则删除-此方法暂时禁用
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //左滑删除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            EverydayDetailsViewController.allDeleted = false
            EverydayDetailsViewController.operateDelete = true
            print("\n\n\n")
            //首先判断视图会不会删完，也就是判断所删除的数据是不是这一天唯一一条数据
            var tag = tableView.tag
            let tagOrigin = tag
            var  offset = 0
            offset = findMinusOffset(tagOrigin, EverydayDetailsViewController.deletedViewsTag)
            
            print("tagOrigin is [\(tagOrigin)],groupsCopy[tagOrigin] is \(groupsCopy[tagOrigin])")
            //下面代码勿删👇
            if (groupsCopy[tagOrigin].count == 2){ //如果该组数据只剩一条（不包括年份数据）,说明就要删完了，将tag记录下来
                print("添加tag")
                if (!ifContains(EverydayDetailsViewController.deletedViewsTag, tagOrigin)){//如果不包含tag，则添加该tag。否则不添加
                    EverydayDetailsViewController.deletedViewsTag.append(tagOrigin)
                    
                    print("tag 是\(tag),添加tag后,EverydayDetailsViewController.deletedViewsTag is \(EverydayDetailsViewController.deletedViewsTag)")
                }
            }
            
            if (groupsCopy[tagOrigin].count > 2){//移除copy中的一个数据，甚至可以不用精确，只是为了返回函数中判定个数
                groupsCopy[tagOrigin].remove(at: indexPath.row+1)
            }
            
            if (EverydayDetailsViewController.hasDeletedOneTable){  //如果之前删去了一天，则进行偏移，否则如果没有删去一天,而只是删去一天内的某条数据则不偏移
                print("offset is \(offset)")
                tag -= (offset)
            }
            
            let  pos =  Int(groups[tag][indexPath.row+1])!
            
            if (groups[tag].count == 2){//如果只剩一条数据（还有一条存储年份的数据）,删除数据，然后删除视图
                EverydayDetailsViewController.allDeleted = true
                EverydayDetailsViewController.everydayTotalArr[tagOrigin].isHidden = true//隐藏本视图
                EverydayDetailsViewController.hasDeletedOneTable  = true //代表删除过一张卡片
                //从context删除
                deleteOneDetail(detail: EverydayDetailsViewController.everydayDetails[pos])
                //从数组中删除
                EverydayDetailsViewController.everydayDetails.remove(at: pos)
                //将id从数组中移除
                EverydayDetailsViewController.staticCellID.remove(at: tagOrigin)
                
                //刷新cell数据源
                loadDataSource()
                //刷新groups数组
                groups = sortItemByDate(EverydayDetailsViewController.everydayDetails)
                //在此视图之上的视图不动，之下的视图上移,此视图隐藏
                viewMoveDown(EverydayDetailsViewController.everydayTotalArr,-189,includeFirstView: false, defaultStartIndex: tag+offset)//
                
            }else{//否则仅仅删除数据，保留视图
                print("在这里,groups[tag] is \(groups[tag]),tag is \(tag)")
                //从context删除
                deleteOneDetail(detail: EverydayDetailsViewController.everydayDetails[pos])
                //从数组中删除
                EverydayDetailsViewController.everydayDetails.remove(at: pos)
                //刷新cell数据源
                loadDataSource()
                //刷新groups数组
                groups = sortItemByDate(EverydayDetailsViewController.everydayDetails)
                
                //刷新cell显示
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
                //勿删👇
                tag += offset
                
                //在此视图之上的视图不动，之下的视图上移1个cell的距离
                viewMoveDown(EverydayDetailsViewController.everydayTotalArr,-40,includeFirstView: false, defaultStartIndex: tag+1)//视图之下上移
                //自身table view 及其父视图高度降低
                
                EverydayDetailsViewController.everydayTotalArr[tag].frame.size.height -= 40
                EverydayDetailsViewController.eachdayBaseViewArr[tag].frame.size.height -= 40
                EverydayDetailsViewController.tableViewArr[tag].frame.size.height -= 40
                
            }
            print("\n\n")
        }
    }
    //改变一个UIVIEW数组中tag的值
    func changeViewsTagValue(_ views:[UIView],_ offset:Int,_ startIndex:Int,_ endIndex:Int)->[UIView]{
        var res = views
        for i in startIndex...endIndex{
            res[i].tag = res[i].tag - 1  //tag值减少offset
        }
        return res
    }
    
    //删除一行数据并保存至coreData，注意everydayDetails数组中的数据并未删除，可选择重载数据刷新或删除everydayDetails中相应数据
    func  deleteOneDetail(detail:EverydayDetails){
        context.delete(detail)
        do {
            try context.save()
            print("已删除")
        } catch  {
            print("删除失败")
        }
        
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        //初始化视图
        initUI()
        //载入数据
        //        loadData()
        DetailsDao().deleteAll()
        //打印路径
        printPath()
        //                        chooseKindandInputViewController().create999Details()
        //                chooseKindandInputViewController().createRealDate()
        print("加载一次")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searching = false
        if (meViewController.loadFlag == 1){
            //动画提示
            createActivityIndicator()
            activityIndicator?.startAnimating()
            //添加按钮和搜索框不隐藏
            scroll.subviews.forEach({  if (!(($0 is UISearchBar) || ($0.tag == -9999))  ){
                $0.isHidden = true
                }})
            loadData()
            self.scroll.layoutIfNeeded()
        }
        meViewController.loadFlag = -1
    }

    
    //从添加数据页面返回重新加载
    @IBAction func back(segue: UIStoryboardSegue) {
        EverydayDetailsViewController.operateDelete = false  //置删除标志位
        searching = false //置搜索标志位
        if (EverydayDetailsViewController.added ){//如果添加了数据
            EverydayDetailsViewController.hasUpdatedGetAndPutLabel = false//置更新标志位
            let oldCount  = groups.count//旧的数据组 条数
            //刷新数据源
            loadDataSource()
            groups = sortItemByDate(EverydayDetailsViewController.everydayDetails)
            //更新groupsCopy
            groupsCopy = groups
            let newCount  = groups.count //刷新数据源后，新的数据组 条数
            print("new groups.count is \(newCount)")
            if (newCount == oldCount){//如果新旧条数相等，说明还是同一天增加的
                addInTheSameDay()  //在已有天数上添加数据
            }else{ //新的一天直接重载所有数据
                print("新的一天")
            }
        }
    }
    
    //视图移动指定距离
    func viewMoveDown(_ viewArr:[UIView],_ offSet:Int,includeFirstView:Bool,defaultStartIndex: Int){
        if (defaultStartIndex <= viewArr.count-1){//防止越界
            for i in defaultStartIndex...viewArr.count-1{//最后一个不移动（数组的最后一个有可能是第一个视图，看之前有没有添加新的一天
                viewArr[i].frame.origin.y += CGFloat(offSet)
            }
        }
        if (includeFirstView){//如果包括第一位一位也要移动
            viewArr[0].frame.origin.y -=  CGFloat(offSet)
        }
    }
    
    //在已有数据table view上添加新数据
    func addInTheSameDay(){
        
        //刷新数据源
        loadDataSource()
        groups = sortItemByDate(EverydayDetailsViewController.everydayDetails)
        //样例视图刷新数据
        //        eachDayTableView.reloadData()
        //重载数据
        EverydayDetailsViewController.lastTableView!.reloadData()
        //刷新最近一个tableview的cell
        for i in EverydayDetailsViewController.lastTableView!.indexPathsForVisibleRows!{
            EverydayDetailsViewController.lastTableView!.reloadRows(at: [i], with: .none)
        }
        print(" EverydayDetailsViewController.eachdayBaseViewArr is \( EverydayDetailsViewController.eachdayBaseViewArr)")
        //设置当天高度增加
        EverydayDetailsViewController.eachdayBaseViewArr[0].frame.size.height +=  40
        EverydayDetailsViewController.everydayTotalArr[0].frame.size.height += 40
        //添加的那一天高度增加
        EverydayDetailsViewController.lastTableView!.frame.size.height += 40
        //刷新最新一行
        EverydayDetailsViewController.lastTableView?.reloadRows(at: [EverydayDetailsViewController.lastIndexpath!], with: .none)
        //其他所有视图往下移
        viewMoveDown(EverydayDetailsViewController.everydayTotalArr,44,includeFirstView: false, defaultStartIndex: 1) //用旧的数组，最后一位不移动（）
        //还原添加标志位
        EverydayDetailsViewController.added  =  false
        
        
    }
    
    //判断是不是某天的第一条数据，(要不要创建一张新卡片)
    static func theFirstDateOfthisDay(_ dateStr:String)->Bool{
        for i in EverydayDetailsViewController.staticCellID{
            if (i == dateStr){
                return false
            }
        }
        return true
    }
    
    //初始化ui
    func initUI(){
        
        //隐藏样例视图
        everydayTotal.isHidden = true
        //        eachDayTableView.delegate = self
        //        eachDayTableView.dataSource = self
        //设置阴影
        setViewRoundAndShadow(view: self.eachView)
        //去除多余行
        self.eachDayTableView.tableFooterView = UIView()
        //设置时间
        setData()
        //定时刷新设置的时间
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(EverydayDetailsViewController.setData), userInfo: nil, repeats: true)
        addThingsView.tag = -9999
        
    }
    //载入数据
    public func loadData(){
        loadDataSource()
        //定时加载数据
        EverydayDetailsViewController.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EverydayDetailsViewController.loadEveryday), userInfo: nil, repeats: true)
        print("开始加载数据")
        
    }
    //打印路径
    func printPath(){
        let a = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
        print("the path is \(a)")
    }
    
    // 停止计时
    func stopTimer() {
        if EverydayDetailsViewController.timer != nil {
            EverydayDetailsViewController.timer!.invalidate() //销毁timer
            EverydayDetailsViewController.timer = nil
            
            
        }
    }
    
    var groupsCopy = [[String]]()
    
    @objc func loadEveryday(){
        //数据分组
        groups = sortItemByDate(EverydayDetailsViewController.everydayDetails)
        
        //复制groups备用
        groupsCopy = groups
        
        print("groups 数量\(groups.count)")
        //根据分组的个数（即天数）生成同样数量的view
        //从上次加载完的pos开始加载
        if (EverydayDetailsViewController.loadPos <= groups.count-1){
            for i in EverydayDetailsViewController.loadPos...groups.count-1{
                var tempView = UIView()
                tempView = addOneDay(groups[i],i,true)//按顺序生成
                scroll.addSubview(tempView)
                EverydayDetailsViewController.loadPos = EverydayDetailsViewController.loadPos + 1
            }
        }else{
            //加载完成，销毁计时器
            print("加载完成，销毁计时器")
            activityIndicator?.stopAnimating()
            stopTimer()
            if (!searching){//如果没有正在搜索
                //加载搜索框
                loadSearchBar()
            }
        }
    }
    
    var searching = false
    
    func createActivityIndicator(){
        activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator?.frame = CGRect.init(x: 207, y: 300, width: 15, height: 15)
        scroll.addSubview(activityIndicator!)
    }
    
    //加载搜索框到scroll view
    func loadSearchBar(){
        let searchBar : UISearchBar = UISearchBar()
        searchBar.frame = CGRect.init(x: 0, y: 0, width: 414, height: 56)
        scroll.addSubview(searchBar)
        //动画提示搜索框的存在
        UIView.animate(withDuration: 1.8, animations: {
            self.scroll.setContentOffset(CGPoint(x:0,y:56), animated: false)
        })
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
        
    }
    
    //以下全是search bar delegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
        searching = true //置搜索标志位为true
        let keyword = searchBar.text
        if (keyword != nil){
            //呈现搜索结果
            let request: NSFetchRequest<EverydayDetails> = EverydayDetails.fetchRequest()
            let predicate  = NSPredicate(format: "name CONTAINS[c] %@", keyword!)
            request.predicate = predicate
            //按照日期增量排序
            let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
            request.sortDescriptors = [sortDescriptor]
            do {
                let searchResEverydayDetails = try context.fetch(request)
                //搜索栏不隐藏
                scroll.subviews.forEach({
                    if (!($0 is UISearchBar)){
                        $0.isHidden = true
                        
                    }
                })
                if (searchResEverydayDetails != []){ //不为空加载
                    //动画
                    createActivityIndicator()
                    activityIndicator?.startAnimating()
                    readyToReloadData()
                    //替换数据源
                    EverydayDetailsViewController.everydayDetails = searchResEverydayDetails
                    EverydayDetailsViewController.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EverydayDetailsViewController.loadEveryday), userInfo: nil, repeats: true)
                    print("开始加载数据")
                }else{//搜索结果为空提示
                    activityIndicator?.stopAnimating()
                    let tipsLabel = UILabel()
                    tipsLabel.frame = CGRect.init(x: 150, y: 200, width: 200, height: 100)
                    tipsLabel.text = "没有搜索结果"
                    scroll.addSubview(tipsLabel)
                    
                }
            }catch{
                
            }
            
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        activityIndicator?.stopAnimating()
        searching = false //置搜索标志位为false
        readyToReloadData()
        scroll.subviews.forEach({ $0.isHidden = true })
        //重载数据
        loadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitle("取消", for: .normal)
        
    }
    
    //载入数据
    func loadDataSource(){
        
        let request: NSFetchRequest<EverydayDetails> = EverydayDetails.fetchRequest()
        do {
            //获取数据
            let tempEverydayDetails = try context.fetch(request)
            print("数据总量:\(tempEverydayDetails.count)")
            //按日期排序
            EverydayDetailsViewController.everydayDetails = DetailsDao().sortByDate(tempEverydayDetails)
            print("此处数据总量:\( EverydayDetailsViewController.everydayDetails.count)")
            //            print("排序后\(EverydayDetailsViewController.everydayDetails )")
        }catch{
            print("从context获取数据错误")
        }
    }
    
    //清除所有缓存
    func readyToReloadData(){
        EverydayDetailsViewController.everydayTotalArr = [UIView]()
        EverydayDetailsViewController.eachdayBaseViewArr = [UIView]()
        EverydayDetailsViewController.tableViewArr = [UITableView]()
        EverydayDetailsViewController.lastTableView = UITableView()
        EverydayDetailsViewController.lastViewHeight = 0
        EverydayDetailsViewController.totalHeight = 0
        EverydayDetailsViewController.staticCellID = [String]()
        EverydayDetailsViewController.loadPos = 0
        //设置标志位，代表重载
        meViewController.loadFlag = 1
    }
    
    //将数据按照日期分组
    func sortItemByDate(_ allData: [EverydayDetails])->[[String]]{
        groups = DetailsDao().sortItemBySpecialDatePattern(allData, datePattern: "yyyy-MM-dd")
        return groups
    }
    
    //设置页面label上的年月日时分
    @objc func setData(){
        let time = DetailsDao().getYMDOfDate(Date())
        yearOfData.text = String(time.year)
        for i in 0...monthInChinese.count{
            if (monthInChinese[0][i] == String(time.month)){
                monthOfData.text = monthInChinese[1][i]
            }
        }
        dayOfData.text = time.day
        hours.text = String(time.hours+":"+time.minute)
        mornigOrAfternoonLabel.text = (Int(time.hours)! >= 12 ? "PM":"AM")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //找到每个view要移动的位数
    func findMinusOffset(_ tag :Int,_ tags:[Int])->Int{
        var count = 0
        for i in tags{
            if (tag > i){
                count += 1
            }
        }
        return count
    }
    
    //判断数组是否含有某项元素
    func ifContains(_ arr:[Int],_ item:Int)->Bool{
        for i in arr{
            if (item == i){
                return true
            }
        }
        return false
    }
    
    //设置view风格
    func setViewRoundAndShadow(view : UIView){
        //为轮廓添加阴影和圆角
        view.backgroundColor =   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.layer.shadowOffset = CGSize.init()//(0,0)时是四周都有阴影
        view.layer.shadowColor =   #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1);
        view.layer.shadowOpacity = 0.8;
        view.layer.shadowRadius = 5
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = false
        view.layer.borderColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.layer.borderWidth = 0.25//设置边框线条粗细
        
    }
}

//设置uilabel样式
extension UILabel{
    func setUILabelStyle()->UILabel{
        let temp  = UILabel()
        temp.text = self.text
        temp.backgroundColor =   #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        temp.layer.borderWidth = 1.0
        temp.layer.cornerRadius = 15
        temp.clipsToBounds = true
        temp.textColor = self.textColor
        temp.textAlignment = NSTextAlignment(rawValue: 1)!
        temp.textColor =   #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        temp.font = UIFont(name: "占位符", size: 5)
        return temp
        
    }
    
    func miniFont()->UILabel{
        let temp  = UILabel()
        temp.text = self.text
        temp.backgroundColor =   #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //        temp.font = UIFont(name: "占位符", size: 4)
        temp.font = self.font.withSize(13)
        temp.textAlignment = .left
        return temp
        
    }
}





