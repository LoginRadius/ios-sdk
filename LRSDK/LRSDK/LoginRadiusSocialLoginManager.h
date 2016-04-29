//
//  LoginRadiusSocialLoginManager.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusSocialLoginManager : NSObject
@property BOOL useNativeLogin;

+ (instancetype)instanceWithApplication:(UIApplication*)application launchOptions:(NSDictionary*)launchOptions;
+ (instancetype)sharedInstance;

-(void)loginWithProvider:(NSString*)provider
			  parameters:(NSDictionary*)params
			inController:(UIViewController*)controller
	   completionHandler:(LRServiceCompletionHandler)handler;

- (void)logout;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
