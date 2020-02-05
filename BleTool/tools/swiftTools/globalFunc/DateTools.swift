//
//  DateTools.swift
//  YouYiDian
//
//  Created by zhangwenqiang on 2017/12/24.
//  Copyright © 2017年 zhangwenqiang. All rights reserved.
//

import UIKit
@objcMembers
class DateTools: NSObject {
    class func date2String(_ pDate:Date,_ strFormat:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: pDate)
    }
    @objc class func string2Date(_ strDate:String,_ strFormat:String)->Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        var date = DateTools.string2NilableDate(strDate, strFormat)
        if date == nil {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            date = dateFormatter.date(from: strDate)
        }
        if date == nil {
            date = Date.init()
            print("日期转换失败")
        }
        return date!
    }
    class func string2NilableDate(_ strDate:String,_ strFormat:String)->Date?
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        let date = dateFormatter.date(from: strDate)
        return date
    }
    //时间搓转换成日期
    class func IntStr2DateStr(_ intStr:String?,_ strFormat:String)->String{
        if intStr != nil{
            let nStamp = Int(intStr!)
            if nStamp != nil{
                let pDate = DateTools.Int2Date(nStamp!)
                let strDate = pDate.toString(strFormat)
                return strDate
            }
        }
        return ""
    }
    //MARK: 毫秒数转化为时分秒
    class func NumToTimeString(_ nTime:NSNumber )->String{
        let dTime = nTime.doubleValue
        let dSecond = dTime/1000
        var dMin = 0
        if dSecond > 60 {
            dMin = Int(dSecond/60)
         //   dSecond = dSecond % 60
            return "\(dMin)分钟"
        }else{
            return "\(dSecond)秒"
        }
    }
    //保存订单的开始充电时间
    class func saveNow(_ strKey:String){
        let strFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDate = Date.init()
        let strNow = DateTools.date2String(nowDate, strFormat)
        UserDefaults.standard.set(strNow, forKey: strKey)
        UserDefaults.standard.synchronize()
    }
    //通过秒获取时分秒
    class func getHMSFormS(seconds:Int) -> String {
        let nhour = Int(seconds/3600)
        var str_hour = "\(nhour)"
        if nhour<10{str_hour = "0\(nhour)"}
        let strMS = DateTools.getMSFromS(seconds: seconds)
        let format_time = "\(str_hour):\(strMS)"
        return format_time as String
    }
    //通过秒获取分秒
    class func getMSFromS(seconds:Int)->String{
        let nMin = (seconds%3600)/60
        var str_minute = "\(nMin)"
        if nMin<10 {str_minute = "0\(nMin)"}
        let nSec = seconds%60
        var strSec = "\(nSec)"
        if nSec<10 {strSec = "0\(nSec)"}
        return "\(str_minute):\(strSec)"
    }
    class func getOrderTimeDiff(_ strKey:String,_ strEndTime:String)->String{
        let strBgnTime = UserDefaults.standard.string(forKey: strKey)
        if strBgnTime != nil {
            let strDiff = DateTools.getDiffer(strBgnTime!, strEndTime)
            return strDiff
        }
        return "起始时间不存在"
    }
    class func getDiffer(_ strBgnTime:String,_ strEndTime:String)->String{
        let strFormat = "yyyy-MM-dd HH:mm:ss"
        let EndDate = DateTools.string2Date(strEndTime, strFormat)
        let StartDate = DateTools.string2Date(strBgnTime, strFormat)
        let second = EndDate.timeIntervalSince(StartDate)
        let strDiff = DateTools.getHMSFormS(seconds: Int(second))
        return strDiff
    }
    class func Int2Date(_ second:Int)->Date{
        return Date.init(timeIntervalSince1970: TimeInterval(second))
    }
    //日期字符串格式转化,转化失败则返回当前日期的字符串
    class func changeStr(_ str1:String,from:String,to:String)->String{
        let pDate = DateTools.string2NilableDate(str1, from)
        if pDate == nil {
            return str1
        }else{
            let str2 = DateTools.date2String(pDate!, to)
            return str2
        }
        
    }
}
