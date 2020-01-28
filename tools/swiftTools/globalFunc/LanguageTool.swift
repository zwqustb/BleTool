//
//  LanguageTool.swift
//  MobileHealth
//
//  Created by boeDev on 2018/12/27.
//  Copyright © 2018 Jiankun Zhang. All rights reserved.
//

import UIKit

class LanguageTool: NSObject {
    class func getVC(_ strTargetVC: String,_ xibName:String? = nil,bShow:Bool = true) -> UIViewController? {
        let str = "MobileHealth.\(strTargetVC)"
        guard let newClassType = NSClassFromString(str) as? UIViewController.Type else {
            print("不存在\(str)这个类")
            return nil
        }
        // let vc = newClassType.init()
        var pVC = newClassType.init()
        if xibName != ""{
            pVC = newClassType.init(nibName: xibName, bundle: nil)
        }
        //pushView(pVC)
        return pVC;
    }
    class func jsonToDictionary(_ strJson:String)->NSDictionary{
        let data = strJson.data(using: .utf8)
        if data == nil {
            return ["":""]
        }
        let dicRet = try?JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
        return dicRet as? NSDictionary ?? ["":""]
    }
}
