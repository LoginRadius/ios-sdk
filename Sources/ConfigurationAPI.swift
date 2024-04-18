//
//  ConfigurationAPI.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

public class ConfigurationAPI {
    
    public static let shared = ConfigurationAPI()
    public static let configInstance = ConfigurationAPI.shared
    public init() {}
    
    public func getConfigurationSchema(completion: @escaping (LRAPIResponseHandler)) {
        
        
        LoginRadiusREST.configInstance.sendGET(url: "ciam/appInfo", queryParams: ["apikey": LoginRadiusSDK.sharedInstance.apiKey], completionHandler: completion)
        
    }
}
