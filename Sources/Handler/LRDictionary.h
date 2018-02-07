//
//  LRDictionary
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSDictionary (LRDictionary)

- (NSString *)queryString;

+ (NSDictionary *)dictionaryWithQueryString: (NSString *)queryString;

- (NSDictionary *) dictionaryWithLowercaseKeys;

@end
