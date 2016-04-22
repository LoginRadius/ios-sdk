//
//  NSMutableDictionary+LRMutableDictionary.m
//  LR-iOS-SDK-Sample
//
//  Created by Raviteja Ghanta on 19/04/16.
//  Copyright © 2016 LR. All rights reserved.
//

#import "NSMutableDictionary+LRMutableDictionary.h"

@implementation NSMutableDictionary (LRMutableDictionary)

- (NSMutableDictionary *) replaceNullWithBlank {
	const NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
	const id nul = [NSNull null];
	const NSString *blank = @"";

	for (NSString *key in self) {
		//        NSLog(@"Key processed => %@", key);

		const id object = [self objectForKey: key];
		//        if ([key isEqual: @"InterestedIn"]) {
		//            NSLog(@"Type of %@ is => %@", key, [object class]);
		//        }

		if (object == nul) {
			[replaced setObject: blank forKey: key];
		} else if ([object isKindOfClass: [NSDictionary class]]) {
			NSInteger count = [object count];
			if ( count != 0 ) {
				[replaced setObject: [(NSMutableDictionary *) object replaceNullWithBlank] forKey: key];
			}
		} else if ( [object isKindOfClass: [NSArray class]] ) {
			//NSLog(@" [Empty] key => %@", key);
			NSMutableArray *tempArray = [NSMutableArray arrayWithArray:[self objectForKey:key]];
			for (int i=0; i < [tempArray count]; i++) {
				id arrayItem = [tempArray objectAtIndex:i];
				if([arrayItem isKindOfClass:[NSDictionary class]]) {
					[tempArray setObject:[arrayItem replaceNullWithBlank] atIndexedSubscript:i];
				}
			}
			[replaced setObject:tempArray forKey:key];
		}
	}
	return [replaced mutableCopy];
}

@end
