//
//  LRMutableDictionary
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LRMutableDictionary.h"

@implementation NSMutableDictionary (LRMutableDictionary)

- (NSMutableDictionary *) replaceNullWithBlank {
	const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
	const id nullValue = [NSNull null];
	const NSString *emptyString = @"";

	for (NSString *key in self) {
		const id object = [self objectForKey: key];

		if (object == nullValue) {
			[replaced setObject: emptyString forKey: key];
		} else if ([object isKindOfClass: [NSDictionary class]]) {
			NSInteger count = [object count];

            if ( count != 0 ) {
				[replaced setObject: [[object mutableCopy] replaceNullWithBlank] forKey: key];
			}
		} else if ( [object isKindOfClass: [NSArray class]] ) {
			NSMutableArray *tempArray = [NSMutableArray arrayWithArray:object];
            NSMutableArray *newArray = [NSMutableArray array];

            for (int i=0; i < [tempArray count]; i++) {
				id item = [tempArray objectAtIndex:i];
                if (item != nullValue) {
                    id mutableItem = [item mutableCopy];
                    if([mutableItem isKindOfClass:[NSMutableDictionary class]]) {
                        [newArray setObject:[mutableItem replaceNullWithBlank] atIndexedSubscript:i];
                    }
                } else {
                    [newArray setObject:emptyString atIndexedSubscript:i];
                }
			}

			[replaced setObject:newArray forKey:key];
		}
	}

    return [replaced mutableCopy];
}

@end
