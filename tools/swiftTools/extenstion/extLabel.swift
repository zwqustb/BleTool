//
//  extLabel.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/7/13.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable var isAppFont:  Int  {
        get {
            return 0
        }
        set {
            let dicFont = self.font.fontDescriptor;
            let fontSize = dicFont.object(forKey: UIFontDescriptor.AttributeName(rawValue: "NSFontSizeAttribute")) as? NSNumber ?? 14.0
            self.font = UIFont.appFont(CGFloat(truncating: fontSize), type: newValue)
        }
    }
}
