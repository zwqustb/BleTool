//
//  FileTool.swift
//  MobileHealth
//
//  Created by boeDev on 2018/10/18.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
//func saveLog(_ strLog:String?)  {
//    if strLog != nil && isTestApp(){
//        FileTool.default.fileSaveLog(strLog!)
//    }
//}
class FileTool: NSObject {
    static let `default` = FileTool.init()
    var m_pUploadData = Data.init()
    //分界标识
    let boundaryStr="--"
    let boundaryID="haha"
    
    //上传文件的方法
    func uploadFileToHost(urlString:String,name:String,fileName:String,mimeType:String,paramters:String?,fileData:NSData, sucess :@escaping (Data?)->Void, failure :@escaping (Error?)->Void ){
        
        if urlString.isEmpty{
            print ("主地址不能为空")
            return
        }
        //固定拼接的第一部分
        let top=NSMutableString()
        top.appendFormat("%@%@\r\n", boundaryStr,boundaryID)
        top.appendFormat("Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name,fileName)
        top.appendFormat("Content-Type: %s\r\n\r\n", mimeType)
        
        //固定拼接第三部分
        let buttom=NSMutableString()
        buttom.appendFormat("%@%@\r\n", boundaryStr,boundaryID)
        buttom.append("Content-Disposition: form-data; name=\"submit\"\r\n\r\n")
        buttom.append("Submit\r\n")
        buttom.appendFormat("%@%@--\r\n", boundaryStr,boundaryID)
        
        //拼接
        let fromData=NSMutableData()
        //非文件参数
        if (paramters != nil){
            fromData.append(paramters!.data(using: .utf8)!)
        }
        fromData.append(top.data(using:String.Encoding.utf8.rawValue)!)
        fromData.append(fileData as Data)
        fromData.append(buttom.data(using:String.Encoding.utf8.rawValue)!)
        
        //可变请求
        let requset = NSMutableURLRequest(url: URL.init(string: urlString)!)
        requset.httpBody=fromData as Data
        requset.httpMethod="POST"
        requset.addValue(String(fromData.length), forHTTPHeaderField:"Content-Length")
        let contype=String(format: "multipart/form-data; boundary=haha", boundaryID)
        requset.setValue(contype, forHTTPHeaderField: "Content-Type")
        
        let session=URLSession.shared
        session.uploadTask(with: requset as URLRequest, from: nil) { (responseData, response, error) -> Void in
            if error==nil{
                sucess(responseData)
            }
            else{
                failure(error! as NSError)
            }
            }.resume()
    }
    //把log写入文件
    func fileSaveLog(_ strLog:String){
        //将内容同步写到文件中去（Caches文件夹下）
        let cachePath = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)[0]
        let logURL = cachePath.appendingPathComponent("log.txt")
        appendText(fileURL: logURL, string: "\(strLog)")
    }
    //在文件末尾追加新内容
    func appendText(fileURL: URL, string: String) {
        do {
        //如果文件不存在则新建一个
        if !FileManager.default.fileExists(atPath: fileURL.path) {
        FileManager.default.createFile(atPath: fileURL.path, contents: nil)}
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            let stringToWrite = string
            
            //找到末尾位置并添加
            fileHandle.seekToEndOfFile()
            fileHandle.write(stringToWrite.data(using: String.Encoding.utf8)!)
            
        } catch let error as NSError {
            print("failed to append: \(error)")
        }
    }
    func saveDocFile(content:String,title:String){
        var strFileName = title
        if !title.hasSuffix(".txt") {
            strFileName = "\(title).txt"
        }
        let cachePath = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)[0]
        let fileURL = cachePath.appendingPathComponent(strFileName)
        try?FileManager.default.removeItem(at: fileURL)
        appendText(fileURL: fileURL, string: content)
    }
    class func docFileNameList()->NSArray?{
        let cachePath = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask)[0]
        let strDocPath = "\(NSHomeDirectory())/Documents"
        let aryList = try?FileManager.default.contentsOfDirectory(atPath:strDocPath )
        return aryList as NSArray?
    }
    class func docFileContent(title:String)->String?{
         let strDocPath = "\(NSHomeDirectory())/Documents/\(title)"
        let contentData = FileManager.default.contents(atPath: strDocPath)
        if contentData == nil {
            return nil
        }
        let strContent = String.init(data: contentData!, encoding: .utf8)
        print("Path:\(strDocPath)")
        return strContent
    }
    class func copySysFileToDocument(_ arySysFile:[String]){
        arySysFile.forEach { (strFileName) in
            let oldPath = Bundle.main.path(forResource: strFileName, ofType: "txt")
            let targetPath = "\(NSHomeDirectory())/Documents/\(strFileName).txt"
            if oldPath != nil{
#if DEBUG
    copyPath(oldPath!, targetPath)
#else
if !isFileExist(targetPath) {
    copyPath(oldPath!, targetPath)
}
#endif
                
            }
            
        }
    }
    //文件操作通用方法
    class func isFileExist(_ strPath:String)->Bool{
          let bExist = FileManager.default.fileExists(atPath: strPath)
          return bExist
      }
      class func isFolderExist(_ strPath:String)->Bool{
          var directoryExists = ObjCBool.init(false)
          let fileExists = FileManager.default.fileExists(atPath: strPath, isDirectory: &directoryExists)
          return fileExists && directoryExists.boolValue
      }
      class func createFolder(_ strPath:String){
          let url = URL.init(fileURLWithPath: strPath)
          let manager = FileManager.default
          let exist = manager.fileExists(atPath: strPath)
          if !exist {
              try! manager.createDirectory(at: url, withIntermediateDirectories: true,
                                           attributes: nil)
          }
      }
      class func getFolderList(_ strPath:String)->[String]?{
          let manager = FileManager.default
          let aryRet = try?manager.contentsOfDirectory(atPath: strPath)
          return aryRet
      }
      class func copyPath(_ strFrom:String, _ strTo:String){
          do{
              let manager = FileManager.default
              let urlFrom = URL.init(fileURLWithPath: strFrom)
              let urlTo = URL.init(fileURLWithPath: strTo)
              let bExist = manager.fileExists(atPath: strTo)
              if bExist {
                  try manager.removeItem(at: urlTo)
              }
              try manager.copyItem(at: urlFrom, to: urlTo)
          }catch{
          }
      }
      class func deleteFile(_ strPath:String){
          let manager = FileManager.default
          let urlTo = URL.init(fileURLWithPath: strPath)
          let bExist = manager.fileExists(atPath: strPath)
          if bExist {
              try? manager.removeItem(at: urlTo)
          }
      }
}
