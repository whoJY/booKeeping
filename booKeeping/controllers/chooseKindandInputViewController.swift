//
//  chooseKindandInputViewController.swift
//  booKeeping
//
//  Created by hujinyu on 2019/2/13.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import UIKit

class chooseKindandInputViewController: UIViewController {
    
    var  tempDetailsDataArray2 = [EverydayDetails]()
    
    
    
    @IBOutlet weak var tipBar: UILabel!
    @IBOutlet weak var tipBar2: UILabel!
    @IBOutlet weak var putBtn: UIButton!
    @IBOutlet weak var getBtn: UIButton!
    
    
    @IBOutlet weak var eatBtn:UIButton!
    @IBOutlet weak var healthBtn:UIButton!
    @IBOutlet weak var studyBtn:UIButton!
    @IBOutlet weak var trafficBtn:UIButton!
    
    
    @IBOutlet weak var clothesBtn:UIButton!
    @IBOutlet weak var communicationBtn:UIButton!
    @IBOutlet weak var petsBtn:UIButton!
    @IBOutlet weak var othersBtn:UIButton!
    
    
    @IBOutlet weak var clothesImg: UIImageView!
    @IBOutlet weak var communicationImg: UIImageView!
    @IBOutlet weak var petsImg: UIImageView!
    @IBOutlet weak var othersImg: UIImageView!
    
    @IBOutlet weak var keyboardNumber1Btn: UIButton!
    @IBOutlet weak var keyboardNumber2Btn: UIButton!
    @IBOutlet weak var keyboardNumber3Btn: UIButton!
    @IBOutlet weak var keyboardNumber4Btn: UIButton!
    @IBOutlet weak var keyboardNumber5Btn: UIButton!
    @IBOutlet weak var keyboardNumber6Btn: UIButton!
    @IBOutlet weak var keyboardNumber7Btn: UIButton!
    @IBOutlet weak var keyboardNumber8Btn: UIButton!
    @IBOutlet weak var keyboardNumber9Btn: UIButton!
    @IBOutlet weak var keyboardNumber0Btn: UIButton!
    @IBOutlet weak var keyboardDeleteBtn: UIButton!
    @IBOutlet weak var keyboardFinishedBtn: UIButton!
    @IBOutlet weak var keyboardPointBtn: UIButton!
    
    @IBOutlet weak var eatIcon: UIImageView!
    @IBOutlet weak var healthIcon: UIImageView!
    @IBOutlet weak var studyIcon: UIImageView!
    @IBOutlet weak var trafficIcon: UIImageView!
    
    
    @IBOutlet weak var inputNameTextFd: UITextField!
    @IBOutlet weak var ensureAndCloseBtn: UIButton!
    @IBOutlet weak var inputPriceTextFd:UITextField!
    
    @IBOutlet weak var inputAreaView: UIView!
    
    static  var choosedKindTag = -999
    
    //点击确定按钮
    @IBAction func ensureAndCloseView(_ ensureAndCloseBtn: UIButton ){
     
        let dateStr = DateUtil().DateToStringYMD(Date())
        print("判定结果:\(EverydayDetailsViewController.theFirstDateOfthisDay(dateStr))")
        if (EverydayDetailsViewController.theFirstDateOfthisDay(dateStr)){//如果是第一条数据，要创建新卡片
            reloadDataOfEVC()
        }

        //保存数据
        saveNewItemsToCoreData()
        //置添加标志位为true
        EverydayDetailsViewController.added = true
        
    }
    
    func reloadDataOfEVC(){
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
    
    //初始化种类图标
    func initIcon(){
        eatIcon.image = UIImage(named: "eat.png")
        healthIcon.image = UIImage(named: "health.png")
        studyIcon.image = UIImage(named: "study.png")
        trafficIcon.image = UIImage(named: "traffic.png")
        clothesImg.image = UIImage(named: "clothes.png")
        communicationImg.image = UIImage(named: "communication.png")
        petsImg.image = UIImage(named: "pets.png")
        othersImg.image = UIImage(named: "others.png")
        
    }
    
    
    //初始化按钮tag
    func initBtn(){
        //支出收入按钮tag
        getBtn.tag = 1000
        putBtn.tag = 1001
        tipBar2.backgroundColor = #colorLiteral(red: 0.9928546548, green: 0.8518775105, blue: 0.265756309, alpha: 1)
        
        
        //禁止弹出系统键盘,只允许从键盘区域输入数字
        inputPriceTextFd.isUserInteractionEnabled = false
        inputPriceTextFd.text = "0" //默认值为0
        
        //设置种类按钮的tag
        eatBtn.tag = 2000
        healthBtn.tag = 2001
        studyBtn.tag = 2002
        trafficBtn.tag = 2003
        
        clothesBtn.tag = 2004
        communicationBtn.tag = 2005
        petsBtn.tag = 2006
        othersBtn.tag = 2007
        //设置各个数字键盘按钮的tag为其数学值
        keyboardNumber0Btn.tag = 0
        keyboardNumber1Btn.tag = 1
        keyboardNumber2Btn.tag = 2
        keyboardNumber3Btn.tag = 3
        keyboardNumber4Btn.tag = 4
        keyboardNumber5Btn.tag = 5
        keyboardNumber6Btn.tag = 6
        keyboardNumber7Btn.tag = 7
        keyboardNumber8Btn.tag = 8
        keyboardNumber9Btn.tag = 9
        //设置小数点按钮的tag为-2
        keyboardPointBtn.tag = -2
        //设置删除按钮的tag为-1
        keyboardDeleteBtn.tag = -1
        //设置完成按钮的tag为1
        keyboardFinishedBtn.tag = -3
        
    }
    
    
    //为自定义键盘添加监听
    @IBAction func listeningInputNumber(_ sender:UIButton?){
        if ((sender?.tag)! >= 0){//若tag>=0，说明是数字
            
            
            if (Double(inputPriceTextFd.text!) == 0){//若价格为0，则去0添加键盘数字
                inputPriceTextFd.text = String(sender!.tag)
            }else{//否则添加数字
                inputPriceTextFd.text! += String(sender!.tag)
            }
        }else{//对非数字键盘的处理(小数点和删除按钮)
            
            if (sender?.tag == -2){//如果是小数点
                if (!(inputPriceTextFd.text?.contains("."))!){//，若之前未输入小数点，则添加小数点，
                    inputPriceTextFd.text! += "."
                   
                }
                
            }else if (sender?.tag == -1){//如果是删除按钮,
                if (inputPriceTextFd.text?.count == 1){//如果只有1位，则置0
                    inputPriceTextFd.text = "0"
                }
                else{//否则减去最后一位
                   
                    inputPriceTextFd.text = ((inputPriceTextFd.text!) as NSString).substring(to: (inputPriceTextFd.text?.count)!-1)
                    
                }
            }
            
        }
        
        

    }
    
    @IBAction func callBackKeyBoard(_ sender: UIButton) {
        print("收起键盘")
        inputNameTextFd.resignFirstResponder()
    }
    
    
    //默认输入区域不可见，除非触发可见
    func initInputArea(_ active : Bool) {
        if (!active){
            inputAreaView.alpha = 0
            inputAreaView.isUserInteractionEnabled = false
        }else{
            inputAreaView.alpha = 1
            inputAreaView.isUserInteractionEnabled = true
        }
    }
    
    //    获取选择的种类
    @IBAction func getKindOfChoice(sender:UIButton?){
        
        //设置种类tag
        chooseKindandInputViewController.choosedKindTag = (sender?.tag)!
        
        
        //激活输入备注、价格区域
        initInputArea(true)
        
    }
    
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //使用coredata存储数据
    func saveNewItemsToCoreData(){
        var tempName:String
        var tempPrice:Double
        var tempDate:Date
        //设置默认名字为"unknown name"
        tempName = inputNameTextFd.text ?? "unknown name"
        //设置默认价格
        tempPrice = Double(inputPriceTextFd.text!) ?? -99999
        tempDate = Date()
        var kind=""
        var photoName = ""
        
        switch(chooseKindandInputViewController.choosedKindTag)
        {
            
        case 2000:
            kind = "eat"
            photoName = kind+".png"
            break;
        case 2001:
            kind = "health"
            photoName = kind+".png"
            break;
        case 2002:
            kind = "study"
            photoName = kind+".png"
            break;
        case 2003:
            kind = "traffic"
            photoName = kind+".png"
            break;
        case 2004:
            kind = "clothes"
            photoName = kind+".png"
            break;
        case 2005:
            kind = "communication"
            photoName = kind+".png"
            break;
        case 2006:
            kind = "pets"
            photoName = kind+".png"
            break;
        case 2007:
            kind = "others"
            photoName = kind+".png"
            break;
        default:
            break;
        }
        //        var tempDetails : EverydayDetails
        //
        //        tempDetails.date = tempDate
        //        tempDetails.kind = kind
        //        tempDetails.name = tempName
        //        tempDetails.photoName = photoName
        //
        
        
        DetailsDao().saveDao(tempName, tempPrice, tempDate,kind,photoName)
        //        EverydayDetailsViewController.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(EverydayDetailsViewController.loadEveryday), userInfo: nil, repeats: true)
        
        
        
        //        print("ranStr is \(String.randomStr(len: 7))")
        //        create999Details()
    }
    
    
    
    //创建随机数据
    public  func create999Details(){
        
        for _ in 0...400{
            let randomName = String.randomStr(len: 8)
            let randomPrice = 999.arc4random+1
            
            // using current date and time as an example
            let someDate = Date()
            // convert Date to TimeInterval (typealias for Double)
            let timeInterval = someDate.timeIntervalSince1970
            // convert to Integer
            let myInt = Int(timeInterval)
            
            let randomDataInt = 60000000.arc4random+1
            let randomData = Date(timeIntervalSince1970: Double(myInt-randomDataInt))
            
            DetailsDao().saveDao(randomName,Double(randomPrice), randomData,String.randomKind(),"clothes.png")
        }
    }
    
    
    func createRealDate(){
        
        for _ in 1...150{
            let ran = StringUtil().randomData()
            let randomName = ran.name
            let randomPrice = ran.price
            let kind  = ran.kind
            
            // using current date and time as an example
            let someDate = Date()
            // convert Date to TimeInterval (typealias for Double)
            let timeInterval = someDate.timeIntervalSince1970
            // convert to Integer
            let myInt = Int(timeInterval)
            
            let randomDataInt = 20000000.arc4random+1
            let randomData = Date(timeIntervalSince1970: Double(myInt-randomDataInt))
            
            DetailsDao().saveDao(randomName,Double(randomPrice), randomData,kind,"others.png")
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setRoundBtn(_ view:UIView){
        view.layer.cornerRadius = view.frame.size.height/2
        view.layer.masksToBounds = true
    }
    
    
    
    //
    //收入支出按钮选中样式提醒
    //
    @IBAction func chosen(_ sender: UIButton) {
        switch sender.tag {
        case 1000://收入按钮
            tipBar.backgroundColor = #colorLiteral(red: 0.9971700311, green: 0.7983285785, blue: 0.1761142612, alpha: 1)
            tipBar2.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        case 1001://支出按钮
            tipBar.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            tipBar2.backgroundColor = #colorLiteral(red: 0.9971700311, green: 0.7983285785, blue: 0.1761142612, alpha: 1)
        default:
            break
        }
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initIcon()
        initBtn()
        initInputArea(false)
        
        // Do any additional setup after loading the view.
    }
    
    
    ////    NSCode方法传递数据
    //        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //            if (segue.identifier == "sendDataBackSegue"){
    //                let EverydayDetailsVC  = segue.destination as! EverydayDetailsViewController
    //                EverydayDetailsVC.tempDetailsData.name = "ceshi"
    //                EverydayDetailsVC.tempDetailsData.price = !
    //
    //                EverydayDetailsVC.everydayDetails = tempDetailsDataArray2
    
    //            print("input Text is \(inputNameTextFd.text!)")
    
    //            }
    //        }
    //
    //
    
    
}


extension Int{
    var arc4random :Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        }else if self < 0{
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
    
}
