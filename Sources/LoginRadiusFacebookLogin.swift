//
//  LoginRadiusFacebookLogin.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//




import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

public class LoginRadiusFacebookLogin {
    
    
    public var handler: LRAPIResponseHandler?
    public var emailVerified: Bool = false
    public var phoneIdVerified: Bool = false
    
    public func login(from controller: UIViewController, parameters: [String: Any], withSocialAppName socialAppName: String, handler: @escaping LRAPIResponseHandler) {
        var permissionsAllowed = true
        var permissions: [String]
        self.handler = handler
        
        if let facebookPermissions = parameters["facebookPermissions"] as? [String] {
            permissions = facebookPermissions
        } else {
            // permissions not set using basic permissions;
            permissions = ["public_profile", "email"]
        }
        
        var token = AccessToken.current
        
        
        
        let login = LoginManager()
        
        typealias LoginResultHandler = (LoginManagerLoginResult?, Error?) -> Void
        let handleLogin: LoginResultHandler = { result, error in
            self.onLoginResult(result: result, error: error, withSocialAppName: socialAppName, controller: controller)
        }
        
        
        
        if let token =  token{
            
            
            // remove permissions that the user already has
            
            permissions = permissions.filter { permission in
                return token.hasGranted(permission: permission)
                
            }
            
            
            
            var publishPermissionFound = false
            var readPermissionFound = false
            for permission in permissions {
                if isPublishPermission(permission) {
                    publishPermissionFound = true
                } else {
                    readPermissionFound = true
                }
            }
            
            if permissions.isEmpty {
                if LoginRadiusSDK.sharedInstance.session.isLoggedIn(){
                    finishLogin(data: LoginRadiusSDK.sharedInstance.session.userProfile as NSDictionary? as! [String : Any], error: nil)
                } else {
                    convertFacebookTokenToLRToken(fbToken: token.tokenString, withSocialAppName: socialAppName, inController: controller)
                }
            } else if publishPermissionFound && readPermissionFound {
                // Mix of permissions, not allowed
                permissionsAllowed = false
                self.finishLogin(data: nil, error: LRErrors.nativeFacebookLoginFailedMixedPermissions())
                
            } else if publishPermissionFound {
                // Only publish permissions
                login.logIn(permissions: permissions, from: controller, handler: handleLogin)
            } else {
                // Only read permissions
                login.logIn(permissions: permissions, from: controller, handler: handleLogin)
            }
        } else {
            // Initial log in, can only ask for read type permissions
            if areAllPermissionsReadPermissions(permissions) {
                login.logIn(permissions: permissions, from: controller, handler: handleLogin)
            } else {
                permissionsAllowed = false
                finishLogin(data: nil, error: LRErrors.nativeFacebookLoginFailed())
            }
        }
    }
    
    public func onLoginResult(result: LoginManagerLoginResult?, error: Error?, withSocialAppName socialAppName: String, controller: UIViewController) {
        if let error = error {
            finishLogin(data: nil, error: error as NSError)
        } else if result?.isCancelled == true {
            finishLogin(data: nil, error: LRErrors.nativeFacebookLoginCancelled())
        } else {
            // all other cases are handled by the access token notification
            if let accessToken = AccessToken.current?.tokenString {
                // Get loginradius access_token for facebook access_token
                convertFacebookTokenToLRToken(fbToken: accessToken, withSocialAppName: socialAppName, inController: controller)
            }
        }
    }
    
    public func convertFacebookTokenToLRToken(fbToken: String, withSocialAppName socialAppName: String, inController controller: UIViewController) {
        var dictParam: [String: Any] = ["key": LoginRadiusSDK.apiKey(), "fb_access_token": fbToken]
        if !socialAppName.isEmpty {
            dictParam["socialappname"] = socialAppName
        }
        
        LoginRadiusREST.apiInstance.sendGET(url: "api/v2/access_token/facebook", queryParams: dictParam) { [weak self] data, error in
            self?.handler?(data as NSDictionary? as! [String : Any], error as NSError?)
        }
    }
    
    public func logout() {
        if let _ = AccessToken.current {
            let login = LoginManager()
            login.logOut()
        }
    }
    
    public func isPublishPermission(_ permission: String) -> Bool {
        return permission.hasPrefix("ads_management") ||
        permission.hasPrefix("manage_notifications") ||
        permission == "publish_actions" ||
        permission == "manage_pages" ||
        permission == "rsvp_event"
    }
    
    public func areAllPermissionsReadPermissions(_ permissions: [String]) -> Bool {
        for permission in permissions {
            if isPublishPermission(permission) {
                return false
            }
        }
        return true
    }
    
    
    public func finishLogin(data: [String: Any]?, error: Error?) {
        if let handler = self.handler {
            DispatchQueue.main.async {
                handler(data, error)
            }
        }
    }
    
    public func applicationLaunched(withOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        ApplicationDelegate.shared.application(UIApplication.shared, didFinishLaunchingWithOptions: launchOptions)
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        do {
            let handled = try ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            return handled
        } catch let exception as NSException {
            print("{facebook} Exception while processing openurl event: \(exception)")
        }
        return false
    }
}

