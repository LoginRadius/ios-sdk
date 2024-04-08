//
//  SecEnclaveWrapper.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

let newCFDict = NSMutableDictionary()
let kPrivateKeyName = "com.secenclave.private"
let kPublicKeyName = "com.secenclave.public"


public class SecEnclaveWrapper {
    private static var publicKeyRef: SecKey?
    private static var privateKeyRef: SecKey?
    
    public init() {
        if lookupPublicKeyRef() == nil || lookupPrivateKeyRef() == nil {
            generatePasscodeKeyPair()
        }
    }
    
    public func encryptData(data: Data) -> Data? {
        guard let publicKey = SecEnclaveWrapper.publicKeyRef else {
            return nil
        }
        
        let cipher = SecKeyCreateEncryptedData(publicKey, .eciesEncryptionStandardX963SHA256AESGCM, data as CFData, nil)
        
        return cipher as Data?
    }
    
    public func decryptData(data: Data) -> Data? {
        guard let privateKey = SecEnclaveWrapper.privateKeyRef else {
            return nil
        }
        
        let plainData = SecKeyCreateDecryptedData(privateKey, .eciesEncryptionStandardX963SHA256AESGCM, data as CFData, nil)
        
        return plainData as Data?
    }
    
    public func lookupPublicKeyRef() -> SecKey? {
        if let publicKey = SecEnclaveWrapper.publicKeyRef {
            return publicKey
        }
        
        let tag = kPublicKeyName.data(using: .utf8)
        let keyClass = kSecAttrKeyClassPublic as String
        
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
        
        SecEnclaveWrapper.publicKeyRef = publicKey as! SecKey?
        return SecEnclaveWrapper.publicKeyRef
    }
    
    public func lookupPrivateKeyRef() -> SecKey? {
        if let privateKey = SecEnclaveWrapper.privateKeyRef {
            return privateKey
        }
        
        let getPrivateKeyRef = newCFDict
        getPrivateKeyRef.setValue(kSecClassKey, forKey: kSecClass as String)
        getPrivateKeyRef.setValue(kSecAttrKeyClassPrivate, forKey: kSecAttrKeyClass as String)
        getPrivateKeyRef.setValue(kPrivateKeyName, forKey: kSecAttrLabel as String)
        getPrivateKeyRef.setValue(kCFBooleanTrue, forKey: kSecReturnRef as String)
        
        
        var privateKey: CFTypeRef?
        let status = SecItemCopyMatching(getPrivateKeyRef, &privateKey)
        
        if status == errSecItemNotFound {
            return nil
        }
        
        SecEnclaveWrapper.privateKeyRef = privateKey as! SecKey?
        return SecEnclaveWrapper.privateKeyRef
    }
    
    public func generatePasscodeKeyPair() -> Bool {
        var error: Unmanaged<CFError>?
        let sacObject = SecAccessControlCreateWithFlags(
            kCFAllocatorDefault,
            kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly,
            .privateKeyUsage,
            &error
        )
        
        if let error = error {
            print("Generate key error: \(error)")
            return false
        }
        
        return generateKeyPair(with: sacObject!)
    }
    
    public func generateKeyPair(with accessControlRef: SecAccessControl) -> Bool {
        var accessControlDict = newCFDict
#if !TARGET_IPHONE_SIMULATOR
        accessControlDict.setValue(accessControlRef, forKey: kSecAttrAccessControl as String)
#endif
        accessControlDict.setValue(kCFBooleanTrue, forKey: kSecAttrIsPermanent as String)
        accessControlDict.setValue(kPrivateKeyName, forKey: kSecAttrLabel as String)
        
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
        
        savePublicKeyFromRef(publicKeyRef: publicKey!)
        return true
    }
    
    public func savePublicKeyFromRef(publicKeyRef: SecKey) -> Bool {
        let tag = kPublicKeyName.data(using: .utf8)
        let keyClass = kSecAttrKeyClassPublic as String
        
        let saveDict: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrKeyType: kSecAttrKeyTypeEC,
            kSecAttrApplicationTag: tag!,
            kSecAttrKeyClass: keyClass,
            kSecValueData: SecKeyCopyExternalRepresentation(publicKeyRef, nil)!,
            kSecAttrKeySizeInBits: NSNumber(value: 256),
            kSecAttrEffectiveKeySize: NSNumber(value: 256),
            kSecAttrCanDerive: kCFBooleanFalse,
            kSecAttrCanEncrypt: kCFBooleanTrue,
            kSecAttrCanDecrypt: kCFBooleanFalse,
            kSecAttrCanVerify: kCFBooleanTrue,
            kSecAttrCanSign: kCFBooleanFalse,
            kSecAttrCanWrap: kCFBooleanTrue,
            kSecAttrCanUnwrap: kCFBooleanFalse
        ]
        
        let sanityCheck = SecItemAdd(saveDict as CFDictionary, nil)
        
        if sanityCheck != errSecSuccess {
            print("Error trying to retrieve key from server. sanityCheck: \(sanityCheck)")
        }
        
        return publicKeyRef != nil
    }
    
    public func deletePubKey() {
        let deleteKeyQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: kPublicKeyName.data(using: .utf8)!,
            kSecAttrType: kSecAttrKeyTypeEC
        ]
        
        let status = SecItemDelete(deleteKeyQuery as CFDictionary)
        
        if status != errSecSuccess {
            print("Key couldn't be deleted")
        }
    }
    
    public func deletePrivateKey() {
        let deleteKeyQuery: [CFString: Any] = [
            kSecClass: kSecClassKey,
            kSecAttrApplicationTag: kPrivateKeyName.data(using: .utf8)!,
            kSecAttrType: kSecAttrKeyTypeEC
        ]
        
        let status = SecItemDelete(deleteKeyQuery as CFDictionary)
        
        if status != errSecSuccess {
            print("Key couldn't be deleted")
        }
    }
}
