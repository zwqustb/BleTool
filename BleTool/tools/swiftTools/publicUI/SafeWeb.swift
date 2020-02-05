//
//  SafeWeb.swift
//  MobileHealth
//
//  Created by boeDev on 2019/1/25.
//  Copyright © 2019 Jiankun Zhang. All rights reserved.
//

import UIKit
import WebKit
@objc protocol SafeWebDelegate:NSObjectProtocol {
    func webView(_ webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    @objc optional func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage)
    @objc optional func webView(_ webView: WKWebView, didCommitNavigation navigation: WKNavigation!)
    @objc optional func webView(_ webView: WKWebView, didFailNavigation navigation: WKNavigation!,withError error: Error)
    @objc optional func webView(_ webView: WKWebView, didFinishNavigation navigation: WKNavigation!)
}
class SafeWeb: WKWebView,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    var m_pProgressView:UIProgressView?
    //是否显示进度条
    @objc var m_bProgressHidden = false
    @objc weak var boeDelegate:SafeWebDelegate?
    @objc class func createWebWith(_ pUrl:String,_ reRect:CGRect,_ configParam:WKWebViewConfiguration? = nil) -> SafeWeb {
        
//        let strAgent = BOENetWorkTools.sharedManager()?.m_strUserAgent
//        let dic = ["UserAgent":strAgent];
//        UserDefaults.standard.register(defaults: dic as [String : Any])
        
        var pConfig = WKWebViewConfiguration.init()
        pConfig.preferences = WKPreferences()
        pConfig.preferences.javaScriptEnabled = true
        pConfig.preferences.javaScriptCanOpenWindowsAutomatically = false
        pConfig.allowsInlineMediaPlayback = true
        pConfig.userContentController = WKUserContentController()
       
        if configParam != nil{
            pConfig = configParam!
        }
        
        let pWebview = SafeWeb.init(frame: reRect, configuration:pConfig)
        
        pWebview.uiDelegate = pWebview
        pWebview.navigationDelegate = pWebview
        pWebview.configBoeSafeInfo()
        if !StringTool.isBlank(pUrl){
            pWebview.loadUrlString(pUrl)
        }
        
        //进度条
        pWebview.m_pProgressView = UIProgressView.init(frame: CGRect.init(x: 0, y: 0, width: KScreenWidth, height: 3))
        pWebview.m_pProgressView?.progressTintColor = UIColor.appBlueColor()
        pWebview.m_pProgressView?.trackTintColor = UIColor.clear
        pWebview.m_pProgressView?.backgroundColor = UIColor.clear
        pWebview.addSubview(pWebview.m_pProgressView!)
        pWebview.addObserver(pWebview, forKeyPath: "estimatedProgress", options: .new, context: nil)

        pWebview.evaluateJavaScript("navigator.userAgent") { (result, error) in
            let strAgent = BOENetWorkTools.sharedManager()?.m_strUserAgent
            let dic = ["User-Agent":strAgent];
            UserDefaults.standard.register(defaults: dic as [String : Any])
            UserDefaults.standard.synchronize()
            pWebview.customUserAgent = strAgent
        }
        NotificationCenter.default.addObserver(pWebview, selector: #selector(endFullScreen), name: NSNotification.Name.UIWindowDidBecomeHidden , object: nil)
        return pWebview
    }
    @objc func endFullScreen(){
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.init(rawValue: 0) ?? UIStatusBarAnimation.fade)
    }
// 传入   不加st、ut、的urlString
    @objc func loadUrlString(_ strUrl:String)  {
        let strUrlNew = LogicTool.addTokenForUrl(strUrl)
        
        let url = URL.init(string: strUrlNew)
        if url != nil {
            self.loadSafeUrl(url!)
        }
    }
//传入  加st\Ut的URl
    func loadSafeUrl(_ pUrl:URL)  {
//        let url = URL.init(string: strUrl)
//        if url != nil {
            self.m_pProgressView?.isHidden = m_bProgressHidden
            let req = URLRequest.init(url: pUrl)
            self.load(req)
        print(req)
//        }
    }
// 传入    不加st、ut、的url
    func loadUnsafeUrl(_ pUrl:URL){
        let strUrl = pUrl.absoluteString
        self.loadUrlString(strUrl)
    }
    //webview 的实现
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let strUrl = navigationAction.request.url?.absoluteString
        
        if strUrl != nil{
            if strUrl!.hasSuffix("logout.html") {
                if LogicTool.isLogin(){
                    decisionHandler(WKNavigationActionPolicy.cancel)
                    return;
                }else{
                    UITools.popToHome()
                    BOEProgressHUD.dismiss()
                    _ = UITools.isLogin()
                }
            }
        }
        if boeDelegate != nil {
            self.boeDelegate?.webView(webView, decidePolicyForNavigationAction: navigationAction, decisionHandler: decisionHandler)
        }else{
            decisionHandler(WKNavigationActionPolicy.allow)
        }
        
        
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        boeDelegate?.userContentController?(userContentController, didReceiveScriptMessage: message)
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        boeDelegate?.webView?(webView, didCommitNavigation: navigation)
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        boeDelegate?.webView?(webView, didFailNavigation: navigation, withError: error)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.m_pProgressView?.isHidden = true
        boeDelegate?.webView?(webView, didFinishNavigation: navigation)
    }
    func configBoeSafeInfo() {
        // 设置localStorage
        let StaticToken = BOENetWorkTools.sharedManager()?.getStaticToken()
        let UserToken = LogicTool.getUserToken()
        let jsString = "localStorage.setItem('st', '\(StaticToken ?? "")')"
        self.evaluateJavaScript(jsString) { (pAny, pError) in
        }
        let jsString2 = "localStorage.setItem('ut', '\(UserToken)')"
        self.evaluateJavaScript(jsString2) { (pAny, pError) in
        }
      
    }
    // MARK: - 处理进度条监听事件
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let fProgress = self.estimatedProgress
        if keyPath == "estimatedProgress"{
            self.m_pProgressView?.setProgress(Float(fProgress), animated: true)
            if(fProgress>=1.0){
                self.m_pProgressView?.progress = Float(1.0)
                self.m_pProgressView?.isHidden = true
            }
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.removeObserver(self, forKeyPath: "estimatedProgress")
        self.navigationDelegate = nil
        self.uiDelegate = nil
    }
}
