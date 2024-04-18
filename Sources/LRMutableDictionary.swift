//
//  LRMutableDictionary.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//

import Foundation


public extension Dictionary where Key == String, Value: Any {
    
    public func replaceNullWithBlank() -> [Key: Any] {
        var replaced = self
        
        for (key, value) in self {
            if value is NSNull {
                replaced[key] = ("" as! Value)
            } else if let dictionary = value as? [Key: Any] {
                replaced[key] = (dictionary.replaceNullWithBlank() as! Value)
            } else if let array = value as? [Any] {
                let newArray = array.map { item -> Any in
                    if let dict = item as? [Key: Any] {
                        return dict.replaceNullWithBlank()
                    } else if item is NSNull {
                        return ""
                    }
                    return item
                }
                replaced[key] = (newArray as! Value)
            }
        }
        
        return replaced
    }
}
