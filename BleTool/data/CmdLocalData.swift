//
//  CmdLocalData.swift
//  BleTool
//
//  Created by boeDev on 2019/5/31.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit
let g_strDefaultFileName = "攀高按摩仪"
class CmdLocalData: NSObject {
    static let shareInstence = CmdLocalData.init()
    let aryName = ["设备蓝牙名称",//0
                   "设备唯一标识",
                   "Service_UUID",
                   "Characteristic_UUID_write",
                   "Characteristic_UUID_read",
                   "编码方式",
                   "App设置设备时间",
                   "设备反馈时间设置结果",
                   "App获取设备电量",
                   "设备反馈电量",
                   "App获取设备历史记录",//10
                   "设备反馈一条历史记录",
                   "App发送确认收到",
                   "设备反馈历史数据传完",
                   "app发送开始测量",
                   "设备反馈是否成功开始",
                   "app发送结束测量",
                   "设备反馈是否成功结束",
                   "设备反馈测量结果",
                   "设备反馈测量中数据",
                   "设备反馈错误码",//20
                   "CCCDwrite",
                   "APP发送血压设备握手命令",
                   "设备反馈握手结果"
    ]
    var aryBtn = ["开始搜索",
                   "","","","","",
                   "同步时间",
                   "",
                   "获取电量",
                   "",
                   "获取历史记录",
                   "","","",
                   "开始测量",
                   "",
                   "结束测量",
                   "","","","","","",""]
    let aryBoe = ["Bp_Aal",
                    "标识获取中",
                    "1801",
                    "2801",
                    "2801",
                    "Hex",
                    "010301 06 yyMMddHHmmss ZZ",
                    "010302 01 WW ZZ",
                    "010303 00 ZZ",
                    "010304 03 pp WW ZZ",
                    "010305 00 ZZ",
                    "010306 10 yyMMddHHmmss h1h2llrr ZZ",
                    "010307 00 ZZ",
                    "010308 00 ZZ",
                    "010309 00 ZZ",
                    "010310 01 WW ZZ",
                    "010311 00 ZZ",
                    "010312 01 WW ZZ",
                    "010314 10 yyMMddHHmmss h1h2llrr ZZ",
                    "010316 02 P1P2 ZZ",
                    "010318 01 WW ZZ",
                    "","",""
    ]
    let aryAal = ["Bioland",
                     "标识获取中",
                     "1000",
                     "1001",
                     "1002",
                     "Hex",
                     "","","","",
                     "5A0A 03 yyMMddHHmmss ZZ",//获取历史
                     "550E 03 yyMMddHHmmss h1h2 ll rr ZZ",//收到历史数据
                     "5A05 05 yyMMddHHmmss ZZ",//确认收到数据
                     "5505 05 ZZ ZZ",//收到数据传完
                     "5A0A 01 yyMMddHHmmss ZZ",//开始测量
                     "","","",
                     "550E 03 yyMMddHHmmss h1h2 ll rr ZZ",//收到测量结果数据
                     "5508 02 RR pp P1P2 ZZ",//收到测量中的数据
                     "5505 EE WW ZZ",//收到错误数据
                     "","",""
    ]
    let aryOml = ["9200T,BLEsmart_00000116,U32J,BLEsmart_0000033A",
                  "标识获取中",
                  "1810,1805,180A,180F",//(读数据,写时间,设备信息,电量)
                  "2A35,2A2B,2A19,2A25",//写(血压,时间,电池,设备信息)
                  "2A35,2A2B,2A19,2A25",//读
                  "UInt8",
                  "1805_2A2B_yyyyMMddHHmmssZZZZZ",//写时间 服务UUID_特征UUID_内容
                  "1805_2A2B_yyyyMMddHHmmssZZZZZ",//收到时间
                  "",
                  "1805_2A19_pp",//收到电量百分比
                  "",//获取历史
                  "1810_2A35_ZZ h1h2llllZZZZ yyyyMMddHHmmss rrrr ZZ",//收到历史数据
                  "",//确认收到数据
                  "",//收到数据传完
                  "",//开始测量
                  "","","",
                  "1810_2A35_ZZ h1h2llllZZZZ yyyyMMddHHmmss rrrr ZZ",//收到测量结果数据
                  "",//收到测量中的数据
                  "",//收到错误数据
                  "0200",//客户端特性配置描述符的写入值
                  "",""
    ]
    let aryMbb = ["RBP,BP",
                  "标识获取中",
                  "FFF0",
                  "FFF2",
                  "FFF1",
                  "Hex",
                  "","",
                  "CC80 02 03 040400 ZZ",//获取电量
                  "AA80 LL 04 pp",//收到电量
                  "","","","",//历史记录相关
                  "CC80 02 03 01 02 00 02",//开始测量
                  "",
                  "CC80 02 03 01 03 00 03",//停止测量
                  "",
                  "68 h1h2llllZZZZ yyyy ZZ",//收到测量结果数据
                  "","","",
                  "CC80 02 03 010100 01",//发送握手协议
                  "AA80 02 03 0101WW ZZ"//收到握手协议 00 01
    ]
    func getCurCmdName()->String{
        let strName = UserDefaults.standard.string(forKey: "CmdName") ?? g_strDefaultFileName
        return strName
    }
    func saveCurCmdName(_ strName:String){
        UserDefaults.standard.set(strName, forKey: "CmdName")
        UserDefaults.standard.synchronize()
    }
    func getCmdAryByName(_ strName:String)->[String]{
        switch strName {
        case "京东方":
            return aryBoe
        case "爱奥乐":
            return aryAal
        case "欧姆龙":
            return aryOml
        case "脉搏波":
            return aryMbb
        default:
            var strContent = FileTool.docFileContent(title: strName)
            strContent = strContent?.trimmingCharacters(in: .newlines)
            let aryCurSelect = CurSelectData.shareInstence.aryCurCmd
            if aryCurSelect != nil{
                return aryCurSelect!
            }else if strContent != nil{
                let aryChar = strContent?.split(separator: ",")
                let aryString = NSMutableArray.init()
                aryChar?.forEach({ (pChar) in
                    aryString.add(String(pChar))
                })
                CurSelectData.shareInstence.aryCurCmd = aryString as? [String]
                return CurSelectData.shareInstence.aryCurCmd!
            }
            let ary = NSMutableArray.init()
            var nIndex = 0
            aryBoe.forEach { (str) in
                ary.add("待编辑")
                nIndex += 1
            }
            return ary as! [String]
        }
    }
    func getCmdInfo(_ strName:String)->String{
        let ret = NSMutableString.init(capacity: 100)
        let aryValue = self.getCmdAryByName(strName)
        var index = 1
        aryName.forEach { (strValue) in
            ret.append("\(index)")
            ret.append(".")
            ret.append(strValue)
            ret.append("\n")
            ret.append("->")
            if index > aryValue.count{
                ret.append(aryValue.last ?? "")
            }else{
                ret.append(aryValue[index-1])
            }
            ret.append("\n")
            index += 1
        }
        return ret as String
    }
}
