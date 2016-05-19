//
//  AppDelegate.m
//  ObjCDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 Raviteja Ghanta. All rights reserved.
//

#import "AppDelegate.h"
#import <LRSDK/LRSDK.h>

#define CLIENT_SITENAME @"<your-site-name>"
#define API_KEY @"<your-api-key>"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LoginRadiusSDK instanceWithAPIKey:API_KEY siteName:CLIENT_SITENAME application:application launchOptions:launchOptions];
    
    /* Uncomment the below line to use native social login.
     you need follow social login guide to add the neccessary keys to info.plist file
     http://apidocs.loginradius.com/v2.0/docs/ios-library#section-native-social-login
     */
    
    //[LoginRadiusSDK sharedInstance].useNativeSocialLogin = YES;
    
    /* Uncomment the below line and set the desired language for user registration service
     default is english
     only supports spanish @"es" , german - @"de" && french - @"fr"
     */
    
    // [LoginRadiusSDK sharedInstance].appLanguage = @"es";
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

@end
