//
//  StringTool.swift
//  biniu
//
//  Created by zhangwenqiang on 2018/4/6.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

import UIKit
@objcMembers
class StringTool: NSObject {
    class func isBlank(_ str:String?)->Bool{
        if str == nil || str == "" {
            return true
        }else{
            return false
        }
    }
}
extension String {
    mutating func partValue()->String{
        var ret = self
        let str = NSMutableString.init(string: self)
        if str.length>8 {
            let str1 = str.substring(to: 4)
            let str2 = str.substring(from: str.length-4)
            ret = "\(str1)****\(str2)"
        }else{
            let str1 = str.substring(to: 1)
            let str2 = str.substring(from: str.length-1)
            ret = "\(str1)****\(str2)"
        }
       return ret
    }
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]
            return String(subString)
        }else if self.count == index{
            return ""
        }else {
            return self
        }
    }
    //从1开始
    public func substring(to index: Int) -> String {
        if self.count > index {
            let endIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[self.startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    public func substring(from index: Int,length nLength:Int) -> String {
        if self.count >= index+nLength {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index+nLength)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    //根据字符串截断,包含当前字符串
    public func substring(between strBgn:String ,and strEnd:String) -> String {
        let indexBgn = self.firstIndex(of: strBgn.first ?? "@")
        let indexEnd = self.lastIndex(of: strEnd.last ?? "@")
        if indexBgn == nil || indexEnd == nil {
            return self
        }
        let subString = self[indexBgn!..<indexEnd!]
        return String(subString)
    }
    public func substring(in index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(self.startIndex, offsetBy: index+1)
            let subString = self[startIndex..<endIndex]
            return String(subString)
        } else {
            return self
        }
    }
    public func floatValue()->CGFloat{
        let dValue = Double(self) ?? 0.0
        return CGFloat(dValue)
    }
    public  func isNil(_ strIn:String?)->Bool
    {
        return strIn == nil || strIn == ""
    }
    func trim()->String{
        return self.trimmingCharacters(in:NSCharacterSet.whitespacesAndNewlines)
        
    }
    //HexString转Data
    func hex2data() -> Data? {
        //var data = Data(capacity: characters.count / 2)
        var data = Data(capacity: self.count / 2)
        let regex = try! NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive)
        regex.enumerateMatches(in: self, range: NSMakeRange(0, utf16.count)) { match, flags, stop in
            let byteString = (self as NSString).substring(with: match!.range)
            var num = UInt8(byteString, radix: 16)!
            data.append(&num, count: 1)
        }
        
        guard data.count > 0 else { return nil }
        
        return data
    }
    //转成hexString
    func toHexString() -> String? {
        let data = Data(self.utf8)
        let hexString = data.map{ String(format:"%02x", $0) }.joined()
        return hexString
    }
    func hex2Decimal()->Int{
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    func hex2Ascii()->String{
         let pattern = "(0x)?([0-9a-f]{2})"
           let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
           let nsString = self as NSString
           let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
           let characters = matches.map {
            Character(UnicodeScalar(UInt32(nsString.substring(with: $0.range(at: 2)), radix: 16)!)!)
           }
        return String(characters)
    }
    // 按两字节截断
    func spilteBy2Byte()->NSArray{
        let aryRet = NSMutableArray.init()
        var strTemp = self
        while strTemp.count > 2 {
            let strBgn = strTemp.substring(to: 2)
            aryRet.add(strBgn)
            strTemp = strTemp.substring(from: 2)
        }
        aryRet.add(strTemp)
        return aryRet
    }
    //http编码
    func httpEncode()->String?{
        var strRet = self.removingPercentEncoding
        strRet = strRet?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return strRet
    }
    //html转换成富文本
    func html2AttributeString()->NSAttributedString?{
      //let nScale = UIScreen.main.scale
        let str = self//.replacingOccurrences(of: "100%", with: "50%")
        let pData = str.data(using: String.Encoding.unicode)
       // let strAttr = try?NSAttributedString.init(data: pData!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
        let strAttr = try?NSAttributedString.init(data: pData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        strAttr?.resizeImgWithWidth(KScreenWidth)
        return strAttr
    }
    //String 转换成富文本
    func str2AttributeString(_ pDic:[String:Any])->NSAttributedString{
        let dicAttr = NSMutableDictionary.init()
        if pDic["font"] != nil {
            dicAttr[NSAttributedString.Key.font] = pDic["font"]
        }
        if pDic["color"] != nil{
            dicAttr[NSAttributedString.Key.foregroundColor] = pDic["color"]
        }
        let strAttr = NSAttributedString.init(string: self, attributes: (dicAttr as! [NSAttributedString.Key : Any]))
        return strAttr
    }
    //base64编码或解码
    func base64Code(bEncode:Bool)->String{
        if bEncode {
            let plainData = self.data(using: String.Encoding.utf8)
            let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
            return base64String!
        }else{
            //解码
            var encoded64 = "RVRDT01NVjAuMgAAAFYwLjIAAAAA0gEyMDE4LzEwLzE2IDEwOjA2OjI4"//self
            encoded64 = "RVRDT01NVjAuMiUwMCUwMCUwMFYwLjIlMDAlMDAlMDAlMDAlRDIlMDEyMDE4LzEwLzE2JTIwMTAlM0EwNiUzQTI4"
            let remainder = encoded64.count % 4
            if remainder > 0 {
                encoded64 = encoded64.padding(toLength: encoded64.count + 4 - remainder,
                                              withPad: "=",
                                              startingAt: 0)
            }
            let decodedData = Data(base64Encoded: encoded64, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
            if decodedData == nil{
                print("字符串不合法\(self)")
                return "字符串不合法"
            }
            
            let decodedString = String(data: decodedData! as Data, encoding: String.Encoding.utf8) ?? ""
            return decodedString
        }
    }
    //转换成json对象
    func toJSONDic()->NSDictionary?{
        let data = self.data(using: String.Encoding.utf8)
        if data == nil{
            return nil
        }
        let dicRet = try?JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
        return dicRet ?? nil
    }
    //后边加上两位校验和
    func appendCheckSum()->String{
        let aryHex = self.spilteBy2Byte()
        var sumInt = 0
        aryHex.forEach { (pAny) in
            let pStr = pAny as? String ?? "0"
            let nInt = pStr.hex2Decimal()
            sumInt += nInt
        }
        let sumHex = String(format:"%02x", sumInt)
        return "\(self)\(sumHex)"
    }
    func appendCheckSum(_ strType:String)->String{
        switch strType {
        case "+2":
            let aryHex = self.spilteBy2Byte()
            var sumInt = 0
            aryHex.forEach { (pAny) in
                let pStr = pAny as? String ?? "0"
                let nInt = pStr.hex2Decimal()
                sumInt += nInt
            }
            let sumHex = String(format:"%02x", sumInt+2)
            return "\(self)\(sumHex)"
        default:
            let aryHex = self.spilteBy2Byte()
            var sumInt = 0
            aryHex.forEach { (pAny) in
                let pStr = pAny as? String ?? "0"
                let nInt = pStr.hex2Decimal()
                sumInt += nInt
            }
            let sumHex = String(format:"%02x", sumInt)
            return "\(self)\(sumHex)"
        }
    }
}
extension NSAttributedString{
    func resizeImgWithWidth(_ fWidth:CGFloat){
        self.enumerateAttribute(NSAttributedString.Key.attachment, in: NSMakeRange(0, self.length), options: []) { (pAny, pRange, stop) in
            if (pAny != nil){
                let attachment = pAny as! NSTextAttachment
                let bounds0 = attachment.bounds
                if bounds0.width>=fWidth{
                    let fNewHeight = bounds0.height*fWidth/bounds0.width
                    attachment.bounds = CGRect.init(origin: bounds0.origin, size: CGSize.init(width: fWidth, height: fNewHeight))
                }
            }
        }
    }
}
