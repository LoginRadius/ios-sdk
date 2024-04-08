//
//  LoginRadiusSchema.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation

public class LoginRadiusSchema {
    public static let sharedInstance = LoginRadiusSchema()
    
    public var fields: [LoginRadiusField]?
    public var providers: [LoginRadiusField]?
    
    public init() {}
    
    public func setWithArrayOfDictionary(_ array: [Any]) {
        var newFields = [LoginRadiusField]()
        
        for fieldDict in array {
            if let fieldDict = fieldDict as? [String: Any] {
                var fieldFormatted = fieldDict.replaceNullWithBlank()
                let newField = LoginRadiusField(dictionary: fieldFormatted)
                newFields.append(newField)
            }
        }
        
        fields = newFields
    }
    
    public func setSchema(_ data: [String: Any]) {
        if let socialSchema = data["SocialSchema"] as? [String: Any], let providersObj = socialSchema["Providers"] as? [[String: Any]] {
            var providersItems = [LoginRadiusField]()
            
            for providersDictionary in providersObj {
                let providersItem = LoginRadiusField(socialSchema:providersDictionary)
                providersItems.append(providersItem)
            }
            
            providers = providersItems
        }
        
        if let registrationFormSchema = data["RegistrationFormSchema"] as? [[String: Any]] {
            var newFields = [LoginRadiusField]()
            
            for fieldDict in registrationFormSchema {
                var rules = fieldDict
                if let dtc = rules["rules"] as? String, dtc.contains("custom_validation") {
                    rules["rules"] = ""
                }
                
                var fieldFormatted = rules.replaceNullWithBlank()
                let newField = LoginRadiusField(dictionary: fieldFormatted)
                newFields.append(newField)
            }
            
            fields = newFields
        }
    }
    
    public func checkRequiredFieldsWithSchema(schema: [String: Any], profile: [String: Any], completionHandler completion: @escaping LRAPIResponseHandler) {
        
        guard let registrationSchemaDictionaries = schema["RegistrationFormSchema"] as? [[String: Any]] else {
            return
        }
        
        let lowercasedProfile = profile.dictionaryWithLowercaseKeys()
        
        var items: [[String: Any]] = []
        
        for field in registrationSchemaDictionaries {
            guard let fName = (field["name"] as? String)?.lowercased(),
                  let fRules = (field["rules"] as? String)?.lowercased(),
                  (fRules == "required" || fRules.hasPrefix("required|") || fRules == "valid_email|required") else {
                continue
            }
            
            var miss = 0
            
            if (lowercasedProfile[fName] as? NSNull != nil && fName != "emailid" && !fName.hasPrefix("cf")) || (lowercasedProfile[fName] as? String == "" && fName != "emailid" && !fName.hasPrefix("cf")) {
                miss = 1
            }
            
            if (fName == "phonenumber" && (lowercasedProfile["phonenumbers"] as? NSNull != nil)) || (fName == "phonenumber" && (lowercasedProfile["phonenumbers"] as? String == "")) {
                miss = 1
            }
            
            if (fName == "phonetype" && (lowercasedProfile["phonenumbers"] as? NSNull != nil)) || (fName == "phonetype" && (lowercasedProfile["phonenumbers"] as? String == "")) {
                miss = 1
            }
            
            if (fName == "emailsubscription" && (lowercasedProfile["subscription"] as? NSNull != nil)) || (fName == "emailsubscription" && (lowercasedProfile["subscription"] as? String == "")) {
                miss = 1
            }
            
            let email = (lowercasedProfile["emailverified"] as? Bool) ?? false
            if fName == "emailid" && !email {
                miss = 1
            }
            
            let phone = (lowercasedProfile["phoneidverified"] as? Bool) ?? false
            if fName == "phoneid" && !phone {
                miss = 1
            }
            
            if fName.hasPrefix("cf") && (lowercasedProfile["customfields"] as? NSNull != nil) {
                miss = 1
            } else if fName.hasPrefix("cf"), let customFields = lowercasedProfile["customfields"] as? [String: Any] {
                var customField = fName
                customField.removeFirst(3)
                if customFields[customField] == nil || (customFields[customField] as? String == "") {
                    miss = 1
                    
                }else if fName.hasPrefix("cf"), let customFields = lowercasedProfile["customfields"] as? [String: Any], customFields.isEmpty {
                    miss = 1
                }
                
                if miss > 0 && miss == 1 {
                    var dict: [String: Any] = [:]
                    dict["name"] = field["name"]
                    dict["Checked"] = field["Checked"]
                    dict["type"] = field["type"]
                    dict["display"] = field["display"]
                    dict["rules"] = field["rules"]
                    dict["options"] = field["options"]
                    dict["permission"] = field["permission"]
                    dict["DataSource"] = field["DataSource"]
                    dict["Parent"] = field["Parent"]
                    dict["ParentDataSource"] = field["ParentDataSource"]
                    items.append(dict)
                }
            }
            
            if items.count > 0 {
                setWithArrayOfDictionary(items)
                var dict: [String: Any] = [:]
                dict["MissingRequiredFields"] = items
                completion(dict, LRErrors.userProfileRequireAdditionalFields())
                return
            }
            
            var noMissing: [String: Any] = [:]
            var noItems: [[String: Any]] = []
            noMissing["NoFields"] = noItems
            completion(noMissing, nil)
        }
    }
}
