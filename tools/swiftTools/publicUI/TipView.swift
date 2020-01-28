//
//  TipView.swift
//  MobileHealth
//
//  Created by boeDev on 2018/10/10.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

class TipView: UIView {
    var m_lTitle = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 46))
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 6
        self.clipsToBounds = true
    }
    class func initWith(title :String,content:String) -> TipView {
        let pTipView = TipView.init(frame: CGRect.init(x: 0, y: 0, width: 300, height: 161))
        let pTitleView = AlertTitleLabel.initWith(title: title)
        let pLineView = UIView.init(frame: CGRect.init(x: 0, y: 46, width: 300, height: 2))
        pLineView.backgroundColor = UIColor.appLineColor()
        let pContentView = UITextView.init(frame: CGRect.init(x: 23, y: 58, width: 254, height: 81))
        pContentView.isSelectable = false
        pContentView.isEditable = false
        pContentView.text = content
        pContentView.textColor = UIColor.appFontLightBlack()
        pContentView.font = UIFont.init(name: "PingFangSC-Regular", size: 14)
        pTipView.addSubview(pTitleView)
        pTipView.addSubview(pLineView)
        pTipView.addSubview(pContentView)
        return pTipView
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
