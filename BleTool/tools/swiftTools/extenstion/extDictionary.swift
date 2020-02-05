//
//  extDictionary.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/17.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension NSDictionary {
    @objc func getStr(_ pKey:String)->String{
        return getStr(pKey, "")
    }
    @objc func getStr(_ pKey:String,_ defaultValue:String)->String{
        let pValue = self[pKey]
        if pValue is String {
            return pValue as! String
        }else if pValue is NSNumber{
            let num = pValue as!NSNumber
            return "\(num)"
        }
        return defaultValue
    }
    //解决0的时候显示--的方法
    func getNumStr(_ pKey:String,_ defaultValue:String)->String{
        let ret = getStr(pKey, defaultValue)
        if ret == "0"{
            return defaultValue
        }else{
            return ret
        }
    }
    @objc func getInt(_ pKey:String)->Int{
        return self.getInt(pKey, -1)
    }
    @objc func getInt(_ pKey:String,_ nDefault:Int = -1)->Int{
        let pValue = self[pKey]
        if pValue is String {
            let strValue = pValue as! String
            guard let fValue = Float(strValue) else { return nDefault }
            return Int(fValue) 
        }else if pValue is NSNumber{
            let num = pValue as!NSNumber
            return num.intValue
        }
        return nDefault
    }
    @objc func getFloat(_ pKey:String)->CGFloat{
        return getFloatNil(pKey) ?? -1
    }
    func getFloatNil(_ pKey:String)->CGFloat?{
        let pValue = self[pKey]
        if pValue is String {
            let fRet = Float(pValue as! String)
            if fRet == nil{
                return nil
            }else{
                return CGFloat(fRet!)
            }
        }else if pValue is NSNumber{
            let num = pValue as!NSNumber
            return CGFloat(num.floatValue)
        }
        return nil
    }
    @objc func getDouble(_ pKey:String)->Double{
        let pValue = self[pKey]
        if pValue is String {
            return Double(pValue as! String) ?? 0.0
        }else if pValue is NSNumber{
            let num = pValue as!NSNumber
            return num.doubleValue
        }
        return 0.0
    }
}
