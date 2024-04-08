//
//  LoginRadiusSDK.swift
//  LoginRadiusSwiftSDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//




import Foundation
import UIKit

public typealias LRAPIResponseHandler = (_ data: [String: Any]?, _ error: Error?) -> Void
public typealias LRServiceCompletionHandler = (_ success: Bool, _ error: Error?) -> Void

public let LoginRadiusPlistFileName = "LoginRadius"
public let LoginRadiusAPIKey = "apiKey"
public let LoginRadiusRegistrationSource = "registrationSource"
public let LoginRadiusCustomHeaders = "customHeaders"
public let LoginRadiusSiteName = "siteName"
public let LoginRadiusVerificationUrl = "verificationUrl"
public let LoginRadiusKeychain = "useKeychain"
public let LoginRadiusCustomDomain = "customDomain"
public let LoginRadiusSetEncryption = "setEncryption"

public class LoginRadiusSDK {
    public static let sharedInstance = LoginRadiusSDK()
    public var apiKey: String
    public var registrationSource: String
    public var customHeaders: [String: Any]
    public var siteName: String
    public var verificationUrl: String
    public var useKeychain: Bool
    public var customDomain: String
    public var setEncryption: Bool
    public var socialLoginManager: LoginRadiusSocialLoginManager
    public var biometricManager: LRBiometrics
    public var session: LRSession
    
    public init() {
        let path = Bundle.main.path(forResource: LoginRadiusPlistFileName, ofType: "plist")
        let values = NSDictionary(contentsOfFile: path!) as! [String: Any]
        apiKey = values[LoginRadiusAPIKey] as! String
        registrationSource = values[LoginRadiusRegistrationSource] as? String ?? "iOS"
        
        customHeaders = values[LoginRadiusCustomHeaders] as? [String: Any] ?? [:]
        
        siteName = values[LoginRadiusSiteName] as! String
        verificationUrl = values[LoginRadiusVerificationUrl] as? String ?? "https://auth.lrcontent.com/mobile/verification/index.html"
        useKeychain = values[LoginRadiusKeychain] as? Bool ?? false
        customDomain = values[LoginRadiusCustomDomain] as? String ?? ""
        setEncryption = values[LoginRadiusSetEncryption] as? Bool ?? false
        
        assert(apiKey != "<Your LoginRadius ApiKey>" && !apiKey.isEmpty, "apiKey or siteName cannot be null in LoginRadius.plist")
        assert(siteName != "", "siteName cannot be null in LoginRadius.plist")
        assert(apiKey != "", "apiKey cannot be null in LoginRadius.plist")
        
        
        session = LRSession()
        socialLoginManager = LoginRadiusSocialLoginManager()
        biometricManager = LRBiometrics()
        customHeaders = values[LoginRadiusCustomHeaders] as? [String: Any] ?? [:]
        
        
        if setEncryption {
            let key = apiKey.data(using: .utf8)!
            let decr = LoginRadiusEncryptor.sharedInstance.encryptDecryptText(data: key)
            let myString = String(data: decr, encoding: .ascii)
        }
    }
    
    public static func logout() -> Bool {
        let isLoggedOut = (self.sharedInstance.session as! LRSession).logout()
        LoginRadiusSocialLoginManager.sharedInstance.logout()
        
        let storage = HTTPCookieStorage.shared
        for cookie in storage.cookies ?? [] {
            storage.deleteCookie(cookie)
        }
        
        return isLoggedOut
    }
    
    public static func apiKey() -> String {
        return LoginRadiusSDK.sharedInstance.apiKey
        
    }
    
    public static func registrationSource() -> String {
        return LoginRadiusSDK.sharedInstance.registrationSource
    }
    
    public static func siteName() -> String {
        return LoginRadiusSDK.sharedInstance.siteName
    }
    
    public static func verificationUrl() -> String {
        return LoginRadiusSDK.sharedInstance.verificationUrl
        
    }
    
    public static func customDomain() -> String {
        return LoginRadiusSDK.sharedInstance.customDomain
    }
    
    public static func useKeychain() -> Bool {
        return LoginRadiusSDK.sharedInstance.useKeychain
    }
    
    public static func customHeaders() -> [String: Any] {
        return LoginRadiusSDK.sharedInstance.customHeaders
    }
    
    public static func setEncryption() -> Bool {
        return LoginRadiusSDK.sharedInstance.setEncryption
    }
    
    // MARK: Application Delegate methods
    
    public func applicationLaunchedWithOptions(_ launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        LoginRadiusSocialLoginManager.sharedInstance.applicationLaunched(withOptions: launchOptions)
    }
    
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return LoginRadiusSocialLoginManager.sharedInstance.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
    }
}
