//
//  LoginRadiusError.swift
//  LoginRadiusSwift SDK
//  Created by Megha Agarwal.
// Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

public let LoginRadiusDomain = "com.loginradius"

extension NSError {
    public static func error(withCode code: Int, description: String, failureReason: String) -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: description,
            NSLocalizedFailureReasonErrorKey: failureReason
        ]
        return NSError(domain: LoginRadiusDomain, code: code, userInfo: userInfo)
    }
}
