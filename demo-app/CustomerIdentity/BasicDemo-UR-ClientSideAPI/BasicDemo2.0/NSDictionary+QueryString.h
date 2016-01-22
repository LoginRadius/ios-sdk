//
//  NSDictionary+QueryString.h
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-08.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (QueryString)

/**
 * A helper function which seperates the pairs from return URL string
 * into Objects
 *
 * @param queryString The query parameters to parse
 *
 * @returns A new dictionary containing the specified query parameters
 */

+ (NSDictionary *)dictionaryWithQueryString: (NSString *)queryString;

/**
 * Returns the dictionary as a query string 
 */

- (NSString *)queryStringValue;

@end
