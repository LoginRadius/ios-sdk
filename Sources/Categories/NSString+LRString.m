//
//  NSString+LRString.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "NSString+LRString.h"

@implementation NSString (LRString)

- (NSString *) URLDecodedString {
	__autoreleasing NSString *decodedString;
	decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
																										  NULL,
																										  (__bridge CFStringRef)self,
																										  CFSTR(""),
																										  kCFStringEncodingUTF8
																										  );
	return decodedString;
}

- (NSString *) URLEncodedString {
	__autoreleasing NSString *encodedString;
	encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
																						  NULL,
																						  (__bridge CFStringRef)self,
																						  NULL,
																						  (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
																						  kCFStringEncodingUTF8
																						  );
	return encodedString;
}

- (NSString *) capitalizedFirst {
	return [self stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[self substringToIndex:1] uppercaseString]];
}

@end
