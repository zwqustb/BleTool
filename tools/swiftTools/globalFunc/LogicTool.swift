//
//  LogicTool.swift
//  biniu
//
//  Created by zhangwenqiang on 2018/4/6.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//项目相关

import UIKit
@objcMembers
class LogicTool: NSObject {
    static let `default` = LogicTool()
    var m_curIndex = 0
    @objc class  func enableBtn(_ sender:UIButton){
        sender.isEnabled = true
    }
    class func handleHttpResult(_ pAny:Any)->NSDictionary{
        var pDic = NSDictionary.init()
        if pAny is NSDictionary {
             pDic = pAny as! NSDictionary
        }
        return pDic as NSDictionary
    }
    @objc class func getUserId()->String{
        let  strUserID = LogicTool.getUserInfo("userId")
        if StringTool.isBlank(strUserID){
            return "0"
        }
        return strUserID
    }
    class func getUserInfo(_ kString:String)->String{
        let pDic = UserDefaults.standard.object(forKey:"userData") as? NSDictionary ?? ["":""]
        let strUserID = pDic.getStr(kString)
        //UserDefaults.standard.string(forKey: "currentId") ?? ""
        return strUserID
    }
    class func getUserGender()->String?{
        let nSavedGender = LogicTool.getUserInfo("gender")
        var strGender:String? = nil
        if nSavedGender == "1"{
            strGender = "男"
        }else if nSavedGender == "2"{
            strGender = "女"
        }
        return strGender
    }
    class func getMemberId()->String{
        return LogicTool.getUserInfo("memberId")
    }
    class func getWeChatName()->String{
        let strUserName = UserDefaults.standard.object(forKey:"kWeChatName") as? String ?? ""
        //UserDefaults.standard.string(forKey: "currentId") ?? ""
        return strUserName
    }
    
    class func getAuthorString(_ dicAuthor:NSDictionary?)->String{
        let strAuthorName = dicAuthor?["name"] as? String ?? ""
        let strAuthorOfficial = dicAuthor?["official"] as? String ?? ""
        return "\(strAuthorName)·\(strAuthorOfficial)"
    }
    // aryCondition [最低值,正常低,正常高,最高值] 长度均分
    // 每个范围之间有像素为2的间距
    func getMearsurePos(_ aryCondition:[CGFloat],_ curValue:CGFloat,_ barLength:CGFloat)->CGFloat{
        let barNap = CGFloat(2.0)
        if aryCondition.count < 4{
            return 0
        }
        if curValue <= aryCondition[0]{
            m_curIndex = 0
            return 0
        }
        if curValue >= aryCondition.last! {
            m_curIndex = aryCondition.count - 1
            return barLength
        }
        let barCount = CGFloat(aryCondition.count-1)
        let fAvelength = (barLength - barNap*(barCount-1))/CGFloat(barCount)
        for (index , item) in aryCondition.enumerated()
        {
            let Item2 = aryCondition[index+1]
            // UI让每个平均值之间的空白间距为2
            if curValue >= item && curValue <= Item2{
                m_curIndex = index //根据位置改变文字颜色
                let overedLength = (fAvelength + barNap) * CGFloat(index)
                var fRet = overedLength + fAvelength*(curValue-item)/(Item2 - item)
                if fRet > barLength{
                    fRet = barLength
                }
                return fRet
            }
            // print("下标\(index) 值为\(item)")
        }
        return 0
    }
    func getPosColor()->UIColor{
        var aryColorStr = ["FFB166","88DB80","F78E75"]
        if aryColorStr.count>m_curIndex {
            let strColor = aryColorStr[m_curIndex]
            return UIColor.string(strColor)
        }
        return UIColor.black
    }
    //获取音视频标记
    class func getMediaType(_ pDic:NSDictionary)->String{
        //1 是视频 2 音频
        var strType = "audio"
        let nType = pDic["type"] as? NSNumber ?? 0
        if nType == 1 {
            strType = "video"
        }
        return strType
    }
    //添加积分
    class func addBonusPoint(_ dicParam:[String:Any]){
        let dicM = NSMutableDictionary.init(dictionary: dicParam)
        dicM["userId"] = LogicTool.getUserId()
        HttpTools.post("mhealth-api/point/record/add", dicM as! [String : Any]) { (bRet, dicRet) in
            if bRet{
                print("积分添加成功\(dicM)")
            }else{
                print("积分添加失败\(dicM),原因\(dicRet)")
            }
        }
    }
    @objc class func isLogin()->Bool{
        let userID = LogicTool.getUserId()
        if userID == "" || userID == "0"{
            return false
        }else{
            return true
        }
    }
    
    class func userIsComplete() -> String {
        let dict : NSDictionary = UserDefaults.standard.object(forKey: "userData") as! NSDictionary
        return dict.getStr("isComplete")
        
    }
    //从服务器获取用户的信息
    class func getUserToken()->String{
        let dict : NSDictionary = UserDefaults.standard.object(forKey: "userData") as? NSDictionary ?? ["":""]
        let ut = dict.getStr("ut")
        return ut
    }
    class func getSystemToken()->String{
        let strST = BOENetWorkTools.sharedManager()?.getStaticToken() ?? ""
        return strST
    }
    //为UIWebView的url添加ut和st
    class func addTokenForUrl(_ strUrl:String)->String{
        let strUT = LogicTool.getUserToken()
        let strST = BOENetWorkTools.sharedManager()?.getStaticToken() ?? ""
       // let strUT = "wrongUT"
        let bParamAdded = strUrl.contains("?")
        if bParamAdded{
            return "\(strUrl)&ut=\(strUT)&st=\(strST)"
        }else{
            return "\(strUrl)?ut=\(strUT)&st=\(strST)"
        }
        
    }
}
