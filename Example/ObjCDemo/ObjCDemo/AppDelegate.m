//
//  AppDelegate.m
//  ObjCDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <LoginRadiusSDK/LoginRadius.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    LoginRadiusSDK * sdk =  [LoginRadiusSDK instance];
    [sdk applicationLaunchedWithOptions:launchOptions];
    
    /* Google Native SignIn
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    [GIDSignIn sharedInstance].delegate = self;
    */
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {

    BOOL canOpen = NO;
    
    /* Google Native SignIn
    canOpen = (canOpen || [[GIDSignIn sharedInstance] handleURL:url
                             sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                    annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]);
    */
    
    canOpen = (canOpen || [[LoginRadiusSDK sharedInstance] application:app
                                                openURL:url
                                      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                             annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]);
    
    return canOpen;
}

/* Google Native SignIn

 - (void)signIn:(GIDSignIn *)signIn
     didSignInForUser:(GIDGoogleUser *)user
            withError:(NSError *)error {
     
    if (error != nil)
    {
        NSLog(@"Error: %@",error.localizedDescription);
    }
    else
    {
        NSString *idToken = user.authentication.accessToken;
        [[LoginRadiusManager sharedInstance] nativeGoogleLoginWithAccessToken: idToken
                                                                   completionHandler:^(BOOL success, NSError *error) {
             if (success) {
                NSLog(@"successfully logged in with google");
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"userAuthenticatedFromNativeGoogle" object:nil userInfo:nil];

             } else {
                 NSLog(@"Error: %@", [error description]);
             }
         }];
    }
     
}
*/
@end
