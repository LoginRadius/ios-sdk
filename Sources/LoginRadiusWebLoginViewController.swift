//
//  LoginRadiusWebLoginViewController.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation
import UIKit
import WebKit


public class LoginRadiusWebLoginViewController: UIViewController, WKNavigationDelegate {
    
    public var provider: String
    public var serviceURL: URL?
    public var handler: LRAPIResponseHandler?
    public weak var webView: WKWebView?
    public weak var retryView: UIView?
    public weak var retryLabel: UILabel?
    public weak var retryButton: UIButton?
    
    public init(provider: String, completionHandler: @escaping LRAPIResponseHandler) {
        self.provider = provider.lowercased()
        self.handler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let jScript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        let webView = WKWebView(frame: self.view.frame, configuration: wkWebConfig)
        webView.navigationDelegate = self
        
        let retryView = UIView(frame: self.view.frame)
        retryView.backgroundColor = UIColor.white
        retryView.isHidden = true
        
        self.view.addSubview(webView)
        self.view.addSubview(retryView)
        self.view.bringSubviewToFront(retryView)
        
        let retryLabel = UILabel(frame: .zero)
        retryLabel.textColor = UIColor.gray
        retryLabel.text = "Please check your network connection and try again."
        retryLabel.numberOfLines = 0
        retryLabel.textAlignment = .center
        retryLabel.lineBreakMode = .byWordWrapping
        retryLabel.translatesAutoresizingMaskIntoConstraints = false
        retryView.addSubview(retryLabel)
        
        let retryButton = UIButton(type: .roundedRect)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.sizeToFit()
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
        retryView.addSubview(retryButton)
        
        self.view.addConstraint(NSLayoutConstraint(item: retryButton, attribute: .centerX, relatedBy: .equal, toItem: retryView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: retryButton, attribute: .centerY, relatedBy: .equal, toItem: retryView, attribute: .centerY, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: retryLabel, attribute: .centerX, relatedBy: .equal, toItem: retryView, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: retryLabel, attribute: .width, relatedBy: .equal, toItem: retryView, attribute: .width, multiplier: 0.7, constant: 0.0))
        
        self.view.addConstraint(NSLayoutConstraint(item: retryLabel, attribute: .bottom, relatedBy: .equal, toItem: retryButton, attribute: .top, multiplier: 1.0, constant: -50.0))
        
        self.webView = webView
        self.retryView = retryView
        self.retryLabel = retryLabel
        self.retryButton = retryButton
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        
        self.navigationItem.leftBarButtonItem = cancelItem
        self.provider = self.provider.lowercased()
        
        let url = URL(string: "https://\(LoginRadiusSDK.siteName())/RequestHandlor.aspx?apikey=\(LoginRadiusSDK.apiKey())&provider=\(self.provider)&ismobile=1")
        self.serviceURL = url
        webView?.load(URLRequest(url: url!))!
        startMonitoringNetwork()
    }
    
    @objc public func cancelPressed() {
        self.finishSocialLogin("", withError: LRErrors.socialLoginCancelled(provider: self.provider))
    }
    
    public func startMonitoringNetwork() {
        do {
            if let reach = try? Reachability(hostname: "cdn.loginradius.com") {
                reach.whenUnreachable = { [weak self] _ in
                    DispatchQueue.main.async {
                        self?.retryLabel!.text = "Please check your network connection and try again."
                        self?.retryView!.isHidden = false
                    }
                }
                
                try reach.startNotifier()
            } else {
                print("Unable to create Reachability instance")
            }
        } catch {
            print("Error creating or starting Reachability: \(error)")
        }
    }
    
    
    
    @objc public func retry(_ sender: Any) {
        self.webView?.stopLoading()
        URLCache.shared.removeAllCachedResponses()
        if let url = self.serviceURL {
            self.webView?.load(URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60))
        }
        self.retryView?.isHidden = true
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public override func viewDidLayoutSubviews() {
        self.webView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.retryView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    // MARK: - Web View Delegates
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let urlString = webView.url?.absoluteString, urlString.range(of: "token=") != nil {
            var token: String?
            if let components = URLComponents(url: webView.url!, resolvingAgainstBaseURL: false) {
                for item in components.queryItems ?? [] {
                    if item.name == "token" {
                        token = item.value
                    }
                }
            }
            if let token = token {
                self.finishSocialLogin(token, withError: nil)
            } else {
                self.finishSocialLogin("", withError: LRErrors.socialLoginFailed(provider: self.provider))
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        /* Facebook Auth fails with the following error.
         Error Domain=NSURLErrorDomain Code=-999 "(null)"
         UserInfo={NSErrorFailingURLStringKey=https://m.facebook.com/intern/common/referer_frame.php,
         NSErrorFailingURLKey=https://m.facebook.com/intern/common/referer_frame.php}
         
         As per Facebook SDK, we should ignore these warnings.
         Ref: https://github.com/facebook/facebook-ios-sdk/blob/4b4bd9504d70d99d6c6b1ca670f486ac8f494f17/FBSDKCoreKit/FBSDKCoreKit/Internal/WebDialog/FBSDKWebDialogView.m#L141-L145
         */
        
        if (error._domain == NSURLErrorDomain && error._code == -999) ||
            (error._domain == "WebKitErrorDomain" && error._code == 102) {
            return
        }
        
        if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCannotConnectToHost || error._code == NSURLErrorNotConnectedToInternet {
            webView.load(URLRequest(url: URL(string: "about:blank")!))
            retryLabel!.text = "Please check your network connection and try again."
        } else if error._code == 101 {
            retryLabel!.text = "Error loading URL, check your API Key & Sitename and try again"
        }
        
        retryView!.isHidden = false
    }
    
    public func finishSocialLogin(_ accessToken: String, withError error: Error?) {
        if let handler = self.handler {
            DispatchQueue.main.async {
                let data = ["access_token": accessToken]
                handler(data, error)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
}

