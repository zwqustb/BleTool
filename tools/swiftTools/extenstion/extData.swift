//
//  extData.swift
//  MobileHealth
//
//  Created by zhangwenqiang on 2018/7/9.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit

extension Data {
     func strValue()->String{
        let ret = String.init(data: self, encoding: String.Encoding.utf8)
        return ret!
    }
    func intValue()->String{
       // var num: Int = 0
        var values = [UInt8](repeating:0, count:self.count)
        self.copyBytes(to: &values, count: self.count)
//        self.getBytes( &num , length: MemoryLayout<Int>.size)
        //self.copyBytes(to: &UInt8(num), count: MemoryLayout<Int>.size)
        let str = NSMutableString.init(string: "")
        for i in 0..<values.count {
            str.append(String(values[i]))
        }
        return str as String
    }
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
    ///Data转String
    func hexString() -> String {
        return self.withUnsafeBytes({ (bytes: UnsafePointer<UInt8>) -> String in
            let buffer = UnsafeBufferPointer(start: bytes, count: self.count)
            return buffer.map{String(format: "%02hhx", $0)}.reduce("", {$0 + $1})
        })
    }
    
}
