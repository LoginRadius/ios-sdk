//
//  LoginRadiusWebLoginViewController.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRadiusSDK.h"

/**
 * Web social login
 */
@interface LoginRadiusWebLoginViewController : UIViewController

#pragma mark - Init

/**
 *  Init
 *
 *  @return singleton instance
 */
- (instancetype)initWithProvider: (NSString*) provider completionHandler:(LRAPIResponseHandler)handler;
@end
