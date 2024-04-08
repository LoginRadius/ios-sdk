//
//  LoginRadiusREST.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//


import Foundation


public let errorCode = "errorcode"
public let isProviderError = "isprovidererror"
public let description = "description"
public let providerErrorResponse = "providererrorresponse"
public let message = "message"

public enum BASE_URL_ENUM: Int {
    case API
    case CONFIG
}
public func BASE_URL_STRING(_ enumValue: BASE_URL_ENUM) -> String {
    let urls = ["https://api.loginradius.com/", "https://config.lrcontent.com/"]
    return urls[enumValue.rawValue]
}


public class LoginRadiusREST {
    
    public static let apiInstance = LoginRadiusREST(baseUrlEnum: .API)
    public static let configInstance = LoginRadiusREST(baseUrlEnum: .CONFIG)
    
    public var baseURL: URL
    
    public init(baseUrlEnum: BASE_URL_ENUM) {
        self.baseURL = URL(string: BASE_URL_STRING(baseUrlEnum))!
        let stringUrl = self.baseURL.absoluteString
        if !LoginRadiusSDK.sharedInstance.customDomain.isEmpty && stringUrl.contains("api") {
            self.baseURL = URL(string: LoginRadiusSDK.sharedInstance.customDomain)!
        }
    }
    
    
    convenience init() {
        self.init(baseUrlEnum: .API)
    }
    
    
    public func sendGET(url: String, queryParams: Any?, completionHandler: @escaping (LRAPIResponseHandler)) {
        
        var access_token: String?
        var queryParameters = queryParams as? [String: Any] ?? [:]
        
        if let accessToken = queryParameters["access_token"], url.range(of: "/auth") != nil {
            access_token = accessToken as? String
            queryParameters.removeValue(forKey: "access_token")
        }
        
        let urlString = baseURL.absoluteString + (queryParameters.isEmpty ? url : (url + queryParameters.queryString))
        if let requestUrl = URL(string: urlString) {
            var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
            
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let providedCustomHeaders = LoginRadiusSDK.customHeaders()
            for (header, value) in providedCustomHeaders {
                request.addValue(value as! String, forHTTPHeaderField: header)
            }
            
            if let token = access_token {
                let tokenValue = "Bearer " + token
                request.addValue(tokenValue, forHTTPHeaderField: "Authorization")
            }
            
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (data, response, error) in
                if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                    if let data = data {
                        do{
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                                              var dict = [String: Any]()
                                                dict["Data"] = jsonArray
                                                completionHandler(dict, nil)
                                            } else if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                                completionHandler(jsonDictionary, nil)
                                            }
                            } catch {
                                completionHandler(nil, error)
                            }
                        } else {
                            completionHandler(nil, self.convertError(data: data!, response: response!))
                        }
                    }
                    
                    else{
                        completionHandler(nil, self.convertError(data: data!, response: response!))
                    }
                }
                    
                    task.resume()
                }
            }
        
    
    
    public func sendPOST(url: String, queryParams: Any?, body: Any?, completionHandler: @escaping (LRAPIResponseHandler))
    {
        var queryParameters = queryParams as? [String: Any] ?? [:]
        var sott: String?
        var access_token: String?
        var registrationsource: String?
        
        var error: Error?
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) else {
            completionHandler(nil, error)
            return
        }
        
        if let sottValue = queryParameters["sott"] as? String {
            sott = sottValue
            queryParameters.removeValue(forKey: "sott")
        } else if let accessTokenValue = queryParameters["access_token"] as? String, url.range(of: "/auth") != nil {
            access_token = accessTokenValue
            queryParameters.removeValue(forKey: "access_token")
        }
        
        if let registrationSourceValue = queryParameters["registrationsource"] as? String, !registrationSourceValue.isEmpty {
            registrationsource = registrationSourceValue
            queryParameters.removeValue(forKey: "registrationsource")
        }
        
        let requestUrlString = baseURL.absoluteString + (queryParameters.isEmpty ? url : url + queryParameters.queryString)
        guard let requestUrl = URL(string: requestUrlString) else {
            completionHandler(nil, error)
            return
        }
        
        var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData.count)", forHTTPHeaderField: "Content-length")
        if let sottValue = sott {
            request.addValue(sottValue, forHTTPHeaderField: "X-LoginRadius-Sott")
        } else if let accessTokenValue = access_token {
            let token = "Bearer \(accessTokenValue)"
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        if let registrationsourceValue = registrationsource {
            request.addValue(registrationsourceValue, forHTTPHeaderField: "Referer")
        }
        
        let providedCustomHeaders = LoginRadiusSDK.customHeaders()
        if !providedCustomHeaders.isEmpty {
            for (headerField, headerValue) in providedCustomHeaders {
                request.addValue(headerValue as! String, forHTTPHeaderField: headerField)
            }
        }
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                completionHandler(nil, error)
                return
            }
            
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                            var dict = [String: Any]()
                            dict["Data"] = jsonArray
                            completionHandler(dict, nil)
                        } else if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            completionHandler(jsonDictionary, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                }
            } else {
                if let data = data {
                    let error = self.convertError(data: data, response: response!)
                    completionHandler(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    public func sendPUT(url: String, queryParams: Any?, body: Any?, completionHandler: @escaping (LRAPIResponseHandler)) {
        var access_token: String?
        var queryParameters = (queryParams as? [String: Any]) ?? [:]
        var jsonData: Data?
        var error: Error?
        
        if let body = body {
            jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        
        if let accessToken = queryParameters["access_token"] as? String, url.range(of: "/auth") != nil {
            access_token = accessToken
            queryParameters.removeValue(forKey: "access_token")
        }
        
        let requestUrlString = baseURL.absoluteString + (queryParameters.isEmpty ? url : url + queryParameters.queryString)
        guard let requestUrl = URL(string: requestUrlString) else {
            completionHandler(nil, error)
            return
        }
        
        var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData?.count ?? 0)", forHTTPHeaderField: "Content-length")
        
        if let accessToken = access_token {
            let token = "Bearer \(accessToken)"
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let providedCustomHeaders = LoginRadiusSDK.customHeaders()
        
        if providedCustomHeaders.count > 0 {
            for (header, value) in providedCustomHeaders {
                request.addValue(value as! String, forHTTPHeaderField: header)
            }
        }
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        if let jsonArray = jsonObject as? [Any] {
                            var dict = [String: Any]()
                            dict["Data"] = jsonArray
                            completionHandler(dict, nil)
                        } else if let jsonDictionary = jsonObject as? [String: Any] {
                            completionHandler(jsonDictionary, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, nil)
                }
            } else {
                completionHandler(nil, self.convertError(data: data!, response: response!))
            }
        }
        
        task.resume()
    }
    
    
    public func sendDELETE(url: String, queryParams: Any?, body: Any?, completionHandler: @escaping (LRAPIResponseHandler)) {
        var access_token: String?
        var queryParameters = (queryParams as? [String: Any]) ?? [:]
        var jsonData: Data?
        var error: Error?
        
        if let body = body {
            jsonData = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        }
        
        if let accessToken = queryParameters["access_token"] as? String, url.range(of: "/auth") != nil {
            access_token = accessToken
            queryParameters.removeValue(forKey: "access_token")
        }
        let requestUrlString = baseURL.absoluteString + (queryParameters.isEmpty ? url : url + queryParameters.queryString)
        let requestUrl = URL(string: requestUrlString)
        
        
        var request = URLRequest(url: requestUrl!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(jsonData?.count ?? 0)", forHTTPHeaderField: "Content-length")
        
        if let accessToken = access_token {
            let token = "Bearer \(accessToken)"
            request.addValue(token, forHTTPHeaderField: "Authorization")
        }
        
        let providedCustomHeaders = LoginRadiusSDK.customHeaders()
        
        if providedCustomHeaders.count > 0 {
            for (header, value) in providedCustomHeaders {
                request.addValue(value as! String, forHTTPHeaderField: header)
            }
        }
        
        request.httpBody = jsonData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                        
                        if let jsonArray = jsonObject as? [Any] {
                            var dict = [String: Any]()
                            dict["Data"] = jsonArray
                            
                            completionHandler(dict, nil)
                            
                        } else if let jsonDictionary = jsonObject as? [String: Any] {
                            completionHandler(jsonDictionary, nil)
                        }
                    } catch {
                        completionHandler(nil, error)
                    }
                } else {
                    completionHandler(nil, nil)
                }
            } else {
                completionHandler(nil, self.convertError(data: data!, response: response!))
            }
        }
        
        task.resume()
    }
    public func convertError(data: Data, response: URLResponse) -> NSError {
        var loginRadiusError: NSError?
        
        guard let httpResponse = response as? HTTPURLResponse else {
            return NSError(domain: "Invalid response", code: 0, userInfo: nil)
        }
        
        if httpResponse.statusCode == 0 {
            loginRadiusError = NSError(domain: "Network error", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong or network not available. Please try again later.", NSLocalizedFailureReasonErrorKey: "Something went wrong. Please try again later."])
        } else {
            do {
                guard let payload = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                    return NSError(domain: "Invalid payload", code: 0, userInfo: nil)
                }
                
                if let errorCode = payload["errorCode"] as? Int {
                    if let isProviderError = payload["isProviderError"] as? Bool, isProviderError {
                        loginRadiusError = NSError(domain: "Provider error", code: errorCode, userInfo: [NSLocalizedDescriptionKey: payload["description"] as? String ?? "", NSLocalizedFailureReasonErrorKey: payload["providerErrorResponse"] as? String ?? ""])
                    } else {
                        loginRadiusError = NSError(domain: "LoginRadius error", code: errorCode, userInfo: [NSLocalizedDescriptionKey: payload["description"] as? String ?? "", NSLocalizedFailureReasonErrorKey: payload["message"] as? String ?? ""])
                    }
                } else {
                    let convertedString = String(data: data, encoding: .utf8) ?? ""
                    if response.mimeType == "application/javascript" {
                        loginRadiusError = NSError(domain: "JavaScript error", code: 0, userInfo: [NSLocalizedDescriptionKey: convertedString, NSLocalizedFailureReasonErrorKey: convertedString])
                    } else {
                        loginRadiusError = NSError(domain: "Unknown error", code: 1, userInfo: [NSLocalizedDescriptionKey: convertedString, NSLocalizedFailureReasonErrorKey: convertedString])
                    }
                }
            } catch {
                let convertedString = String(data: data, encoding: .utf8) ?? ""
                if response.mimeType == "application/javascript" {
                    return NSError(domain: "LoginRadius error", code: 0, userInfo: [NSLocalizedDescriptionKey: convertedString, NSLocalizedFailureReasonErrorKey: convertedString])
                }
            }
        }
        
        return loginRadiusError ?? NSError(domain: "Unknown error", code: 0, userInfo: nil)
    }
    
    public func convertJSONPtoJSON(jsonpData: Data) -> Data? {
        if let jsonString = String(data: jsonpData, encoding: .utf8),
           let range = jsonString.range(of: "("),
           let rangeBack = jsonString.range(of: ")", options: .backwards) {
            let startIndex = range.upperBound
            let endIndex = rangeBack.lowerBound
            let trimmedString = jsonString[startIndex..<endIndex]
            
            if let jsonData = trimmedString.data(using: .utf8) {
                return jsonData
            }
        }
        
        return nil
    }
    
}
