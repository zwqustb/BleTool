//
//  ChooseCmdVC.swift
//  BleTool
//
//  Created by boeDev on 2019/6/3.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit

class ChooseCmdVC: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return m_aryFileName.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let strTitle = m_aryFileName[row]
        return strTitle
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row != 0{
            let title = m_aryFileName[row]
            CurSelectData.shareInstence.curTitle = title
//            let strContent = FileTool.docFileContent(title: title)
//            let aryChar = strContent?.split(separator: ",")
//            let aryString = NSMutableArray.init()
//            aryChar?.forEach({ (pChar) in
//                aryString.add(String(pChar))
//            })
           // CurSelectData.shareInstence.aryCurCmd = aryString as? [String]
            self.setCurCmdName(title)

        }
        m_pPickerView.isHidden = true
    }
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cTxtBottom: NSLayoutConstraint!
    var m_strCmdName = ""
    var m_pPickerView = UIPickerView.init()
    var m_aryFileName = ["不改变"]
    override func viewDidLoad() {
        super.viewDidLoad()
        let strName = CmdLocalData.shareInstence.getCurCmdName()
        self.setCurCmdName(strName)
        m_pPickerView.frame = self.view.bounds
        m_pPickerView.dataSource = self
        m_pPickerView.delegate = self
        m_pPickerView.isHidden = true
        m_pPickerView.backgroundColor = UIColor.white
        self.view.addSubview(m_pPickerView)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        CmdLocalData.shareInstence.saveCurCmdName(m_strCmdName)
    }
    
    @IBAction func clickDefaultCmd(_ sender: UIButton) {
     
        //self.setCurCmdName("milk")
        let title = sender.title(for: .normal) ?? ""
        self.setCurCmdName(title)
    }
    
    @IBAction func saveCurCmd(_ sender: UIButton) {
        let strTitle = txtField.text
        if StringTool.isBlank(strTitle){
            UITools.alertMsg("请输入名称")
            return
        }
        let strContent = textView.text ?? ""
        FileTool.default.saveDocFile(content: strContent,title: txtField.text ?? "未知")
//        textView.becomeFirstResponder()
        textView.resignFirstResponder()
        cTxtBottom.constant = 0
    }
    
    @IBAction func showOtherCmd(_ sender: UIButton) {
        m_aryFileName.removeAll()
        m_aryFileName.append("不改变")
        let aryFiles = FileTool.docFileNameList() as! [String]
        aryFiles.forEach { (strTitle) in
            m_aryFileName.append(strTitle)
        }
        m_pPickerView.isHidden = false
        m_pPickerView.reloadAllComponents()
    }
    func setCurCmdName(_ strName:String){
        let aryNames = strName.split(separator: ".")
        let strFileName = aryNames.first ?? ""
        let strFilePath = "\(NSHomeDirectory())/Documents/\(strFileName).txt"
        m_strCmdName = strName
        txtField.placeholder = strName
        txtField.text = strName
        textView.text = try?String.init(contentsOfFile: strFilePath)
        BleTool.loadCmdFilePath(strFilePath)
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            cTxtBottom.constant = keyboardHeight
        }
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
