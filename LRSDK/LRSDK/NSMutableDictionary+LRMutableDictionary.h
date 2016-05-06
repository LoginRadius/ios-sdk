//
//  LRMutableDictionary
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
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
