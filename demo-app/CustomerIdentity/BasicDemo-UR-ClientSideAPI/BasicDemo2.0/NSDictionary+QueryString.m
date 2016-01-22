//
//  NSDictionary+QueryString.m
//  BasicDemo2.0
//
//  Created by Lucius Yu on 2014-12-08.
//  Copyright (c) 2014 LoginRadius. All rights reserved.
//

#import "NSDictionary+QueryString.h"
#import "NSString+URLEncoding.h"

@implementation NSDictionary (QueryString)

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs)
    {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        if (elements.count == 2)
        {
            NSString *key = elements[0];
            NSString *value = elements[1];
            NSString *decodedKey = [key URLDecodedString];
            NSString *decodedValue = [value URLDecodedString];
            
            if (![key isEqualToString:decodedKey])
                key = decodedKey;
            
            if (![value isEqualToString:decodedValue])
                value = decodedValue;
            
            [dictionary setObject:value forKey:key];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSString *)queryStringValue
{
    NSMutableArray *pairs = [NSMutableArray array];
    for (NSString *key in [self keyEnumerator])
    {
        id value = [self objectForKey:key];
        NSString *escapedValue = [value URLEncodedString];
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escapedValue]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

@end
