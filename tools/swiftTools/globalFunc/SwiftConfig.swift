//
//  SwiftConfig.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/7/10.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

#if DEBUG
//let kTesting = false
let kTesting = true
#else
let kTesting = false
#endif
let kBleSDK = false

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}
