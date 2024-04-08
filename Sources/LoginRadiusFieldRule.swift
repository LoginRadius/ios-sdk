//
//  LoginRadiusFieldRuleType.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//


import Foundation


public enum LoginRadiusFieldRuleType {
    case unknown
    case alpha_dash
    case exact_length
    case matches
    case max_length
    case min_length
    case numeric
    case required
    case valid_ca_zip
    case valid_email
    case valid_ip
    case valid_url
    case valid_date
    case custom_validation
}

public class LoginRadiusFieldRule {
    public var type: LoginRadiusFieldRuleType = .unknown
    public var regex: String?
    public var intValue: Int?
    public var stringValue: String?
    
    public init(ruleStr: String) {
        self.type = setTypeWithString(ruleStr)
    }
    
    public func setTypeWithString(_ ruleStr: String) -> LoginRadiusFieldRuleType {
        var fieldType: LoginRadiusFieldRuleType = .unknown
        
        if ruleStr.hasPrefix("alpha_dash") {
            fieldType = .alpha_dash
            regex = "^[a-zA-Z0-9_-]+$"
        } else if ruleStr.hasPrefix("exact_length") {
            fieldType = .exact_length
            intValue = Int(extractSquareBracketInformation(ruleStr: ruleStr))
        } else if ruleStr.hasPrefix("matches") {
            fieldType = .matches
            stringValue = extractSquareBracketInformation(ruleStr: ruleStr)
        } else if ruleStr.hasPrefix("max_length") {
            fieldType = .max_length
            intValue = Int(extractSquareBracketInformation(ruleStr: ruleStr))
        } else if ruleStr.hasPrefix("min_length") {
            fieldType = .min_length
            intValue = Int(extractSquareBracketInformation(ruleStr: ruleStr))
        } else if ruleStr.hasPrefix("numeric") {
            fieldType = .numeric
            regex = "^[0-9]+$"
        } else if ruleStr.hasPrefix("required") {
            fieldType = .required
        } else if ruleStr.hasPrefix("valid_ca_zip") {
            fieldType = .valid_ca_zip
            regex = "^[ABCEGHJKLMNPRSTVXY]{1}\\d{1}[A-Z]{1} *\\d{1}[A-Z]{1}\\d{1}$"
        } else if ruleStr.hasPrefix("valid_email") {
            fieldType = .valid_email
            regex = "\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$"
        } else if ruleStr.hasPrefix("valid_ip") {
            fieldType = .valid_ip
            regex = "^((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\\.){3}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})$"
        } else if ruleStr.hasPrefix("valid_url") {
            fieldType = .valid_url
            regex = "^((http|https):\\/\\/(\\w+:{0,1}w*@)?(\\S+)|)(:[0-9]+)?(\\/|\\/([\\w#!:.?+=&%@!\\-\\/]))?$"
        } else if ruleStr.hasPrefix("valid_date") {
            fieldType = .valid_date
        } else if ruleStr.hasPrefix("custom_validation") {
            fieldType = .custom_validation
            let customRule = extractSquareBracketInformation(ruleStr: ruleStr)
            let divider = customRule.range(of: "###")!
            let midPoint = divider.upperBound
            do{
                regex = try customRule.substring(with: customRule.startIndex..<divider.lowerBound)
                stringValue = try customRule.substring(with: midPoint..<customRule.endIndex)
            } catch {
                // User inputs their own regex schema, should notify without debug
                print("Invalid Custom Regex")
            }
        }
        
        return fieldType
    }
    
    public func extractSquareBracketInformation(ruleStr: String) -> String {
        var range = ruleStr.range(of: "[")!
        range = range.upperBound..<ruleStr.endIndex
        let rangeBack = ruleStr.range(of: "]", options: .backwards)!
        let substring = ruleStr[range.lowerBound..<rangeBack.lowerBound]
        return String(substring)
    }
    
    public var description: String {
        return "<LoginRadiusFieldRule, type: \(typeToString), intValue: \(intValue ?? 0), stringValue: \(stringValue ?? ""), regexValue: \(regex ?? "")>"
    }
    
    public var typeToString: String {
        switch type {
        case .unknown: return "unknown"
        case .alpha_dash: return "alpha_dash"
        case .exact_length: return "exact_length"
        case .matches: return "matches"
        case .max_length: return "max_length"
        case .min_length: return "min_length"
        case .numeric: return "numeric"
        case .required: return "required"
        case .valid_ca_zip: return "valid_ca_zip"
        case .valid_email: return "valid_email"
        case .valid_ip: return "valid_ip"
        case .valid_url: return "valid_url"
        case .valid_date: return "valid_date"
        case .custom_validation: return "custom_validation"
        }
    }
}
