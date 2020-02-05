//
//  MaskView.swift
//  MobileHealth
//
//  Created by boeDev on 2018/9/25.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
@objc protocol MaskViewDelegate:NSObjectProtocol {
    func MaskHiddenChangedTo(_ bHidden:Bool)
}
class MaskView: UIView {
    weak var delegate:MaskViewDelegate?
   @objc  var m_pLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 250, height: 60))
    var bHiddenWhenClickBg = true
    var bRemoveWhenHidden = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.55)
        m_pLabel.textAlignment = .center
        m_pLabel.backgroundColor = UIColor.white
        m_pLabel.center = self.center
        m_pLabel.isAppFont = 1
        m_pLabel.textColor = UIColor.appBlackColor()
        m_pLabel.font = UIFont.init(name:"PingFangSC-Regular", size:16)
        m_pLabel.numberOfLines = 0
        m_pLabel.layer.cornerRadius = 6
        m_pLabel.clipsToBounds = true
        let pBtn = UIButton.init(frame: self.bounds)
        pBtn.addTarget(self, action: #selector(clickView), for: .touchUpInside)
        self.addSubview(m_pLabel)
        self.addSubview(pBtn)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //fatalError("init(coder:) has not been implemented")
    }
    @objc func clickView(){
        if bHiddenWhenClickBg {
            self.isHidden = true
            delegate?.MaskHiddenChangedTo(true)
            if bRemoveWhenHidden {
                self.removeFromSuperview()
            }
        }
    }
    class func showTips(title:String?,content:String,on pSuperView:UIView)->MaskView{
        let pTitle = title ?? "小贴士"
        let pMask = MaskView.init(frame: CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        pMask.bRemoveWhenHidden = true
        let pSubView = TipView.initWith(title: pTitle, content: content)
        pMask.addSubview(pSubView)
        pSuperView.addSubview(pMask)
        pSubView.center = pMask.center
        return pMask
    }
    class func showSelectView(title:String,aryOption:NSArray,on pSuperView:UIView,delegate:SelectViewDelegate,defaultSelectIndex:Int)->MaskView{
        let pMask = MaskView.init(frame: CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight))
        pMask.bRemoveWhenHidden = true
        let pSubView = SelectView.initWith(title: title, aryOption: aryOption as! [String],delegate: delegate,defaultSelectIndex: defaultSelectIndex)
        pMask.addSubview(pSubView)
        pSuperView.addSubview(pMask)
        pSubView.center = pMask.center
        return pMask
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
