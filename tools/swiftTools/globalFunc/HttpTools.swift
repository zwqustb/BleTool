//
//  HttpTools.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/7/24.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

class HttpTools: NSObject {
    //MARK:zwqhttp cookie
    class func setCookiePolicy(){
        HttpTools.clearCookies()
        HttpTools.clearCaches()
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookieAcceptPolicy = .never
        URLCache.shared.memoryCapacity = 0
        URLCache.shared.diskCapacity = 0
    }
    class func clearCaches(){
        let cach = URLCache.shared
        cach.removeAllCachedResponses()
    }
    class func clearCookies(){
        let cookieStorage = HTTPCookieStorage.shared
        let cookies = cookieStorage.cookies
        //删除cookie
        if cookies != nil{
            for pCookie in cookies!{
                cookieStorage.deleteCookie(pCookie)
            }
        }
    }
   @objc class func get(_ strCmd:String,_ pDicParam:[String:Any],callBack: @escaping (_ bSuccess:Bool,_ ret:NSDictionary)->())
    {
        _ = DispatchQueue(label: "requestHandler")
        DispatchQueue.global().async {
            var cmd = strCmd
            if pDicParam.count > 0{
                var strParam = ""
                pDicParam.forEach { (key,value) in
                    strParam += "&\(key)=\(value)"
                }
                strParam = strParam.substring(from: 1)
                cmd = "\(strCmd)?\(strParam)"
            }
            let cmdEncode = cmd.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            if cmdEncode == nil {
                return
            }
            
            BOENetWorkTools.sharedManager().getRequest(cmdEncode, parameters: nil, success: { (pAny:Any) in
                let ret = LogicTool.handleHttpResult(pAny)
                let nCode = ret["code"] as? String
                DispatchQueue.main.async {
                    if(nCode == "0"){
                        callBack(true,ret)
                    }else{
                        callBack(false,ret)
                    }
                }
            }) { (error) in
                print("getError:\(error.debugDescription))")
                callBack(false,["error":error ?? "net error"])
            }
        }
        
    }
   @objc class func post(_ strCmd:String,_ pDicParam:[String:Any],callBack: @escaping (_ bSuccess:Bool,_ ret:NSDictionary)->()){
        let queue = DispatchQueue(label: "requestHandler")
        queue.async {
            BOENetWorkTools.sharedManager().postRequest(strCmd, body: pDicParam, parameters: nil, success: { (pData:Any) in
                let ret = LogicTool.handleHttpResult(pData)
                let nCode = ret["code"] as? String
                    if(nCode == "0"){
                        callBack(true,ret)
                    }else{
                        callBack(false,ret)
                    }
            }, failure: { (error:Error?) in
                print("getError:\(error.debugDescription))")
                callBack(false,["error":error ?? "net error"])
            })
        }
        
    }
    //请求第三方服务器
    class func requestThirdServer(_ url:String,_ postType:String,_ dicParams:NSDictionary,callBack: @escaping (_ bSuccess:Bool,_ ret:NSDictionary)->())  {
        if postType == "get" {
            _ = DispatchQueue(label: "requestHandler")
            DispatchQueue.global().async {
                var cmd = url
                var strParam = ""
                dicParams.forEach { (key,value) in
                    strParam += "&\(key)=\(value)"
                }
                strParam = strParam.substring(from: 1)
                cmd = "\(url)?\(strParam)"
                
                let cmdEncode = cmd.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                if cmdEncode == nil {
                    return
                }
                let lastUrl = URL.init(string: cmdEncode!)
                if lastUrl == nil{
                    return
                }
                let htmlString = try?String.init(contentsOf: lastUrl!, encoding: String.Encoding.utf8)
                let dicRet = htmlString?.toJSONDic()
                if dicRet == nil{
                    callBack(false,["":""])
                }else{
                    callBack(true,dicRet!)
                }
                
//                var pRequest = URLRequest.init(url: lastUrl!)
//                 let pDataTask = URLSession.shared.dataTask(with: pRequest, completionHandler: { (pData, pURLResponse, pError) in
//                    if pData == nil{
//                        let ret = LogicTool.handleHttpResult(pData!)
//                        DispatchQueue.main.async {
//                            if(pError == nil){
//                                callBack(true,ret)
//                            }else{
//                                callBack(false,ret)
//                            }
//                        }
//                    }else{
//                        DispatchQueue.main.async {
//                            callBack(false,["error":"data id nil"])
//                        }
//                    }
//                })
//                pDataTask.resume()
            }
        }else if postType == "post" {
            
        }
    }
}
