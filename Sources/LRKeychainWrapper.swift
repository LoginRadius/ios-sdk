//
//  LRKeychainWrapper.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation
import UIKit
import Security


let PrivateKeyName = "com.loginradius.private"
let PublicKeyName = "com.loginradius.public"
let CFDict = NSMutableDictionary()

/**
 The LRKeychainWrapper class is using SecureEnclave to generate keys and use them to encrypt/decrypt sensitive data.
 It is an abstraction layer for the iPhone Keychain communication and Secure Enclave.
 It has support for sharing keychain items using Access Group and also for iOS 8 fine grained accesibility over a specific Kyechain Item (Using Access Control).
 The SecurrerEnclave support is only available for iOS 10+, otherwise it will default use Keychain.
 
 */
public class LRKeychainWrapper {
    static var publicKeyBits: NSData?
    static var publicKeyRef: SecKey?
    static var privateKeyRef: SecKey?
    
    let service: String
    let accessGroup: String?
    
    public init(service: String, accessGroup: String? = nil) {
        self.service = service
        self.accessGroup = accessGroup
        
        if #available(iOS 10.0, *) {
            if lookupPublicKeyRef() == nil || lookupPrivateKeyRef() == nil {
                generatePasscodeKeyPair()
            }
        }
    }
    
    public convenience init() {
        let service = Bundle.main.bundleIdentifier ?? ""
        self.init(service: service, accessGroup: nil)
    }
    
    public convenience init(service: String) {
        self.init(service: service, accessGroup: nil)
    }
    
    
    public func dataForKey(key: String) -> NSData? {
        return dataForKey(key: key, promptMessage: nil)
    }
    
    
    
    public func dataForKey(key: String, promptMessage: String?) -> NSData? {
        var d:NSData? = self.dataForKey(key: key, promptMessage: promptMessage, error: nil)!
        return d
    }
    
    
    
    public func dataForKey(key: String, promptMessage: String?, error: NSError?) -> NSData? {
        if key.isEmpty {
            return nil
        }
        
        let query = queryFetchOneByKey(key: key, message: promptMessage)
        var data: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &data)
        if status != errSecSuccess {
            return nil
        }
        
        let dataFound = NSData(data: (data as! NSData) as Data)
        if data != nil {
            //CFRelease(data)
        }
        
        
        var returnData = dataFound
        if #available(iOS 10.0, *) {
            returnData = decryptData(data:dataFound)!
        }
        
        
        return returnData
    }
    
    public func hasValueForKey(key: String) -> Bool {
        if key.isEmpty {
            return false
        }
        
        let query = queryFindByKey(key: key, message: nil)
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    public func setData(data: NSData, forKey key: String) -> Bool {
        return setData(data: data, forKey: key, promptMessage: nil)
    }
    
    public func setData(data: NSData, forKey key: String, promptMessage: String?) -> Bool {
        if key.isEmpty {
            return false
        }
        
        var returnData = data
        if #available(iOS 10.0, *) {
            returnData = encryptData(data:data)!
        }
        
        let query = queryFindByKey(key: key, message: promptMessage)
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        if status == errSecSuccess {
            if returnData != nil {
                let updateQuery = queryUpdateValue(data: returnData as Data, message: promptMessage)
                
                status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
                return status == errSecSuccess
            } else {
                status = SecItemDelete(query as CFDictionary)
                return status == errSecSuccess
            }
        } else {
            let newQuery = queryNewKey(key: key, value: returnData)
            status = SecItemAdd(newQuery as CFDictionary, nil)
            return status == errSecSuccess
        }
    }
    
    public func deleteEntryForKey(key: String) -> Bool {
        if key.isEmpty {
            return false
        }
        
        let deleteQuery = queryFindByKey(key: key, message: nil)
        let status = SecItemDelete(deleteQuery as CFDictionary)
        return status == errSecSuccess
    }
    
    public func clearAll() {
#if !targetEnvironment(simulator)
        let query = queryFindAll()
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(query, &result)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            if let items = result as? [NSDictionary] {
                for item in items {
                    var queryDelete = item.mutableCopy() as! NSMutableDictionary
                    queryDelete[kSecClass] = kSecClassGenericPassword
                    
                    let deleteStatus = SecItemDelete(queryDelete as CFDictionary)
                    
                    if deleteStatus != errSecSuccess {
                        break
                    }
                }
            }
        }
#else
        var queryDelete = baseQuery()
        queryDelete[kSecClass] = kSecClassGenericPassword
        
        let status = SecItemDelete(queryDelete as CFDictionary)
        
        if status != errSecSuccess {
            return
        }
#endif
    }
    
    
    // Query Dictionary Builder methods
    
    public func baseQuery() -> NSMutableDictionary {
        var attributes: [AnyHashable: Any] = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrService as String: self.service
        ]
#if !TARGET_IPHONE_SIMULATOR
        if let accessGroup = self.accessGroup {
            attributes[kSecAttrAccessGroup as String] = accessGroup
        }
#endif
        
        return NSMutableDictionary(dictionary: attributes)
    }
    
    public func queryFindAll() -> NSDictionary {
        var query = baseQuery()
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitAll as String
        return query
    }
    
    public func queryFindByKey(key: String, message: String?) -> NSDictionary {
        assert(key != nil, "Must have a valid non-nil key")
        var query = baseQuery()
        query[kSecAttrAccount as String] = key
#if !TARGET_IPHONE_SIMULATOR
        if let message = message {
            query[kSecUseOperationPrompt as String] = message
        }
#endif
        return query
    }
    
    
    
    public func queryUpdateValue(data: Data, message: String?) -> NSDictionary {
        if let message = message {
            return [
                kSecUseOperationPrompt as String: message,
                kSecValueData as String: data
            ] as NSDictionary
        } else {
            return [
                kSecValueData as String: data
            ] as NSDictionary
        }
    }
    
    public func queryNewKey(key: String, value: NSData) -> NSDictionary {
        var query = baseQuery()
        query[kSecAttrAccount as String] = key
        query[kSecValueData as String] = value
        query[kSecAttrAccessible as String] = kSecAttrAccessibleAlwaysThisDeviceOnly as String
        return query
    }
    
    public func queryFetchOneByKey(key: String, message: String?) -> NSDictionary {
        var query = baseQuery()
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne as String
        query[kSecAttrAccount as String] = key
        return query
    }
    
    public func encryptData(data: NSData?) -> NSData? {
        if data != nil && data!.length > 0 {
            let cipher = SecKeyCreateEncryptedData(LRKeychainWrapper.publicKeyRef!, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, data! as CFData, nil)
            return cipher as NSData?
        } else {
            return nil
        }
    }
    
    public func decryptData(data: NSData?) -> NSData? {
        if data != nil && data!.length > 0 {
            let plainData = SecKeyCreateDecryptedData(LRKeychainWrapper.privateKeyRef!, SecKeyAlgorithm.eciesEncryptionStandardX963SHA256AESGCM, data! as CFData, nil)
            return plainData as NSData?
        } else {
            return nil
        }
    }
    
    // MARK: -   Key related methods
    
    
    // Check if public key exists in keychain
    public func publicKeyExists() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassKey,
            kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
            kSecAttrKeyClass as String: kSecAttrKeyClassPublic,
            kSecReturnAttributes as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        return status == errSecSuccess
    }
    
    // Lookup private key reference in keychain
    public func lookupPrivateKeyRef() -> SecKey? {
        let getPrivateKeyRef = newCFDict
        getPrivateKeyRef.setValue(kSecClassKey, forKey: kSecClass as String)
        getPrivateKeyRef.setValue(kSecAttrKeyClassPrivate, forKey: kSecAttrKeyClass as String)
        getPrivateKeyRef.setValue(PrivateKeyName, forKey: kSecAttrLabel as String)
        getPrivateKeyRef.setValue(kCFBooleanTrue, forKey: kSecReturnRef as String)
        
        var privateKey: CFTypeRef?
        let status = SecItemCopyMatching(getPrivateKeyRef, &privateKey)
        if status == errSecItemNotFound {
            return nil
        }
        
        print("\(privateKey)Private:::::")
        
        return privateKey as! SecKey?
    }
    
    
    // Lookup public key reference in keychain
    public func lookupPublicKeyRef() -> SecKey? {
        if LRKeychainWrapper.publicKeyRef != nil {
            return LRKeychainWrapper.publicKeyRef
        }
        
        let tag = PublicKeyName.data(using: .utf8)
        let keyClass = kSecAttrKeyClassPublic as AnyObject
        
        let queryDict: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeEC,
            kSecAttrApplicationTag: tag!,
            kSecAttrKeyClass: keyClass,
            kSecReturnRef: kCFBooleanTrue
        ]
        
        var publicKey: CFTypeRef?
        let sanityCheck = SecItemCopyMatching(queryDict as CFDictionary, &publicKey)
        if sanityCheck != errSecSuccess {
            print("Error trying to retrieve key from server. sanityCheck: \(sanityCheck)")
        }
        
        return publicKey as! SecKey?
    }
    
    // Generate a passcode key pair
    public func generatePasscodeKeyPair() -> Bool {
        var error: Unmanaged<CFError>?
        let sacObject = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            .privateKeyUsage,
            &error
        )
        
        if error != nil {
            print("Generate key error: \(error!.takeRetainedValue())")
        }
        
        return generateKeyPair(with: sacObject!)
    }
    // Generate a passcode key pair
    public func generateKeyPair(with accessControlRef: SecAccessControl) -> Bool {
        var accessControlDict = newCFDict
#if !TARGET_IPHONE_SIMULATOR
        accessControlDict.setValue(accessControlRef, forKey: kSecAttrAccessControl as String)
#endif
        accessControlDict.setValue(kCFBooleanTrue, forKey: kSecAttrIsPermanent as String)
        accessControlDict.setValue(PrivateKeyName, forKey: kSecAttrLabel as String)
        
        var generatePairRef = newCFDict
#if !TARGET_IPHONE_SIMULATOR
        generatePairRef.setValue(kSecAttrTokenIDSecureEnclave, forKey: kSecAttrTokenID as String)
#endif
        generatePairRef.setValue(kSecAttrKeyTypeEC, forKey: kSecAttrKeyType as String)
        generatePairRef.setValue(256, forKey: kSecAttrKeySizeInBits as String)
        generatePairRef.setValue(accessControlDict, forKey: kSecPrivateKeyAttrs as String)
        
        var publicKey, privateKey: SecKey?
        let status = SecKeyGeneratePair(generatePairRef, &publicKey, &privateKey)
        
        if status != errSecSuccess {
            print("Error trying to retrieve key from server. sanityCheck: \(status)")
            return false
        }
        
        savePublicKey(from: publicKey!)
        return true
    }
    
    // Save public key from reference
    public func savePublicKey(from publicKeyRef: SecKey) -> Bool {
        let tag = PublicKeyName.data(using: .utf8)
        let keyClass = kSecAttrKeyClassPublic as AnyObject
        
        let saveDict: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeEC,
            kSecAttrApplicationTag: tag!,
            kSecAttrKeyClass: keyClass,
            kSecValueData: SecKeyCopyExternalRepresentation(publicKeyRef, nil)!,
            kSecAttrKeySizeInBits: 256,
            kSecAttrEffectiveKeySize: 256,
            kSecAttrCanDerive: kCFBooleanFalse,
            kSecAttrCanEncrypt: kCFBooleanTrue,
            kSecAttrCanDecrypt: kCFBooleanFalse,
            kSecAttrCanVerify: kCFBooleanTrue,
            kSecAttrCanSign: kCFBooleanFalse,
            kSecAttrCanWrap: kCFBooleanTrue,
            kSecAttrCanUnwrap: kCFBooleanFalse
        ]
        
        var sanityCheck: OSStatus = noErr
        sanityCheck = SecItemAdd(saveDict as CFDictionary, nil)
        if sanityCheck != errSecSuccess {
            print("Error trying to retrieve key from server. sanityCheck: \(sanityCheck)")
        }
        
        return publicKeyRef as! Bool
    }
    
    
    
    // Delete public key from keychain
    public func deletePubKey() {
        let deleteKeyQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: kPublicKeyName.data(using: .utf8)!,
            kSecAttrType: kSecAttrKeyTypeEC
        ]
        
        let status = SecItemDelete(deleteKeyQuery as CFDictionary)
        if status != errSecSuccess {
            print("key couldn't be deleted")
        }
    }
    
    
    
    // Delete private key from keychain
    public func deletePrivateKey() {
        let deleteKeyQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: kPrivateKeyName.data(using: .utf8)!,
            kSecAttrType: kSecAttrKeyTypeEC
        ]
        
        let status = SecItemDelete(deleteKeyQuery as CFDictionary)
        if status != errSecSuccess {
            print("key couldn't be deleted")
        }
        
    }
}
