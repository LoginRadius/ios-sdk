//
//  NSString+LRString.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LRString.h"

@implementation NSString (LRString)

- (NSString *) URLDecodedString {
	return [self stringByRemovingPercentEncoding];
}

- (NSString *) URLEncodedString {
    NSMutableCharacterSet *allowedSet = [NSMutableCharacterSet characterSetWithCharactersInString:@":!*();@/&?#[]+$,='%’\""];
    [allowedSet invert];
	return [self stringByAddingPercentEncodingWithAllowedCharacters:[allowedSet copy]];;
}

- (NSString *) capitalizedFirst {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}

@end
