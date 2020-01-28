//
//  extBleTool.swift
//  BleTool
//
//  Created by boeDev on 2019/11/21.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit

extension BleTool {
    func getDicLogic()->NSDictionary{
        let dicLogic = m_dicData?["logic"] as? NSDictionary ?? ["":""]
        return dicLogic
    }
    func getCurDicLine()->NSDictionary{
        let dicLogic = getDicLogic()
        let str = curLogicLine
        let dicCurLine = dicLogic[str] as? NSDictionary ?? ["":""]
        return dicCurLine
    }
    //strNextType是okNext或者onThen
    func getNextLogicNameBy(_ strNextType:String,_ strCmdContent:String)->String{
        if strNextType != "okNext" && strNextType != "noThen" {
            return strNextType
        }
        let dicCurLine = getCurDicLine()
        let pLineContent = dicCurLine[strNextType]
        if pLineContent is String {
            let strRet = pLineContent as! String
            return strRet
        }else if pLineContent is [String]{
            let aryContent =  pLineContent as! [String]
            var aryKeys = dicCurLine["ok"] as? [String] ?? []
            if strNextType == "onThen"{
                aryKeys = dicCurLine["no"] as? [String] ?? []
            }
            let dicCmd = m_dicData?["cmd"] as? NSDictionary ?? ["":""]
            var indexNextLogic:Int?
            aryKeys.forEach { (pKey) in
                let cmdContent = dicCmd[pKey] as? String ?? ""
                if strCmdContent == cmdContent{
                    indexNextLogic = aryKeys.firstIndex(of: pKey)
                }
            }
            if indexNextLogic != nil {
                let strRet = aryContent[indexNextLogic!]
                return strRet
            }
        }
        return ""
    }
    //对象工具方法
    func addLog(_ strLog:String){
        m_pTestVC?.addLog(strLog)
    }
    func addSendLog(_ strLog:String){
          m_pTestVC?.addSendLog(strLog)
      }
    func addReceiveLog(_ strLog:String){
          m_pTestVC?.addGetLog(strLog)
      }
    //类工具方法
    class func loadCmdStr(_ strFileNameIn:String?)  {
        var strFileName = strFileNameIn ?? ""
        if !(strFileName.hasSuffix(".txt") ) {
                   strFileName = "\(strFileName).txt"
        }
        let strFilePath  = "\(NSHomeDirectory())/Documents/\(strFileName)"
        BleTool.loadCmdFilePath( strFilePath)
    }
    class func loadCmdFilePath(_ strFilePath:String?)  {
        var strCmd:String?
        if strFilePath != nil  {
            strCmd = try?String.init(contentsOfFile: strFilePath!)
            guard strCmd != nil else {
              return
            }
            let dicData = LanguageTool.jsonToDictionary(strCmd!)
            BleTool.shareInstence.m_dicData = dicData
        }
    }
}
