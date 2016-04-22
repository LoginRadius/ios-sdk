//
//  NSMutableDictionary+LRMutableDictionary.h
//  LR-iOS-SDK-Sample
//
//  Created by Raviteja Ghanta on 19/04/16.
//  Copyright © 2016 LR. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (LRMutableDictionary)
/*!
 @function replaceNullWithBlank
 @brief Extend NSMutableDictionary, replace self <null> values with blank string @""
 @return self
 */
- (NSMutableDictionary *) replaceNullWithBlank;

@end
