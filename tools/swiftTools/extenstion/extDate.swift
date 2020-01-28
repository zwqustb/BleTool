//
//  extDate.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/7/14.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension Date {
    func toString(_ strFormat:String) -> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = strFormat
        return dformatter.string(from: self)
    }
    func getMorningDate() -> Date{
        let calendar = NSCalendar.current
        let components = calendar.dateComponents([.year,.month,.day], from: self)
        return (calendar.date(from: components))!
    }
    func getHour()->Int{
        return Calendar.current.component(.hour, from: self)
    }
    func getMinute() -> Int {
        return Calendar.current.component(.minute, from: self)
    }
    func getHourStr()->String{
        let nHour = self.getHour()
        var strHour = "\(nHour)"
        if nHour < 10{
            strHour = "0\(nHour)"
        }
        return strHour
    }
    func getMinuteStr() -> String {
        let nMinute = self.getMinute()
        var strMinute = "\(nMinute)"
        if nMinute < 10 {
            strMinute = "0\(nMinute)"
        }
        return strMinute
    }
    
    
}
