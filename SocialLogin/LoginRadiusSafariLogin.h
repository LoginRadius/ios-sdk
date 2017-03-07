//
//  LoginRadiusSafariLogin.h
//  Pods
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusSafariLogin : NSObject

-(void)loginWithProvider:(NSString*)provider
            inController:(UIViewController*)controller
       completionHandler:(LRServiceCompletionHandler)handler;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
@end
