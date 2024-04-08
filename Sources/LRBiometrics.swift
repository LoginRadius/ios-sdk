//
//  LRBiometrics.swift
//  SwiftDemo
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation
import LocalAuthentication

public class LRBiometrics{
    
    public static let sharedInstance = LRBiometrics()
    
    public func checkBiometricAvailability(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available
            completion(true, nil)
        } else {
            // Biometric authentication is not available
            completion(false, error?.localizedDescription)
        }
    }
    
    public func authenticateWithBiometrics(successCompletion: @escaping () -> Void, failureCompletion: @escaping (String) -> Void) {
        let context = LAContext()
        
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Biometric authentication is available
            let localizedReason = "Use TouchID/FaceID to Authenticate"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        successCompletion()
                    } else {
                        // Authentication failed
                        if let error = evaluateError as? LAError {
                            // Handle specific cases, if needed
                            failureCompletion(error.localizedDescription)
                        } else {
                            // General error
                            failureCompletion("Biometric authentication failed")
                        }
                    }
                }
            }
        } else {
            // Biometric authentication is not available
            failureCompletion(error?.localizedDescription ?? "Biometric authentication is not available")
        }
    }
}






