//
//  AlertTitleView.swift
//  MobileHealth
//
//  Created by boeDev on 2018/10/10.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

class AlertTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.textAlignment = .center
        self.textColor = UIColor.appBlackColor()
        self.font = UIFont.init(name: "PingFangSC-Medium", size: 16)
        
    }
    class func initWith(title :String)->AlertTitleLabel{
        let pLabel = AlertTitleLabel.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 46))
        pLabel.text = title
        return pLabel
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
