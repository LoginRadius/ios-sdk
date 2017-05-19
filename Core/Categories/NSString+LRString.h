//
//  NSString+LRString.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LRString)

- (NSString *) URLDecodedString;

- (NSString *) URLEncodedString;

- (NSString *) capitalizedFirst;

@end
