//
//  RKWebVC.swift
//  RKProject
//
//  Created by YB007 on 2020/11/25.
//

import UIKit
import WebKit

class RKWebVC: RKBaseVC {

    var request: URLRequest!
    
    lazy var webView: WKWebView = {
        let web = WKWebView()
        web.navigationDelegate = self
        web.uiDelegate = self
        return web
    }()
    
    lazy var progressView: UIProgressView = {
        let pro = UIProgressView()
//        pro.trackImage = UIImage(named: "导航-进度")
//        pro.progressTintColor = .white
        pro.trackTintColor = .white
        pro.progressTintColor = rkMainCor
        return pro
    }()
    
    convenience init(url: String?){
        self.init()
        self.request = URLRequest(url: URL(string: url ?? "")!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleL.text = "loading..."
        
        view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.width.bottom.centerX.equalToSuperview()
            make.top.equalTo(titleL.snp.bottom)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(webView)
            make.height.equalTo(2)
        }
        
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        webView.load(request)
    
    }
    
    
    override func clickNaviLeftBtn() {
        if webView.canGoBack {
            webView.goBack()
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
}

extension RKWebVC: WKNavigationDelegate,WKUIDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.isHidden = webView.estimatedProgress >= 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
        titleL.text = (webView.title ?? webView.url?.host)
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
       
        let url = navigationAction.request.url
        let scheme = url?.scheme
        guard let schemeStr = scheme else {
            return
        }
        if schemeStr == "tel" {
            //UIApplication.shared.open(url!, options: [String : Any], completionHandler: nil)
        }
        if schemeStr.contains("copy://") {
            let past = UIPasteboard.general
            past.string = schemeStr.replacingOccurrences(of: "copy://", with: "")
            rkprint("复制成功");
            decisionHandler(.cancel)
        }
        
        decisionHandler(.allow)
    }
    
}
