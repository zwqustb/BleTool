//
//  extTable.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/7/14.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension UITableView {
    func showNoDataTips(_ pTip:String,
                        nCount:Int,
                        style:UITableViewCell.SeparatorStyle = .singleLine) {
        for pView:UIView in self.subviews{
            if(pView.tag == 110 ){
                if nCount == 0{
                    return
                }else{
                    pView.removeFromSuperview()
                }
            }
        }
        if nCount == 0 {
            if pTip == ""{
                let pView = UIImageView.init(frame: self.bounds)
                pView.image = UIImage.init(named: "noData")
                pView.contentMode = .scaleAspectFit
                let kWidth = CGFloat(246)
                pView.frame = CGRect.init(x:(KScreenWidth - kWidth)/2, y: 130, width: kWidth, height: 181)
                pView.tag = 110
                self.addSubview(pView)
            }else{
                let pLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 280, height: 80))
                pLabel.numberOfLines = 0
                pLabel.text = pTip
                pLabel.font = UIFont.init(name: "苹方-简 常规体", size: 14)
                pLabel.textColor = UIColor.appLightBlackColor()
                pLabel.backgroundColor = UIColor.clear
                pLabel.textAlignment = .center
                pLabel.center = CGPoint.init(x: KScreenWidth/2, y: self.center.y)
                pLabel.tag = 110
                self.addSubview(pLabel)
            }
            self.separatorStyle = .none
        }else{
            self.separatorStyle = style
        }
        
    }
}
