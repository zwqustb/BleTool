//
//  CmdTestVC.swift
//  BleTool
//
//  Created by boeDev on 2019/11/21.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit

class CmdTestVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
 

    @IBOutlet weak var m_pPickerView: UIPickerView!
    @IBOutlet weak var cTxtHeight: NSLayoutConstraint!
    @IBOutlet weak var m_pTxt: UITextView!
    var m_selectTitle = ""
    var m_aryData = [""]
    //MARK:view life cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        BleTool.shareInstence.startScan()
        m_pTxt.isEditable = false
//        cTxtHeight.constant = self.view.frame.size.height - 60
//        let dicCmd = BleTool.shareInstence.m_dicData?["sendCmd"] as? NSDictionary ?? ["":""]
//        m_aryData = dicCmd.allKeys as! [String]
        let dicData = BleTool.shareInstence.m_dicData
        let aryCmd = dicData?["sendCmd"] as? NSArray ?? []
        m_aryData = aryCmd as! [String]
        m_selectTitle = m_aryData.first ?? ""
        // Do any additional setup after loading the view.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        BleTool.shareInstence.disconnectDevice()
    }
    //MARK:click
    @IBAction func clickChangeUI(_ sender: UIButton) {
//        if sender.isSelected{
//            cTxtHeight.constant = self.view.frame.size.height - 60
//        }else{
//            cTxtHeight.constant = self.view.frame.size.height/2
//        }
//        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func clickSendCmd(_ sender: UIButton) {
        let dicCmd = BleTool.shareInstence.m_dicData?["cmd"] as? NSDictionary ?? ["":""]
        let cmdContent = dicCmd.getStr(m_selectTitle)
        BleTool.shareInstence.m_strPackageTitle = m_selectTitle
        BleTool.shareInstence.writeData(cmdContent)
        
    }
    //MARK:Func Tool
    func addLog( _ strLog:String ){
        addColorLog(strLog, .black)
    }
    func addSendLog( _ strLog:String ){
        addColorLog(strLog, .red)
    }
    func addGetLog( _ strLog:String ){
        addColorLog(strLog, .blue)
    }
    func addColorLog(_ strLog:String,_ pColor:UIColor){
        let pAttrTxt = m_pTxt.attributedText
        let strAttr = NSAttributedString.init(string: "\n\(strLog)", attributes: [NSAttributedString.Key.foregroundColor : pColor])
        let attrM = NSMutableAttributedString.init()
        if pAttrTxt != nil {
            attrM.append(pAttrTxt!)
        }
        attrM.append(strAttr)
        m_pTxt.attributedText = attrM
        m_pTxt.scrollRangeToVisible(NSMakeRange(attrM.length-2, 1))
    }
    //MARK:delegate
     func numberOfComponents(in pickerView: UIPickerView) -> Int {
         return 1
     }
     func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
         let aryKeys = m_aryData
         return aryKeys.count
     }
     func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         let aryKeys = m_aryData
         let strKey = aryKeys[row]
         return strKey
     }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        m_selectTitle = m_aryData[row]
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
