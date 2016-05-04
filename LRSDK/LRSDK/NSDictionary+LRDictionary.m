//
//  LRDictionary
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "NSDictionary+LRDictionary.h"

static NSString * URLDecodedString(NSString *urlString) {
	__autoreleasing NSString *decodedString;
	decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
																										  NULL,
																										  (__bridge CFStringRef)urlString,
																										  CFSTR(""),
																										  kCFStringEncodingUTF8
																										  );
	return decodedString;
}

static NSString * URLEncodedString(NSString *urlString) {
	__autoreleasing NSString *encodedString;
	encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
																						  NULL,
																						  (__bridge CFStringRef)urlString,
																						  NULL,
																						  (CFStringRef)@":!*();@/&?#[]+$,='%’\"",
																						  kCFStringEncodingUTF8
																						  );
	return encodedString;
}

@implementation NSDictionary (LRDictionary)

- (NSString *)queryString
{
	NSMutableString *queryString = nil;
	NSArray *keys = [self allKeys];

	if ([keys count] > 0) {
		for (id key in keys) {
			id value = [self objectForKey:key];
			if (nil == queryString) {
				queryString = [[NSMutableString alloc] init];
				[queryString appendFormat:@"?"];
			} else {
				[queryString appendFormat:@"&"];
			}

			if (nil != key && nil != value) {
				[queryString appendFormat:@"%@=%@", URLEncodedString(key), URLEncodedString(value)];
			} else if (nil != key) {
				[queryString appendFormat:@"%@", URLEncodedString(key)];
			}
		}
	}

	return queryString;
}

+ (NSDictionary *)dictionaryWithQueryString: (NSString *)queryString {
	NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
	NSArray *pairs = [queryString componentsSeparatedByString:@"&"];

	for (NSString *pair in pairs)
	{
		NSArray *elements = [pair componentsSeparatedByString:@"="];
		if (elements.count == 2)
		{
			NSString *key = elements[0];
			NSString *value = elements[1];
			NSString *decodedKey = URLDecodedString(key);
			NSString *decodedValue = URLDecodedString(value);

			if (![key isEqualToString:decodedKey])
				key = decodedKey;

			if (![value isEqualToString:decodedValue])
				value = decodedValue;

			[dictionary setObject:value forKey:key];
		}
	}

	return [NSDictionary dictionaryWithDictionary:dictionary];
}


@end
