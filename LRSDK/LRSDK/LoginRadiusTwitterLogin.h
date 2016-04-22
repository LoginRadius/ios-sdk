//
//  LoginRadiusTwitterLogin.h
//  LoginRadius
//
//  Created by Raviteja Ghanta on 13/04/16.
//  Copyright © 2016 LoginRadius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusTwitterLogin : NSObject
+ (instancetype)instanceWithApplication:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions;
-(void)login:(loginResult)handler;
@end
