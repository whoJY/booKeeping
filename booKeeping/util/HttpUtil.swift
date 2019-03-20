//
//  HttpUtil.swift
//  booKeeping
//
//  Created by hujinyu on 2019/3/13.
//  Copyright © 2019 hujinyu. All rights reserved.
//

import Foundation
import SWXMLHash
class HttpUtil{
    
    func GET(_ urlStr:String)
        
    {
        //对请求路径的说明
        //http://120.25.226.186:32812/login?username=520it&pwd=520&type=JSON
        //协议头+主机地址+接口名称+？+参数1&参数2&参数3
        //协议头(http://)+主机地址(120.25.226.186:32812)+接口名称(login)+？+参数1(username=520it)&参数2(pwd=520)&参数3(type=JSON)
        //GET请求，直接把请求参数跟在URL的后面以？隔开，多个参数之间以&符号拼接
        //1.确定请求路径
        let url: NSURL = NSURL(string: urlStr)!
        //    let url: NSURL = NSURL(string: "http://129.204.12.94:3000/user?name=hujinyuiPhone&url=www.hujinyu.com")!
        //2.创建请求对象
        //请求对象内部默认已经包含了请求头和请求方法（GET）
        let request: NSURLRequest = NSURLRequest(url: url as URL)
        //3.获得会话对象
        let session: URLSession = URLSession.shared
        //4.根据会话对象创建一个Task(发送请求）
        /*
         第一个参数：请求对象
         第二个参数：completionHandler回调（请求完成【成功|失败】的回调）
         data：响应体信息（期望的数据）
         response：响应头信息，主要是对服务器端的描述
         error：错误信息，如果请求失败，则error有值
         */
        let dataTask: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if(error == nil){
                //6.解析服务器返回的数据
                //说明：（此处返回的数据是JSON格式的，因此使用NSJSONSerialization进行反序列化处理）
                var dict:NSDictionary? = nil
                do {
                    dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as! NSDictionary
                    
                } catch {
                    
                }
                print("%@",dict)
                
            }
            
        }
        
        //5.执行任务
        dataTask.resume()
        
    }
    
    //通用头
    let soapHead = "<?xml version=\"1.0\" encoding=\"utf-8\"?>" +
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">" +
    "<soap:Body>"
    //通用尾部
    let soapEnd = "</soap:Body>" +
    "</soap:Envelope>\n"
    
    //测试拼接
    let soapMsg2  = "<say xmlns=\"http://tempuri.org/\">" + "<name>"
    let soapMsg3 = "</name>"+"</say>"
   
    //请求验证码拼接
    let smsSoapMsg1 = "<askValidate xmlns=\"http://tempuri.org/\">" + "<phoneNumber>"
    let smsSoapMsg2 = "</phoneNumber>" + "</askValidate>"
    
    //验证验证码拼接
    let valiSoapMsg1 = "<validataCode xmlns=\"http://tempuri.org/\">" + "<tel>"
    let valiSoapMsg2 = "</tel>"+"<code>"
    let valiSoapMsg3 = "</code>"+"</validataCode>"
    
    //设置密码拼接
    let setUserPwdSoapMsg1 = "<setUserPwd xmlns=\"http://tempuri.org/\">" + "<tel>"
    let setUserPwdSoapMsg2 = "</tel>"+"<pwd>"
    let setUserPwdSoapMsg3 = "</pwd>"+"</setUserPwd>"
    
    
    //上传图片
    let imgSoapMsg1 = "<uploadImg xmlns=\"http://tempuri.org/\">" + "<base64>"
    let imgSoapMsg2 = "</base64>" + "</uploadImg>"
    
    
    //测试服务url
    let url = "http://129.204.12.94:8080/helloservice/services/HelloService"
    //发送短信服务url
    let smsUrl = "http://129.204.12.94:8080/bookeepingWebService/services/SMS"
    //ConsumptionService服务url
    let ConsumptionUrl = "http://129.204.12.94:8080/bookeepingWebService/services/ConsumptionService"
    //上传img url
    let imgUrl = "http://129.204.12.94:8080/bookeepingWebService/services/ImgUpload"
    
    
    func askWebService(_ whichService:String,_ para1:String,_ para2_optional:String)->String{
        print("service is \(whichService)")
        switch whichService {
        case "askValidate":
            let soapMsg = soapHead+smsSoapMsg1+para1+smsSoapMsg2+soapEnd
            return HttpPostViaWS(soapMsg, url: smsUrl)
        case "validataCode":
            let soapMsg = soapHead+valiSoapMsg1+para1+valiSoapMsg2+para2_optional+valiSoapMsg3+soapEnd
             return HttpPostViaWS(soapMsg, url: smsUrl)
        case "setUserPwd":
            let soapMsg = soapHead+setUserPwdSoapMsg1+para1+setUserPwdSoapMsg2+para2_optional+setUserPwdSoapMsg3+soapEnd
            return HttpPostViaWS(soapMsg, url: smsUrl)
        case "uploadImg":
            let soapMsg = soapHead+imgSoapMsg1+para1+imgSoapMsg2+soapEnd
            return HttpPostViaWS(soapMsg, url: imgUrl)
            
        default:
            break
        }
        return "error"
    }
    
    
    public   func  testHtpp(str:String){
        let soapMsg = soapHead+imgSoapMsg1+str+imgSoapMsg2+soapEnd
         HttpPostViaWS(soapMsg, url: imgUrl)
    }
    
    
    static var doneHttp = false
    static var httpResult = ""
    
    //通过webservice 交互数据
   private func HttpPostViaWS(_ soapMsg:String,url:String)->String{
        
        let request = NSMutableURLRequest(url:NSURL(string: url)! as URL)
        let msgLength = String(soapMsg.characters.count)
        request.httpMethod = "POST"
        request.httpBody = soapMsg.data(using: String.Encoding.utf8, allowLossyConversion: false)
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(msgLength, forHTTPHeaderField:"Content-Length")
        request.addValue("say", forHTTPHeaderField: "SOAPAction")
        let session = URLSession.shared
        //(3) 发送请求
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
//            print("data is \(String(describing: data!))\n,response is \(String(describing: response))\n,error is \(String(describing: error))\n")
            if let e = error {
                print("ERROR:----------------\(e)")
            }
            //将返回结果转为String
            let res = NSString(data:data! ,encoding: String.Encoding.utf8.rawValue)! as String
//            print("res is \(res)")
//            print("result from server is \(self.parseResult(xmlStr: res))")
//            HttpUtil.httpResult = self.parseResult(xmlStr: res)
            HttpUtil.doneHttp = true
        })
        task.resume()
        
        print("等待网络操作...")
        //等待http执行结束
        while(!HttpUtil.doneHttp){
//            print("...")
        }
    print("网络操作完成.")
        HttpUtil.doneHttp = false //还原标志位
    HttpUtil.httpResult = "11"
        return HttpUtil.httpResult
    }
    
    
    
    //在服务器端设置标志位，然后根据标志位移除无关信息
    func parseResult(xmlStr:String)->String{
        var res2 = xmlStr.components(separatedBy: "FLAG")
        return res2[1]
    }
    
    /*  创建Post请求 */
    func PostRequest(data:String,str1:String)
    {
        //(1）设置请求路径
        let url:NSURL = NSURL(string:"http://129.204.12.94:8080/helloservice/services/HelloService?name=hujinyu")!//不需要传递参数
        //(2) 创建请求对象
        let request:NSMutableURLRequest = NSMutableURLRequest(url: url as URL) //默认为get请求
        //        request.Headers.Add( "SOAPAction", "say" );
        //        request.addValue("SOAPAction", "say" )
        request.timeoutInterval = 5.0 //设置请求超时为5秒
        request.httpMethod = "POST"  //设置请求方法
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        //设置请求体
        
        //把拼接后的字符串转换为data，设置请求体
        print(data)
        request.httpBody = data.data(using: .utf8)
        let session = URLSession.shared
        //(3) 发送请求
        let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            print("what is this")
            
            var dict:NSDictionary? = nil
            do {
                dict  = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.init(rawValue: 0)) as? NSDictionary
            } catch {
                
            }
            print("dict is \(dict)")
            
        })
        task.resume()
    }
    
    
}


