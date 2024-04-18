//
//  LoginRadiusSafariLogin.swift

//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation
import SafariServices

public class LoginRadiusSafariLogin: NSObject, SFSafariViewControllerDelegate {
    public var safariController: SFSafariViewController?
    public var viewController: UIViewController?
    public var handler: LRAPIResponseHandler?
    public var provider: String?
    
    // MARK: - Login Methods
    
    public func login(withProvider provider: String, inController controller: UIViewController, completionHandler handler: @escaping LRAPIResponseHandler) {
        self.provider = provider.lowercased()
        let siteName = LoginRadiusSDK.siteName()
        let apiKey = LoginRadiusSDK.apiKey()
        let provider = self.provider
        let bundleIdentifier = Bundle.main.bundleIdentifier
        
        let urlString = String(format: "https://%@.hub.loginradius.com/RequestHandlor.aspx?same_window=1&is_access_token=1&apikey=%@&callbacktype=hash&provider=%@&callback=%@.%@://",siteName, apiKey, provider!, siteName, bundleIdentifier!)
       
        let url = URL(string: urlString)
        
        let sfController = SFSafariViewController(url: url!)
        
        sfController.delegate = self
        controller.present(sfController, animated: true, completion: nil)
        self.safariController = sfController
        self.viewController = controller
        self.handler = handler
    }
    
    // MARK: - SFSafariViewControllerDelegate
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.finishSocialLogin(access_token: nil, error: LRErrors.socialLoginCancelled(provider: self.provider!))
    }
    
    public func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        if !didLoadSuccessfully {
            self.finishSocialLogin(access_token: nil, error: LRErrors.socialLoginFailed(provider: self.provider!))
        }
    }
    
    // MARK: - URL Scheme Handling
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let siteNameAndBundleID = "https\(LoginRadiusSDK.siteName()).\(Bundle.main.bundleIdentifier!)://"
        let isLoginRadiusURL = url.scheme == siteNameAndBundleID && url.host == "auth"
        let haveAccessToken = url.fragment?.hasPrefix("lr-token") ?? false
        
        if haveAccessToken {
            let token = url.fragment?.dropFirst(9).description
            self.finishSocialLogin(access_token: token, error: nil)
        } else {
            let access_denied = url.absoluteString
            if access_denied.contains("?denied_access") {
                self.finishSocialLogin(access_token: nil, error: LRErrors.socialLoginCancelled(provider: self.provider!))
            } else {
                self.finishSocialLogin(access_token: nil, error: LRErrors.socialLoginFailed(provider: self.provider!))
            }
        }
        
        return isLoginRadiusURL && haveAccessToken
    }
    
    // MARK: - Helper Methods
    
    public func finishSocialLogin(access_token: String?, error: NSError?) {
        self.viewController?.dismiss(animated: true) {
            if let handler = self.handler {
                DispatchQueue.main.async {
                    var data: [String: Any]? = nil
                    if let access_token = access_token {
                        data = ["access_token": access_token]
                    }
                    handler(data, error)
                }
            }
        }
    }
}
