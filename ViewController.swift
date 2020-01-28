//
//  ViewController.swift
//  BleTool
//
//  Created by boeDev on 2019/5/31.
//  Copyright © 2019 boeDev. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController {

    @IBOutlet weak var lCmdName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        var str = "1234567890"
     //str = str.substring(from: 8)
        print("010203".appendCheckSum())
        print("010203".appendCheckSum())
        print("03020a01".appendCheckSum())
        print(str.substring(in: 9))
        print(str.substring(in: 10))
        let n10UsedMode = 5
                   //2进制
        let str2UsedMode = String(n10UsedMode,radix:2)
        print(str2UsedMode)
        let incrementByTen = makeIncrementor(forIncrement: 10)

          // 返回的值为10
         print(incrementByTen())

          // 返回的值为20
          print(incrementByTen())

          // 返回的值为30
          print(incrementByTen())
//        let strIn = "00"
//        let characterSet = CharacterSet(charactersIn: "0")
//        var strRet = strIn.trimmingCharacters(in: characterSet)
//        if strRet.hasPrefix("."){
//            strRet = "0\(strRet)"
//        }else if strRet == ""{
//            strRet = "0"
//        }
//        print(strRet)
//        let pView = WKWebView.init(frame: self.view.frame, configuration: WKWebViewConfiguration.init())
//        let str = "https://sscobj.boe.com/test-info-static/mhealth/1182.html?sys=mhealth&infoId=1182&st=VyTvRKSvZtaQLPgYg8aGhg==&ut=VyTvRKSvZtaQLPgYg8aGhg==&userId=Pu8voO/aW0wp8CdbYZSKFw==&phoneId=B5CC5D58-7A06-4F7C-9CDC-C8D3FEC2B1AE&share=1"
//        pView.load(URLRequest.init(url: URL.init(string: str)!))
//        self.view.addSubview(pView)
        // Do any additional setup after loading the view.
        FileTool.copySysFileToDocument(["爱奥乐血压计","脉搏波血压计","母乳分析仪","攀高按摩仪"])
    }
    override func viewDidAppear(_ animated: Bool) {
        var strFileName = CmdLocalData.shareInstence.getCurCmdName()
        lCmdName.text = strFileName
        if !(strFileName.hasSuffix(".txt") ) {
            strFileName = "\(strFileName).txt"
        }
       let strFilePath  = "\(NSHomeDirectory())/Documents/\(strFileName)"
        BleTool.loadCmdFilePath( strFilePath)
    }

    @IBAction func clickTestVC(_ sender: UIButton) {
        let pVC = CmdTestVC.init(nibName: "CmdTestVC", bundle: nil)
        BleTool.shareInstence.m_pTestVC = pVC
        pushView(pVC)
    }
    func makeIncrementor(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementor() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementor
    }

  
}

