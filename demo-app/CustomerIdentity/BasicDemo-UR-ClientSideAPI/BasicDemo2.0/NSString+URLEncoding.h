//
//  NSString+URLEncoded.h
//  LoginRadiusSDK
//

#import <Foundation/Foundation.h>

/*!
 *
 * Utility methods for URL encoding and decoding of strings.
 *
 * .
 *
 **/
@interface NSString (URLEncoding)

/*!
 *
 * Encodes the string for use in a URL.
 *
 * @returns The string encoded for use in a URL
 *
 * .
 *
 **/
- (NSString *)URLEncodedString;

/*!
 *
 * Decodes the string if it was encoded for us in a URL.
 *
 * @returns The decoded string
 *
 *
 *
 **/
- (NSString *)URLDecodedString;

@end
