//
//  WebVC.swift
//  MobileHealth
//
//  Created by boeDev on 2018/8/20.
//  Copyright © 2018年 Jiankun Zhang. All rights reserved.
//

import UIKit
@objcMembers
class WebVC: UIViewController {
    //初始地址
    @objc var pUrl:URL?
    var m_pWeb:SafeWeb?
    @objc var strTitle:String?
    var m_pTitleLabel:UILabel?
    //webview 当前加载的地址
    fileprivate var loadedUrl:URL?
    //点击返回时是否先返回web中的上一页,导航条左侧是否显示关闭按钮
    var m_bBackWeb = false
    //分享按钮 0:无分享,1:分享URL,2:分享图片
    var m_nShareType:Int = 0{
        didSet{
            switch m_nShareType {
            case 1...2:
                self.addShareBtn()
                break
            default:
                break
            }
        }
    }
    //网络分享的地址 或者是 图片分享的类名
    var shareTip:String?
    @objc class func showWebWith(urlString:String,_ title:String){
        let pWeb = WebVC.init()
        pWeb.pUrl = URL.init(string: urlString)
        pWeb.strTitle = title
        pushView(pWeb)
    }
    class func showWebWith(urlString:String,title:String,shareType:Int,shareTip:String){
        let pWeb = WebVC.init()
        pWeb.pUrl = URL.init(string: urlString)
        pWeb.strTitle = title
        pWeb.m_nShareType = shareType
        pWeb.shareTip = shareTip
        pushView(pWeb)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //let rtFrame = self.view.bounds
        let hNav = getNavHeight(false)
        let rtWeb =  CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - hNav)
        m_pWeb = SafeWeb.createWebWith("", rtWeb)
        let backImg =  #imageLiteral(resourceName: "backBlack").withRenderingMode(.alwaysOriginal)
        let backItem = UIBarButtonItem.init(image:backImg, style: .plain, target: self, action: #selector(clickNavBack))
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        backItem.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backItem
        //        pWeb.navigationItem.backBarButtonItem = backItem
        //        pWeb.navigationItem.backBarButtonItem?.setBackgroundImage(backImg, for: .normal, barMetrics: UIBarMetrics.default)
        if pUrl == nil {
            return
        }
        self.view.addSubview(m_pWeb!)
        m_pWeb?.loadUnsafeUrl(pUrl!)
        //设置标题
        let title = strTitle ?? "标题"
        m_pTitleLabel = UITools.getTitleLabel(title)
        self.title = title
        self.navigationItem.titleView = m_pTitleLabel
        loadedUrl = pUrl
        self.view.backgroundColor = UIColor.appLightWhite()
        self.view.clipsToBounds = true
        //监听title
        m_pWeb?.addObserver(self, forKeyPath: "title", options: .new, context: nil)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "title" {
            let title = m_pWeb?.title ?? ""
            self.setWebTitle(title)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavTranslucent(false)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.appBlackColor()]
    }
    @objc func clickNavBack(){
        if m_pWeb?.canGoBack ?? false {
            m_pWeb?.goBack()
        }else{
            popView()
        }
    }
    // MARK: - delegate
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            let bt = self.view.safeAreaInsets.bottom
            let hNav = getNavHeight(false)
            m_pWeb?.frame = CGRect.init(x: 0, y: 0, width: KScreenWidth, height: KScreenHeight - hNav - bt)
        } else {
            // Fallback on earlier versions
        }
    }
    @objc func setWebTitle(_ title:String){
        if !StringTool.isBlank(title) {
            self.title = title
            m_pTitleLabel?.text = title
            strTitle = title
        }else{
            self.title = strTitle
            m_pTitleLabel?.text = strTitle
        }
        if self.title == "心贴检测报告" || title == "心贴监测报告"{
            self.addShareBtn()
        }
    }
    //MARK: 点击分享
    @objc func clickShare(){
        switch m_nShareType {
        case 1:
            break
        case 2:
            if shareTip == "BodyFatShareView"{
                let img = self.captureScreen(webView: m_pWeb!)
                BodyFatShareView.shareWithImg(img)
                return
            }
        default:
            break
        }
        let strUrl = self.loadedUrl
        let title = self.strTitle ?? ""
        var content = ""
        if title == "心贴检测报告" || title == "心贴监测报告"{
            content = "我正在使用BOE移动健康测量心电数据,来看看我的测量结果吧"
        }
        let imgUrl = "\(getServerUrl())html/mhealth/mobile/m-x/M03/img/Group.png"
        ShareMode.default.setShareData(content: content,
                                       image: imgUrl,
                                       url: strUrl,
                                       title:title)
        ShareMode.default.startShare(self.view,bShareVideo: true)
       // LogicTool.addBonusPoint(["code":"15","businessId":nId])
    }
    func addShareBtn(){
        //let rightItem = UIBarButtonItem.init(title: "分享", style: .plain, target: self, action: #selector(clickShare))
        let rightItem = UIBarButtonItem.init(image: UIImage.init(named: "health_Share")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(clickShare))
         self.navigationItem.rightBarButtonItem = rightItem
    }
    //配置导航条
    @objc func setBackWeb(){
        let rightItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "iconCloseBlank"), style: .plain, target: self, action: #selector(clickClose))
        self.navigationItem.rightBarButtonItem = rightItem
        m_bBackWeb = true
    }
    @objc func clickClose(){
        popView()
    }
    //截屏
    func captureScreen(webView: SafeWeb) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(webView.bounds.size, false, UIScreen.main.scale)
        webView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    deinit {
        m_pWeb?.removeObserver(self, forKeyPath: "title")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
