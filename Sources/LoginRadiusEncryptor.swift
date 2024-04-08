//
//  LoginRadiusEncryptor.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public class LoginRadiusEncryptor {
    public static let sharedInstance = LoginRadiusEncryptor()
    
    public init() {}
    
    public func encryptDecryptText(data: Data) -> Data {
        // Encrypt the string.
        let apikey = String(data: data, encoding: .ascii)
        
        let bundleIdentifier = Bundle.main.bundleIdentifier
        let strGroupID = "group.\(bundleIdentifier ?? "")"
        
        let keychainItem = SecEnclaveWrapper()
        
        let encrypted = keychainItem.encryptData(data: (apikey?.data(using: .utf8))!)
        
        let strEncrypted = String(data: encrypted!, encoding: .ascii)
        
        // Decrypt the string.
        let decrypted = keychainItem.decryptData(data: encrypted!)
        let strDecrypted = String(data: decrypted!, encoding: .utf8)
        
        let stringData = strDecrypted!.data(using:.utf8)
        return stringData ?? Data()
    }
}
