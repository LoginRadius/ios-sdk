//
//  LRTouchIDAuth.h
//  Pods
//
//  Created by LoginRadius Development Team on 01/03/17.
//
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LRTouchIDAuth : NSObject

#pragma mark - Init

/**
 *  Initializer
 *  @return singleton instance
 */
+ (instancetype)sharedInstance;

- (void)localAuthenticationWithFallbackTitle:(NSString *)localizedFallbackTitle
                                             completion:(LRServiceCompletionHandler)handler;

@end
