//
//  LRMutableDictionary
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "NSMutableDictionary+LRMutableDictionary.h"

@implementation NSMutableDictionary (LRMutableDictionary)

- (NSMutableDictionary *) replaceNullWithBlank {
	const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
	const id nul = [NSNull null];
	const NSString *blank = @"";

	for (NSString *key in self) {
      
		const id object = [self objectForKey: key];

		if (object == nul) {
			[replaced setObject: blank forKey: key];
		} else if ([object isKindOfClass: [NSDictionary class]]) {
			NSInteger count = [object count];
			if ( count != 0 ) {
				[replaced setObject: [[object mutableCopy] replaceNullWithBlank] forKey: key];
			}
		} else if ( [object isKindOfClass: [NSArray class]] ) {
			NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self objectForKey:key]];
			for (int i=0; i < [tempArray count]; i++) {
				id arrayItem = [[tempArray objectAtIndex:i] mutableCopy];
				if([arrayItem isKindOfClass:[NSMutableDictionary class]]) {
					[tempArray setObject:[arrayItem replaceNullWithBlank] atIndexedSubscript:i];
				}
			}
			[replaced setObject:tempArray forKey:key];
		}
	}

  return [replaced mutableCopy];
}

@end
