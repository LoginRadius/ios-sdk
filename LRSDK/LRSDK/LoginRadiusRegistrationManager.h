//
//  LoginRadiusRegistrationManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusRegistrationManager : NSObject

+ (instancetype)instanceWithApplication:(UIApplication*)application launchOptions:(NSDictionary*)launchOptions;
+ (instancetype)sharedInstance;

- (void) registrationWithAction:(NSString*) action
				   inController:(UIViewController*)controller
			  completionHandler:(loginResult)handler;

@end
