//
//  extFont.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/3.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension UIFont {
    class func appFontSize(_ nSize:CGFloat,bBold:Bool = false)->UIFont{
        var  strFontName = "PingFangSC-Regular"
        if bBold {
            strFontName = "PingFangSC-Medium"
        }
        return UIFont.init(name: strFontName, size: nSize)!
    }
    class func appFont(_ nFontSize:CGFloat,type:Int)->UIFont{
        var  strFontName = "PingFangSC-Regular"
        switch type {
        case 1:
            //汉字
            strFontName = "PingFangSC-Medium"
        case 2:
            //数字和英文
            strFontName = "Helvetica"
        case 3:
            //数字和英文
            strFontName = "Helvetica-Bold"
        default:
            //汉字
            strFontName = "PingFangSC-Regular"
        }
        return UIFont.init(name: strFontName, size: nFontSize) ?? UIFont.systemFont(ofSize:nFontSize)
    }
}
