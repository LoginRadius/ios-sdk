//
//  LoginRadiusTwitterLogin.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusTwitterLogin : NSObject
+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;
-(void)login:(LRServiceCompletionHandler)handler;
@end
