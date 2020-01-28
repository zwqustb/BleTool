//
//  ServerTools.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/15.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

class ServerTools: NSObject {
    class func getStr(_ pDic:NSDictionary?,_ pKey:String)->String{
        let pValue = pDic?[pKey]
        if pValue is String {
            return pValue as! String
        }else if pValue is NSNumber{
            let num = pValue as!NSNumber
            return "\(num)"
        }
        return ""
    }
    class func getInt(_ pDic:NSDictionary?,_ pKey:String)->Int{
        let pValue = pDic?[pKey]
        if pValue is String {
            return Int(pValue as! String) ?? -1
        }else if pValue is NSNumber{
            let num = pValue as!NSNumber
            return num.intValue
        }
        return -1
    }
    
}
