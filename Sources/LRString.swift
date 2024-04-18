//
//  LRString.swift
//  LoginRadiusSwift SDK
//
//  Created by Megha Agarwal.
//  Copyright © 2023 LoginRadius Inc. All rights reserved.
//


import Foundation

public extension String {
    
    func URLDecodedString() -> String? {
        return self.removingPercentEncoding
    }
    
    func URLEncodedString() -> String? {
        let allowedSet = CharacterSet(charactersIn: ":!*();@/&?#[]+$,='%’\"").inverted
        return self.addingPercentEncoding(withAllowedCharacters: allowedSet)
    }
    
    func capitalizedFirst() -> String {
        return self.replacingCharacters(in: self.startIndex..<self.index(after: self.startIndex), with: String(self[self.startIndex]).uppercased())
    }
    
}
