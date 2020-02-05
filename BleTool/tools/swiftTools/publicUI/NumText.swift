//
//  extText.swift
//  MobileHealth
//
//  Created by boeDev on 2018/10/30.
//  Copyright © 2018 Jiankun Zhang. All rights reserved.
//
//可以控制输入范围的文本框
import UIKit
protocol NumTextDelegate:NSObjectProtocol {
    func onTextEndEidt()
}
class NumText: UITextField,UITextFieldDelegate {
    //是否被编辑过
    var m_bEdit:Bool = false
    //整数和小数位数控制 例如 1.00~2.00
    var m_numRange:String?
    weak var pNumTextDelegate:NumTextDelegate?
    @IBInspectable var numRange:String?{
        get {
           return self.m_numRange
            //let nRange =markedTextRange
          //  return self.markedTextRange
        }
        set {
            if newValue != nil {
                let arySubString = newValue?.split(separator: "~") ?? []
                if arySubString.count == 2{
                    self.delegate = self
                    m_numRange = newValue
                    let bFloat = arySubString.first?.contains(".") ?? false
                    if bFloat{
                        self.keyboardType = .decimalPad
                    }else{
                        self.keyboardType = .numberPad
                    }
                    return
                }
            }
            m_numRange = nil
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let strTxt = NSMutableString.init()
        if self.text != nil {
            strTxt.append(self.text!)
        }
        if range.location == strTxt.length {
            strTxt.append(string)
        }else{
            strTxt.replaceCharacters(in: range, with: string)
        }
        let bRet = self.checkValueFormat(strTxt as String)
        if bRet {
            m_bEdit = true
        }
        return bRet
    }
    //textview的
//    override func shouldChangeText(in range: UITextRange, replacementText text: String) -> Bool {
//
//    }
    func checkValueFormat(_ text:String)->Bool{
        //输入时的判断
        if m_numRange != nil {
            let arySubString = m_numRange!.split(separator: "~")
            if arySubString.count != 2{
                print("限制范围不正确")
                return true
            }
            let curValue = Double(text)
            let minStr = arySubString.first
            //输入时不判断最小值,只判断最大值
            let maxStr = arySubString.last
            if maxStr != nil{
                let maxNum = Double(String(maxStr!))
                if maxNum != nil && curValue != nil && curValue! > maxNum! {
                    print("输入值不能超出最大值\(maxNum!)")
                    return false
                }
            }
            //判断小数位超出
            let aryMin = minStr?.split(separator: ".") ?? []
            var nDecimal = 0
            if aryMin.count == 2{
                nDecimal = aryMin.last?.count ?? 0
            }
            let aryCur = text.split(separator: ".")
            if aryCur.count == 2{
                let nCurDecimalCount = aryCur.last?.count ?? 0
                if nCurDecimalCount > nDecimal{
                    if nDecimal  == 0{
                        print( "不能为小数")
                    }else{
                        print( "小数位数不能超过\(nDecimal)")
                    }
                    return false
                }
            }else if text.hasSuffix("."){
                if nDecimal == 0{
                    print( "不能为小数")
                    return false
                }
            }
        }
        return true
    }
    //停止编辑
    func textFieldDidEndEditing(_ textField: UITextField) {
        pNumTextDelegate?.onTextEndEidt()
    }
}
