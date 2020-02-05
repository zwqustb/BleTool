//
//  AnimationTool.swift
//  MobileHealth
//
//  Created by boeDev on 2019/3/20.
//  Copyright © 2019 Jiankun Zhang. All rights reserved.
//

import UIKit

class AnimationTool: NSObject,CAAnimationDelegate {
    static let shareInstence = AnimationTool.init()
    var m_pView:UIView? = nil
    var m_shapeLayer:CAShapeLayer?
    //reserve 相反的 参考DoitPushAnimator
    class func viewDisappearToPoint(view:UIView,_ point:CGPoint,_ reserve:Bool = false){
        AnimationTool.shareInstence.m_pView = view
//        let ani = CABasicAnimation.init(keyPath: "transform")
//        ani.fromValue =
        
        
        let center = point
        let path1 = UIBezierPath.init(arcCenter: center, radius: 0, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        let shapeLayer = CAShapeLayer.init()
        shapeLayer.path = path1.cgPath
        let h = view.frame.height
        let radius2 = sqrt(pow(h - center.x, 2) + pow(h - center.y, 2))
        let path2 = UIBezierPath.init(arcCenter: center, radius: radius2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        let animation = CABasicAnimation.init(keyPath: "path")
        AnimationTool.shareInstence.m_shapeLayer = shapeLayer
        if (reserve){
            //点到view push
            animation.fromValue =  path1.cgPath
            animation.toValue = path2.cgPath
            //view.mask = shapeLayer
            view.layer.mask = shapeLayer
        }else{
            //view到点
            animation.fromValue =  path2.cgPath
            animation.toValue = path1.cgPath
            view.layer.mask = shapeLayer
        }
        animation.duration = 0.8
        animation.delegate = AnimationTool.shareInstence
        animation.isRemovedOnCompletion = true
        animation.fillMode = CAMediaTimingFillMode.forwards

        animation.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
        shapeLayer.add(animation, forKey: "pushAnimation")
//        view.layer.add(animation, forKey: "myScale")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        m_pView?.removeFromSuperview()
    }
}
