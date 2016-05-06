//
//  LoginRadiusRaaSViewController.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusRSViewController : UIViewController
- (instancetype)initWithAction: (NSString*) action completionHandler:(LRServiceCompletionHandler)handler;
@end
