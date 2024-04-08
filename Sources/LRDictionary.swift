//
//  LRDictionary.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//


import Foundation

public extension Dictionary where Key == String, Value == Any {
    var queryString: String {
        var queryString = ""
        var isFirstKey = true
        
        for (key, value) in self {
            if let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                if isFirstKey {
                    queryString.append("?")
                    isFirstKey = false
                } else {
                    queryString.append("&")
                }
                queryString.append("\(encodedKey)=\(encodedValue)")
            }
        }
        
        return queryString
    }
    
    public static func dictionaryWithQueryString(_ queryString: String) -> [String: Any] {
        if queryString.isEmpty {
            return [:]
        }
        
        var dictionary: [String: Any] = [:]
        let pairs = queryString.components(separatedBy: "&")
        
        for pair in pairs {
            let elements = pair.components(separatedBy: "=")
            if elements.count == 2 {
                let key = elements[0]
                let value = elements[1]
                if let decodedKey = key.removingPercentEncoding,
                   let decodedValue = value.removingPercentEncoding {
                    dictionary[decodedKey] = decodedValue
                }
            }
        }
        
        return dictionary
    }
    
    public func dictionaryWithLowercaseKeys() -> [String: Any] {
        var result: [String: Any] = [:]
        
        for (key, value) in self {
            if let valueArray = value as? [Any] {
                let lowercasedArray = lowercaseKeysAllDictionariesInArray(valueArray)
                result[key.lowercased()] = lowercasedArray
            } else if let valueDict = value as? [String: Any] {
                let lowercasedDict = valueDict.dictionaryWithLowercaseKeys()
                result[key.lowercased()] = lowercasedDict
            } else {
                result[key.lowercased()] = value
            }
        }
        
        return result
    }
    
    public func lowercaseKeysAllDictionariesInArray(_ array: [Any]) -> [Any] {
        var result: [Any] = []
        
        for item in array {
            if let itemArray = item as? [Any] {
                let lowercasedArray = lowercaseKeysAllDictionariesInArray(itemArray)
                result.append(lowercasedArray)
            } else if let itemDict = item as? [String: Any] {
                let lowercasedDict = itemDict.dictionaryWithLowercaseKeys()
                result.append(lowercasedDict)
            } else {
                result.append(item)
            }
        }
        
        return result
    }
}
