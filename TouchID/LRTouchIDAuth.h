//
//  LRTouchIDAuth.h
//  Pods
//
//  Created by Raviteja Ghanta on 01/03/17.
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

-(void)localAuthenticationWithTouchID:(LRServiceCompletionHandler)handler;

@end
