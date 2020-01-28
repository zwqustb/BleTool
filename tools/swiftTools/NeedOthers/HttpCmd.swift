//
//  HttpCmd.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/6/25.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
func getServerUrl()->String{
    return BOENetWorkTools.sharedManager()?.getServerUrl() ?? "https://ssc.boe.com/"
}
func isTestApp()->Bool{
    return BOENetWorkTools.sharedManager()?.isTestApp() ?? false
}
func isTestServer()->Bool{
    return BOENetWorkTools.sharedManager()?.isTestServer() ?? false
}
class HttpCmd: NSObject {
//  static var cmdGetVideoList = "video-console/video/pageList"
    static var cmdGetVideoList = "video-api/video/list"
    static var cmdGetLikeVideo = "video-api/praise/add"
  
}
