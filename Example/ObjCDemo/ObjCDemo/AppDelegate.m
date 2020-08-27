//
//  AppDelegate.m
//  ObjCDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "AppDelegate.h"
#import <LoginRadiusSDK/LoginRadius.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
static BOOL useGoogleNative      = NO;
static BOOL useTwitterNative     = NO;
static BOOL useFacebookNative    = NO;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

     LoginRadiusSDK * sdk =  [LoginRadiusSDK instance];
     [sdk applicationLaunchedWithOptions:launchOptions];
   


    /* Google Native SignIn
    [GIDSignIn sharedInstance].clientID = @"Your google client id";
    [GIDSignIn sharedInstance].delegate = self;
    */

    /* Twitter Native Sign in
    [[TWTRTwitter sharedInstance] startWithConsumerKey:@"Your twitter consumer key" consumerSecret:@"Your twitter consumer SECRET key"];
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
    
    /* Twitter Native Sign in
    canOpen = (canOpen || [[TWTRTwitter sharedInstance] application:app openURL:url options:options]);
     */
    
    canOpen = (canOpen || [[LoginRadiusSDK sharedInstance] application:app
                                                openURL:url
                                      sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                             annotation:options[UIApplicationOpenURLOptionsAnnotationKey]]);
    
    return canOpen;
}

// Google Native Sign in
/*
- (void)signIn:(GIDSignIn *)signIn
     didSignInForUser:(GIDGoogleUser *)user
            withError:(NSError *)error {
 
    if (error != nil)
    {
        NSLog(@"Error: %@",error.localizedDescription);
    }
    else
    {
        NSString *googleToken = user.authentication.accessToken;
        NSString *refreshToken = user.authentication.refreshToken;
        NSString *clientID = user.authentication.clientID;
        UIViewController *currentVC = [(UINavigationController *)[[self window] rootViewController] topViewController];

        [[LoginRadiusSocialLoginManager sharedInstance] convertGoogleTokenToLRToken:googleToken google_refresh_token:refreshToken google_client_id:clientID withSocialAppName:@"" inController:currentVC completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
            id safeData =x (data) ? data : [NSNull null];
            id safeError = (error) ? error : [NSNull null];

            [[NSNotificationCenter defaultCenter] postNotificationName:@"userAuthenticatedFromNativeGoogle" object:nil userInfo:@{@"data":safeData,@"error":safeError}];
         }];
    }
}
*/

+(BOOL) useGoogleNative
{
    return useGoogleNative;
}

+(BOOL) useTwitterNative
{
    return useTwitterNative;
}

+(BOOL) useFacebookNative
{
    return useFacebookNative;
}

@end
