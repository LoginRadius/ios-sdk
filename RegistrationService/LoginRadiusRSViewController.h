//
//  LoginRadiusRaaSViewController.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRadiusSDK.h"

/**
 *  Registration UIViewController
 */
@interface LoginRadiusRSViewController : UIViewController

#pragma mark - Init
/**
 *  Initilizer
 *
 *  @param action  service action should be one of these[@"login", @"registration", @"forgotpassword", @"social"]
 *  @param handler service completion handler
 *  @return view controller instance
 */
- (instancetype)initWithAction: (NSString*) action completionHandler:(LRServiceCompletionHandler)handler;
@end
