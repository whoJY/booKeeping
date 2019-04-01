//
//  exchangeRateViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/2.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit
import Charts

class exchangeRateViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var Acurrency: UILabel!
    @IBOutlet weak var Bcurrency: UILabel!
    
    @IBOutlet weak var chooseCountryView: UIView!
    
    @IBOutlet weak var countryAImg: UIImageView!
    @IBOutlet weak var countryBImg: UIImageView!
    @IBOutlet weak var countryAMoney: UITextField!
    @IBOutlet weak var countryBMoney: UITextField!
    @IBOutlet weak var transImg: UIImageView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var flagsPanelCollection: UICollectionView!
    
    func initUI(){
        countryAImg.image = UIImage(named: "CNY.png")
        countryBImg.image = UIImage(named: "USD.png")
        transImg.image = UIImage(named: "doubleArrow.png")
        //默认隐藏选择国家区域
        chooseCountryView.isHidden = true
        btn1.tag = 1
        btn2.tag = 2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        addListener()
        dateArray = flagsName
        //设置横向布局
        flagsPanelCollection.isPagingEnabled = true
        flagsPanelCollection.delegate = self
        flagsPanelCollection.dataSource = self
        //        f()
        searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateArray![0].count
    }
   
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "flagsCollectionViewCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! flagsCollectionViewCell
        cell.flags.image = UIImage(named: flagsName[0][indexPath.row]+".png")
        cell.countryName.text = flagsName[1][indexPath.row]
        return cell
    }
    
    
    var choosedBtnTag = -1
    var Acur = "CNY"
    var Bcur = "USD"
    //选择则替换
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //重置换算数据
        countryAMoney.text = ""
        countryBMoney.text = ""
        
        
        //替换icon
        let img = (choosedBtnTag == 1 ? countryAImg : countryBImg)
        img?.image = UIImage(named: dateArray![0][indexPath.row] + ".png")
        if (choosedBtnTag == 1){
            Acur = dateArray![0][indexPath.row]
            Acurrency.text = dateArray![0][indexPath.row]
        }else{
            Bcur = dateArray![0][indexPath.row]
            Bcurrency.text = dateArray![0][indexPath.row]
        }
        
    }
    
    //搜索框代理方法
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        (searchBar.value(forKey: "cancelButton") as! UIButton).setTitle("取消", for: .normal)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //收起键盘
        searchBar.resignFirstResponder()
        //重载数据
        dateArray = flagsName
        flagsPanelCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //收起键盘
        searchBar.resignFirstResponder()
        let keyword = searchBar.text
        if (keyword != nil){
            let res = search(flagsName, keyword!)
            dateArray = res
            //重载数据
            flagsPanelCollection.reloadData()
        }
        
    }
    
    
    
    @IBAction func chooseCountry(_ sender: UIButton?) {
        choosedBtnTag = (sender?.tag)!
        chooseCountryView.isHidden = false
        
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
        //获取汇率
        var jsonStr = HttpUtil().askWebService("exchangeRate", Acur, Bcur)
        jsonStr = jsonStr.replacingOccurrences(of: "&quot;", with: "\"")
        let res = JsonUtil().parseCurrencyResJsonByhand(jsonStr)
        let rate = res.rate
        
        countryBMoney.text = String (format: "%.2f", calculateA(moneyA ?? 0, rate))
        
    }
    
    @objc func textFieldBDidChange(_ textField: UITextField) {
        let moneyB = Double(textField.text ?? "0")
        //获取汇率
        var jsonStr = HttpUtil().askWebService("exchangeRate", Acur, Bcur)
        jsonStr = jsonStr.replacingOccurrences(of: "&quot;", with: "\"")
        let res = JsonUtil().parseCurrencyResJsonByhand(jsonStr)
        let rate = res.rate
        countryAMoney.text = String (format: "%.2f", calculateA(moneyB ?? 0, rate))
        
    }
    
   
    func search(_ countries:[[String]],_ keyword:String)->[[String]]{
        var copy = countries
        var res = [[""],[""]]
        
        for i in 0...copy[1].count-1{
            if (copy[1][i].contains(keyword)){
               res[0].append(copy[0][i])
                res[1].append(copy[1][i])
                
            }
        }
        return res
    }
    
    var dateArray : [[String]]? = nil
    
   let  flagsName = [["AED","AFN","ALL","AMD","ANG","AOA","ARS","AUD","AWG","AZN","BAM","BBD","BDT","BGN","BHD","BIF","BMD","BND","BOB","BRL","BSD","BTN","BWP","BYR","BZD","CAD","CDF","CHF","CLF","CLP","CNH","CNY","COP","CRC","CUP","CVE","CZK","DJF","DKK","DOP","DZD","EGP","ERN","ETB","EUR","FJD","FKP","GBP","GEL","GHS","GIP","GMD","GNF","GTQ","GYD","HKD","HNL","HRK","HTG","HUF","IDR","ILS","INR","IQD","IRR","ISK","JMD","JOD","JPY","KES","KGS","KHR","KMF","KPW","KRW","KWD","KYD","KZT","LAK","LBP","LKR","LRD","LSL","LTL","LVL","LYD","MAD","MDL","MGA","MKD","MMK","MNT","MOP","MRO","MUR","MVR","MWK","MXN","MYR","MZN","NAD","NGN","NIO","NOK","NPR","NZD","OMR","PAB","PEN","PGK","PHP","PKR","PLN","PYG","QAR","RON","RSD","RUB","RWF","SAR","SBD","SCR","SDG","SEK","SGD","SHP","SLL","SOS","SRD","STD","SVC","SYP","SZL","THB","TJS","TMT","TND","TOP","TRY","TTD","TWD","TZS","UAH","UGX","USD","UYU","UZS","VEF","VND","VUV","WST","XAF","XAU","XCD","XDR","XOF","XPF","YER","ZAR","ZMW","ZWL"],["阿联酋迪拉姆","阿富汗尼","阿尔巴尼亚列克","亚美尼亚德拉姆","荷兰盾","安哥拉宽扎","阿根廷披索","澳大利亚元","阿鲁巴盾","阿塞拜疆新马纳特","波斯尼亚和黑塞哥维那可","巴巴多斯元","孟加拉国塔卡","保加利亚列瓦","巴林第纳尔","布隆迪法郎","百慕大元","文莱元","玻利维亚诺","巴西雷亚尔","巴哈马元","不丹努扎姆","博茨瓦纳普拉","白俄罗斯卢布","伯利兹元","加拿大元","刚果法郎","瑞士法郎","智利比索","智利比索","离岸人民币","人民币","哥伦比亚比索","哥斯达黎加科朗","古巴比索","佛得角埃斯库多","捷克克朗","吉布提法郎","丹麦克朗","多米尼加比索","阿尔及利亚第纳尔","埃及镑","厄立特里亚","埃塞俄比亚比尔","欧元","斐济元","福克兰群岛镑","英镑","格鲁吉亚拉里","加纳塞地","直布罗陀镑","冈比亚达拉西","几内亚法郎","危地马拉格查尔","圭亚那元","港币","洪都拉斯伦皮拉","克罗地亚库纳","海地古德","匈牙利福林","印度尼西亚盾","以色列谢克尔","印度卢比","伊拉克第纳尔","伊朗里亚尔","冰岛克朗","牙买加元","约旦第纳尔","日元","肯尼亚先令","吉尔吉斯索姆","柬埔寨瑞尔","科摩罗法郎","朝鲜元","韩国元","科威特第纳尔","开曼群岛元","哈萨克斯坦坚戈","老挝基普","黎巴嫩镑","斯里兰卡卢比","利比里亚元","莱索托洛提","立陶宛立特","拉脱维亚拉特","利比亚第纳尔","摩洛哥迪拉姆","摩尔多瓦列伊","马达加斯加阿里亚里","马其顿第纳尔","缅元","蒙古图格里克","澳门币","毛里塔尼亚乌吉亚","毛里求斯卢比","马尔代夫拉菲亚","马拉维克瓦查","墨西哥比索","马来西亚林吉特","莫桑比克梅蒂卡尔","纳米比亚元","尼日利亚第纳尔","尼加拉瓜科多巴","挪威克朗","尼泊尔卢比","新西兰元","阿曼里亚尔","巴拿马巴波亚","秘鲁新索尔","新几内亚基那基那","菲律宾比索","巴基斯坦卢比","波兰兹罗提","巴拉圭瓜拉尼","卡塔尔里亚尔","罗马尼亚列伊","塞尔维亚第纳尔","俄罗斯卢布","卢旺达法郎","沙特阿拉伯里亚尔","所罗门群岛元","塞舌尔卢比","苏丹镑","瑞典克朗","新加坡元","圣赫勒拿镑","塞拉利昂利昂","索马里先令","苏里南元","圣多美多布拉","萨尔瓦多科朗","叙利亚镑","斯威士兰里兰吉尼","泰铢","塔吉克斯坦索莫尼","土库曼斯坦马纳特","突尼斯第纳尔","TOP","土耳其里拉","特立尼达和多巴哥元","台币","坦桑尼亚先令","乌克兰格里夫纳","乌干达先令","美元","乌拉圭比索","乌兹别克斯坦索姆","委内瑞拉玻利瓦尔","越南盾","瓦努阿图瓦图","萨摩亚塔拉","中非法郎","黄金","东加勒比元","特别提款权（国际货币基金）","西非法郎","太平洋法郎","也门里亚尔","南非兰特","赞比亚克瓦查","津巴布韦元"]]
    
}
