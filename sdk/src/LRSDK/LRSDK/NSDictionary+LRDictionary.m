//
//  LRDictionary
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "NSDictionary+LRDictionary.h"
#import "NSString+LRString.h"

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
				[queryString appendFormat:@"%@=%@", [key URLEncodedString], [value URLEncodedString]];
			} else if (nil != key) {
				[queryString appendFormat:@"%@", [key URLEncodedString]];
			}
		}
	}

	return queryString;
}

+ (NSDictionary *)dictionaryWithQueryString: (NSString *)queryString {
	if (queryString.length == 0) {
		return @{};
	}

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


@end
