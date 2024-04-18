//
//  LoginRadiusTwitterLogin.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 *  Twitter native login
 */

/**
 *  Login
 *  @param twitter_token access token from Twitter
 *  @param twitter_secret secret from Twitter
 *  @param socialAppName  should have unique social app name as a provider in case of multiple social apps for the same provider (eg. twitter_<social app name> )
 *  @param controller controller is needed for Twitter native login
 *  @param handler service completion handler
 */


public class LoginRadiusTwitterLogin {
    
    
    // MARK: - Properties
    public var handler: LRAPIResponseHandler?
    public var emailVerified: Bool = false
    public var phoneIdVerified: Bool = false
    public var viewController: UIViewController?
    
    // MARK: - Methods
    
    public func getLRToken(withTwitterToken twitterToken: String,
                           twitterSecret: String,
                           socialAppName: String?,
                           inController controller: UIViewController,
                           handler: @escaping LRAPIResponseHandler) {
        self.handler = handler
        self.viewController = controller
        
        var dictParam: [String: Any] = [
            "key": LoginRadiusSDK.sharedInstance.apiKey,
            "tw_access_token": twitterToken,
            "tw_token_secret": twitterSecret
        ]
        
        if let socialAppName = socialAppName, !socialAppName.isEmpty {
            dictParam["socialappname"] = socialAppName
        }
        
        LoginRadiusREST.apiInstance.sendGET(url:"api/v2/access_token/twitter",
                                            queryParams: dictParam) { [weak self] data, error in
            self?.finishLogin(data: data as NSDictionary?, error: error as NSError?  )
        }
    }
    
    public func finishLogin(data: NSDictionary?, error: NSError?) {
        if let handler = self.handler {
            DispatchQueue.main.async {
                handler((data as! [String : Any]), error)
            }
        }
    }
}
