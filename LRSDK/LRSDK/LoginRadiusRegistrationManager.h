//
//  LoginRadiusRegistrationManager.h
//  LR-iOS-SDK-Sample
//
//  Created by Raviteja Ghanta on 19/04/16.
//  Copyright © 2016 LR. All rights reserved.
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
