//
//  extColor.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/3.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
@objc extension UIColor{
    // string2color
    static func string(_ colorStr:String) -> UIColor {
        
        var color = UIColor.red
        var cStr : String = colorStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cStr.hasPrefix("#") {
            // let index = cStr.index(after: cStr.startIndex)
            cStr = cStr.substring(from: 1)
        }
        if cStr.count != 6 {
            return UIColor.black
        }
        
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)
        let rStr = String(cStr[rRange])
        
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)
        let gStr = String(cStr[gRange])
        
        // let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)
        let bStr = cStr.substring(from: 4)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rStr).scanHexInt32(&r)
        Scanner(string: gStr).scanHexInt32(&g)
        Scanner(string: bStr).scanHexInt32(&b)
        
        color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
        
        return color
    }
    //公用
    @objc class func appBlackColor()->UIColor{
        return UIColor.string("333E43")
    }
    @objc class func appLightBlackColor()->UIColor{
        return UIColor.string("989D9F")
    }
    @objc class func appBlueColor()->UIColor{
        return UIColor.string("33B7F5")
    }
    //背景色
    @objc class func appLightWhite()->UIColor{
        return UIColor.string("F7F9FA")
    }
    class func appLineColor()->UIColor{
        return UIColor.string("EAEDEE")
    }
    class func appNavBlue()->UIColor{
        return UIColor.string("0AA8F2")
    }
    class func appUnableBlue()->UIColor{
        return UIColor.string("B4E1F8")
    }
    class func appEnableBlue()->UIColor{
        return UIColor.string("5EB7F0")
    }
    //字体色
    class func appTextUnable()->UIColor{
        return UIColor.string("CBD0D2")
    }
    class func appTextYellow()->UIColor{
        return UIColor.string("F3A237")
    }
    class func appTextGreen()->UIColor{
        return UIColor.string("21D45F")
    }
    class func appTextBlank()->UIColor{
        return UIColor.string("404040")
    }
    class func appTextBlue()->UIColor{
        return UIColor.string("1C9FDC")
    }
    class func appFontLightBlack()->UIColor{
        return UIColor.string("666C6F")
    }
    class func appBufferWhite()->UIColor{
        return UIColor.string("BEC5C7")
    }
    //阴影色
    class func appShadow()->UIColor{
        return UIColor.string("AECBD9")
    }
    //健康状态色 分别是[很高,偏高,优秀/很好/正常,一般,偏低]
    class func statusColor(_ nIndex:Int)->UIColor{
        let aryColorStrs = ["F76B59","EEBD46","19DB4C","63E31D","4EC3F9"]
        return UIColor.string(aryColorStrs.getValue(nIndex) ?? "000000" )
    }
}
