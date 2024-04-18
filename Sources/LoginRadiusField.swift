
//
//  LoginRadiusField.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public enum LoginRadiusFieldType {
    case string
    case option
    case multi
    case password
    case hidden
    case email
    case text
    case date
}

public enum LoginRadiusFieldPermission {
    case read
    case write
}

public class LoginRadiusField {
    public var type: LoginRadiusFieldType = .hidden
    public var name: String
    public var display: String
    public var option: [String: String]?
    public var permission: LoginRadiusFieldPermission
    public var rules: [LoginRadiusFieldRule]?
    public var isRequired: Bool {
        return rules?.contains { $0.type == .required } ?? false
    }
    public var endpoint: String?
    public  var providerName: String?
    
    public init(dictionary: [String: Any]) {
        self.type = .hidden
        self.name = ""
        self.display = ""
        self.permission = .read
        
        if let typeString = dictionary["type"] as? String {
            self.type = setTypeWithString(fieldString: typeString)
        }
        
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let display = dictionary["display"] as? String {
            self.display = display
        }
        
        if let permissionString = dictionary["permission"] as? String {
            self.permission = (permissionString == "w") ? .write : .read
        }
        
        if let options = dictionary["options"] as? [[String: Any]], self.type == .option {
            self.option = initializeOptions(options: options)
        }
        if let rulesString = dictionary["rules"] as? String {
            self.rules = initializeRules(fullRuleStr: rulesString)
        }
    }
    
    public init(socialSchema: [String: Any]) {
        self.type = .hidden
        self.name = ""
        self.display = ""
        self.permission = .read
        
        if let endpoint = socialSchema["Endpoint"] as? String {
            self.endpoint = endpoint
        }
        
        if let providerName = socialSchema["Name"] as? String {
            self.providerName = providerName
        }
    }
    
    public static func addressFields() -> [String] {
        return ["address1", "address2", "city", "country", "postalcode", "region", "state"]
    }
    
    func setTypeWithString(fieldString: String) -> LoginRadiusFieldType {
        switch fieldString {
        case "string": return .string
        case "option": return .option
        case "multi": return .multi
        case "password": return .password
        case "hidden": return .hidden
        case "email": return .email
        case "text": return .text
        case "date": return .date
        default: return .hidden
        }
    }
    
    public func initializeOptions(options: [[String: Any]]) -> [String: String] {
        var newOptions = [String: String]()
        for option in options {
            if let value = option["value"] as? String, let text = option["text"] as? String {
                newOptions[value] = text
            }
        }
        return newOptions
    }
    
    func initializeRules(fullRuleStr: String) -> [LoginRadiusFieldRule]? {
        // If nil or empty string
        if fullRuleStr.isEmpty {
            return nil
        }
        
        var rules = [LoginRadiusFieldRule]()
        var mutableFullRuleStr = fullRuleStr // Create a mutable copy of the input string
        
        // This is to avoid custom validation regex that contains "|"
        var customValidation: String? = nil
        
        if mutableFullRuleStr.contains("custom_validation") {
            if let start = mutableFullRuleStr.range(of: "custom_validation[") {
                let startIndex = start.upperBound
                var openSquares = 0
                
                // Iterate through the content of custom_validation[.... until it finds the ] pair
                var currentIndex = startIndex
                while openSquares >= 0 && currentIndex < mutableFullRuleStr.endIndex {
                    let currentChar = mutableFullRuleStr[currentIndex]
                    if currentChar == "[" {
                        openSquares += 1
                    } else if currentChar == "]" {
                        openSquares -= 1
                    }
                    
                    currentIndex = mutableFullRuleStr.index(after: currentIndex)
                }
                
                assert(openSquares == -1, "Invalid Custom Regex")
                customValidation = String(mutableFullRuleStr[start.lowerBound..<currentIndex])
                
                // Delete it from the fullRuleStr with an empty string
                mutableFullRuleStr.replaceSubrange(start.lowerBound..<currentIndex, with: "")
            }
        }
        
        var rulesStr = mutableFullRuleStr.components(separatedBy: "|")
        
        if let customValidation = customValidation {
            rulesStr = rulesStr.filter { !$0.isEmpty }
            rulesStr.append(customValidation)
        }
        
        for ruleStr in rulesStr {
            let newRule = LoginRadiusFieldRule(ruleStr: ruleStr)
            if newRule.type == .valid_date {
                type = .date // This line appears to be problematic; please review it
            }
            rules.append(LoginRadiusFieldRule(ruleStr: ruleStr))
        }
        
        return rules
    }
    
    
    public  var description: String {
        var lrFieldStr = "<LoginRadiusField, type: \(typeToString), name: \(name), display: \(display), required: \(isRequired ? "YES" : "NO")"
        if let option = option {
            lrFieldStr += ", option: \(option)"
        }
        lrFieldStr += ">"
        return lrFieldStr
    }
    
    public func typeToString() -> String {
        switch type {
        case .string: return "string"
        case .option: return "option"
        case .multi: return "multi"
        case .password: return "password"
        case .hidden: return "hidden"
        case .email: return "email"
        case .text: return "text"
        case .date: return "date"
        }
    }
}
