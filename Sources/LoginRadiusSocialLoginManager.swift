//
//  LoginRadiusSocialLoginManager.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation
import SafariServices

/**
 *  Social Login Manager
 */


public class LoginRadiusSocialLoginManager {
    public static let sharedInstance = LoginRadiusSocialLoginManager()
    
    // MARK: - Init
    
    public var twitterLogin = LoginRadiusTwitterLogin()
    public var facebookLogin = LoginRadiusFacebookLogin()
    public var safariLogin = LoginRadiusSafariLogin()
    
    private(set) var isSafariLogin: Bool = false
    
    public var isFacebookNativeLogin = false
    
    public init() {
        twitterLogin = LoginRadiusTwitterLogin()
        facebookLogin = LoginRadiusFacebookLogin()
        safariLogin = LoginRadiusSafariLogin()
    }
    
    // MARK: -  Methods
    
    /**
     *  Login with the given provider
     *
     *  @param provider   provider name in small case (e.g facebook, twitter, google, linkedin, yahoo etc)
     *  @param controller view controller where social login take place should not be nil
     *  @param handler    code block executed after completion
     */
   
    
    
    public func login(withProvider provider: String,
                      inController controller: UIViewController,
                      completionHandler handler: @escaping LRAPIResponseHandler) {
        
        // Use SFSafariViewController if available by default. Recommended approach
        if SFSafariViewController.self != nil {
            self.isSafariLogin = true
            self.safariLogin.login(withProvider: provider, inController: controller, completionHandler: handler)
            return
        }
        
        //Use web login
        let webVC = LoginRadiusWebLoginViewController(provider: provider, completionHandler: handler)
        let navVC = UINavigationController(rootViewController: webVC)
        controller.present(navVC, animated: true, completion: nil)
    }
    
    /**
     *  Native Facebook Login
     *
     *  @param params     dict of parameters
     These are the valid keys
     - facebookPermissions : should be an array of strings
     - facebookLoginBehavior : New FB SDK is supporting FBSDKLoginBehaviorBrowser only
     recommended approach is to use FBSDKLoginBehaviorSystemAccount
     *  @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. facebook_<social app name> )
     *  @param controller view controller where social login take place should not be nil
     *  @param handler    code block executed after completion
     */
    public func nativeFacebookLoginWithPermissions(params: [String: Any], withSocialAppName socialAppName: String, inController controller: UIViewController, completionHandler handler: @escaping LRAPIResponseHandler) {
        self.isFacebookNativeLogin = true
        self.facebookLogin.login(from: controller, parameters: params, withSocialAppName: socialAppName, handler: handler)
    }
    
    /**
     Native Twitter Login
     
     @param twitterAccessToken Your Twitter User's Access Token
     @param twitterSecret Your Twitter app's Consumer Secret
     @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. twitter_<social app name> )
     @param controller view controller where Twitter login take place should not be nil
     @param handler code block executed after completion
     */
    public func convertTwitterTokenToLRToken(twitterAccessToken: String, twitterSecret: String, withSocialAppName socialAppName: String, inController controller: UIViewController, completionHandler handler: @escaping LRAPIResponseHandler) {
        self.twitterLogin.getLRToken(withTwitterToken: twitterAccessToken, twitterSecret: twitterSecret, socialAppName: socialAppName, inController: controller, handler: handler)
    }
    
    /**
     Native Google Login
     
     @param google_token Google Access Token
     @param google_refresh_token Google refresh_token
     @param google_client_id Google client_id
     @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. google_<social app name> )
     @param controller view controller where google login take place should not be nil
     @param handler code block executed after completion
     */
    public func convertGoogleTokenToLRToken(googleToken: String, googleRefreshToken: String, googleClientId: String, withSocialAppName socialAppName: String?, inController controller: UIViewController, completionHandler handler: @escaping LRAPIResponseHandler) {
        let refreshToken = googleRefreshToken ?? ""
        let clientId = googleClientId ?? ""
        var dictParam: [String: Any] = [
            "key": LoginRadiusSDK.sharedInstance.apiKey,
            "google_access_token": googleToken,
            "refresh_token": refreshToken,
            "client_id": clientId
        ]
        
        if let socialAppName = socialAppName, !socialAppName.isEmpty {
            dictParam["socialappname"] = socialAppName
        }
        
        LoginRadiusREST.apiInstance.sendGET(url: "api/v2/access_token/google", queryParams: dictParam) { (data, error) in
            handler(data, error)
        }
    }
    
    /**
     Native WeChat Login
     
     @param code WeChat Access Code
     @param handler code block executed after completion
     */
    public func convertWeChatCodeToLRToken( code: String, completionHandler handler: @escaping LRAPIResponseHandler) {
        LoginRadiusREST.apiInstance.sendGET(url: "api/v2/access_token/wechat", queryParams: [
            "key": LoginRadiusSDK.sharedInstance.apiKey,
            "code": code
        ]) { (data, error) in
            handler(data, error)
        }
    }
    
    /**
     Native Apple Login
     
     @param code Apple Access Code
     @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. apple_<social app name> )
     @param handler code block executed after completion
     */
    public func convertAppleCodeToLRToken( code: String, withSocialAppName socialAppName: String?, completionHandler handler: @escaping LRAPIResponseHandler) {
        var dictParam: [String: Any] = [
            "key": LoginRadiusSDK.sharedInstance.apiKey,
            "code": code
        ]
        
        if let socialAppName = socialAppName, !socialAppName.isEmpty {
            dictParam["socialappname"] = socialAppName
        }
        
        LoginRadiusREST.apiInstance.sendGET(url: "api/v2/access_token/apple", queryParams: dictParam) { (data, error) in
            handler(data, error)
        }
    }
    
    
    /**
     *  Log out the user
     */
    public func logout() {
        // Only facebook native login stores sessions that we have to clear.
        self.facebookLogin.logout()
    }
    
    
    // MARK: - AppDelegate methods
    
    public func applicationLaunched(withOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        self.facebookLogin.applicationLaunched(withOptions: launchOptions)
    }
    
    /**
     *  Call this for native social login to work properly
     */
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        var canOpen = false
        
        if self.isFacebookNativeLogin {
            self.isFacebookNativeLogin = false
            canOpen = self.facebookLogin.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        } else if self.isSafariLogin {
            self.isSafariLogin = false
            canOpen = self.safariLogin.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        }
        
        return canOpen
    }
}

