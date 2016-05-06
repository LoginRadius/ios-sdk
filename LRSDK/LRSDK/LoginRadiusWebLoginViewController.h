//
//  LoginRadiusWebLoginViewController.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusWebLoginViewController : UIViewController
- (instancetype)initWithProvider: (NSString*) provider completionHandler:(LRServiceCompletionHandler)handler;
@end
