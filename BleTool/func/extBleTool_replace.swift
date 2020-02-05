//
//  extBleTool_replace.swift
//  BleTool
//
//  Created by boeDev on 2019/12/31.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit

extension BleTool  {
    //发送字符串,替换年月日.接收到的字符串进行一下文本解析
    func getReplacedStr(_ dicLogic:NSDictionary)->String{
        let strType = dicLogic.getStr("type")
        let dicCmd = m_dicData?["cmd"] as? NSDictionary ?? ["":""]
        var strRet = NSMutableString.init()
        
        let cmdTitle = dicLogic.getStr("content")
        let cmdValue = dicCmd.getStr(cmdTitle)
       
        let aryLocation = dicLogic["location"] as? [String] ?? []
        let aryReplace = dicLogic["title"] as? [String] ?? []
        switch strType {
        case "send":
            strRet = NSMutableString.init(string: cmdValue)
            aryLocation.forEach({ (strLoc) in
                let aryLoc = strLoc.split(separator: "~")
                if aryLoc.count == 2{
                    let nBgn = Int(aryLoc.first!) ?? 0
                    let nEnd = Int(aryLoc.last!) ?? 0
                    let index = aryLocation.firstIndex(of: strLoc) ?? 0
                    if aryReplace.count > index{
                        let titleValue = aryReplace[index]
                        let strReplace = getRealValueByTitle(titleValue)
                        let pRange = NSMakeRange(nBgn, nEnd - nBgn)
                        strRet.replaceCharacters(in: pRange, with: strReplace)
                    }
                }
            })
            break
        case "readData":
//            strRet = NSMutableString.init(string: cmdValue)
            aryLocation.forEach({ (strLoc) in
                let aryLoc = strLoc.split(separator: "~")
                if aryLoc.count == 2{
                    let nBgn = Int(aryLoc.first!) ?? 0
                    let nEnd = Int(aryLoc.last!) ?? 0
                    let index = aryLocation.firstIndex(of: strLoc) ?? 0
                    if aryReplace.count > index{
                        let titleValue = aryReplace[index]
                        let strReceived = m_strReceivedStr as String
                        var strData = strReceived.substring(from: nBgn-1, length: nEnd - nBgn + 1)
                        if titleValue.hasSuffix("ascii"){
                           strData = strData.hex2Ascii()
                        }else if titleValue.hasSuffix("int"){
                            strData = String(strData.hex2Decimal())
                        }else if titleValue.hasSuffix("little"){
                           let strData1 = strData.substring(to: 2)
                           let strData2 = strData.substring(from: 3)
                           strData = String(strData1.hex2Decimal() + strData2.hex2Decimal()*256)
                        }else if titleValue.hasSuffix("big"){
                            let strData1 = strData.substring(to: 2)
                            let strData2 = strData.substring(from: 3)
                            strData = String(strData1.hex2Decimal()*256 + strData2.hex2Decimal())
                        }
                        strRet.append("\(titleValue):\(strData);")
                    }
                }
            })
            break
        default:
            break
        }
        return strRet as String
    }
    func getRealValueByTitle(_ strTitle:String) -> String {
        var strRet = "--"
        let pDate = Date.init()
        switch strTitle {
        case "年年":
            strRet = pDate.toString("yyyy")
        case "年":
            strRet = pDate.toString("yy")
        case "月":
            strRet = pDate.toString("MM")
        case "日":
            strRet = pDate.toString("dd")
        case "时":
            strRet = pDate.toString("hh")
        case "分":
            strRet = pDate.toString("mm")
        case "秒":
            strRet = pDate.toString("ss")
        default:
            break
        }
        return strRet
    }
    func replacePlaceholder(_ strOrignal:String)->String{
        var strRet = strOrignal
        if strOrignal.contains("yyMMddHHmmss") {
            let strDate = Date.init().toString("yyMMddHHmmss")
            strRet = strOrignal.replacingOccurrences(of: "yyMMddHHmmss", with: strDate)
        }
        return strRet
    }
}
