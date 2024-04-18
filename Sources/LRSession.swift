//
//  LRSession.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

public class LRSession {
    
    static let sharedInstance = LRSession()
    
    
    public init() {
        
    }
    
    public var accessToken: String? {
        var token: String?
        
        if LoginRadiusSDK.sharedInstance.useKeychain {
            let appIdentifierPrefix = bundleSeedID()
            let groupKey = "\(appIdentifierPrefix).\(LoginRadiusSDK.sharedInstance.siteName)"
            let keychain = LRKeychainWrapper(service: LoginRadiusSDK.siteName(), accessGroup: groupKey)
            
            if let tokenData = keychain.dataForKey(key: "lrAccessToken"){
                token = String(data: tokenData as Data, encoding: .utf8)
            }
        } else{
            let defaults = UserDefaults.standard
            token = defaults.string(forKey: "lrAccessToken")
        }
        
        return token
    }
    
    public var userProfile: [String: Any]? {
        var profile: [String: Any]?
        
        if LoginRadiusSDK.sharedInstance.useKeychain {
            let appIdentifierPrefix = bundleSeedID()
            let groupKey = "\(appIdentifierPrefix).\(LoginRadiusSDK.sharedInstance.siteName)"
            let keychain = LRKeychainWrapper(service: LoginRadiusSDK.siteName(), accessGroup: groupKey)
            if let profileData = keychain.dataForKey(key: "lrUserProfile"){
                profile = NSKeyedUnarchiver.unarchiveObject(with: profileData as Data) as? [String: Any]
            }
        } else {
            let defaults = UserDefaults.standard
            profile = defaults.dictionary(forKey: "lrUserProfile")
        }
        
        return profile
    }
    
    
    
    public init(token: String, userProfile: [String: Any]) {
        
        let defaults = UserDefaults.standard
        let lrUserBlocked = userProfile["IsDeleted"] as? Int ?? 0
        
        if LoginRadiusSDK.useKeychain() {
            // save to keychain
            let appIdentifierPrefix = bundleSeedID()
            let groupKey = "\(appIdentifierPrefix).\(LoginRadiusSDK.sharedInstance.siteName)"
            let keychain = LRKeychainWrapper(service: LoginRadiusSDK.siteName(), accessGroup: groupKey)
            
            if let tokenData = token.data(using: .utf8) {
                keychain.setData(data: tokenData as NSData, forKey: "lrAccessToken")
            }
            if lrUserBlocked == 0 {
                var yes = true
                var no = false
                keychain.setData(data: Data(bytes: &yes, count: MemoryLayout<Bool>.size) as NSData, forKey: "isLoggedIn")
                keychain.setData(data: Data(bytes: &no, count: MemoryLayout<Bool>.size) as NSData, forKey: "lrUserBlocked")
            } else {
                var yes = true
                keychain.setData(data: Data(bytes: &yes, count: MemoryLayout<Bool>.size) as NSData, forKey: "lrUserBlocked")
            }
            var profile = userProfile
            if profile["errorCode"] == nil {
                profile = profile.replaceNullWithBlank()
                if let profileData = try? NSKeyedArchiver.archivedData(withRootObject: profile, requiringSecureCoding: false) {
                    keychain.setData(data: profileData as NSData, forKey: "lrUserProfile")
                }
            }
        }else
        {
            defaults.set(token, forKey: "lrAccessToken")
            
            if lrUserBlocked == 0 {
                defaults.set(true, forKey: "isLoggedIn")
                defaults.set(false, forKey: "lrUserBlocked")
            } else {
                defaults.set(true, forKey: "lrUserBlocked")
            }
            
            var profile = userProfile
            if profile["errorCode"] == nil {
                profile = profile.replaceNullWithBlank()
                defaults.set(profile, forKey: "lrUserProfile")
            }
        }
        
        
    }
    
    
    
    public func logout() -> Bool {
        // if it's already logged out then don't do anything
        // and if the user specifies don't invalidate the access token
        
        if !isLoggedIn() {
            return false
        }
        
        AuthenticationAPI.shared.invalidateAccessToken(accessToken!) { (data, error) in
            if let error = error {
                NSLog("Failed to invalidate LRtoken: \(error.localizedDescription)")
            } else {
#if DEBUG
                NSLog("Successfully invalidate LRToken")
#endif
            }
        }
        
        if LoginRadiusSDK.useKeychain() {
            let appIdentifierPrefix = bundleSeedID()
            let groupKey = "\(appIdentifierPrefix).\(LoginRadiusSDK.siteName())"
            let keychain = LRKeychainWrapper(service: LoginRadiusSDK.siteName(), accessGroup: groupKey)
            
            keychain.deleteEntryForKey(key: "isLoggedIn")
            keychain.deleteEntryForKey(key: "lrAccessToken")
            keychain.deleteEntryForKey(key: "lrUserBlocked")
            keychain.deleteEntryForKey(key: "lrUserProfile")
        } else {
            let lrUserDefault = UserDefaults.standard
            lrUserDefault.removeObject(forKey: "isLoggedIn")
            lrUserDefault.removeObject(forKey: "lrAccessToken")
            lrUserDefault.removeObject(forKey: "lrUserBlocked")
            lrUserDefault.removeObject(forKey: "lrUserProfile")
            UserDefaults.standard.synchronize()
        }
        
        return true
    }
    
    
    public func isLoggedIn() -> Bool {
        var result:Bool = (accessToken != nil && userProfile != nil)
        return result
    }
    
    public func bundleSeedID() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "bundleSeedID",
            kSecAttrService as String: "",
            kSecReturnAttributes as String: kCFBooleanTrue as Any
        ]
        
        var result: AnyObject?
        var status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecItemNotFound {
            status = SecItemAdd(query as CFDictionary, &result)
        }
        
        if status != errSecSuccess {
            return nil
        }
        
        if let accessGroup = (result as? [String: Any])?[kSecAttrAccessGroup as String] as? String,
           let bundleSeedID = accessGroup.components(separatedBy: ".").first {
            return bundleSeedID
        }
        
        return nil
    }
}
