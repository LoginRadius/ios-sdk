//
//  LoginRadiusSDK.h
//  LoginRadius
//
//  Created by Raviteja Ghanta on 13/04/16.
//  Copyright © 2016 LoginRadius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^loginResult)(NSMutableDictionary *user, NSError *error);
typedef void (^responseHandler)(NSDictionary *data, NSError *error);

@interface LoginRadiusSDK : NSObject

// Initilization
+ (void)instanceWithAPIKey:(NSString *)apiKey
				  siteName:(NSString *)siteName
			   application:(UIApplication *)application
			 launchOptions:(NSDictionary *)launchOptions;

+ (instancetype)sharedInstance;

// Application Delegate methods
- (BOOL)application:(UIApplication *)application
		   openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
		annotation:(id)annotation;

- (void)applicationDidBecomeActive:(UIApplication *)application;

+ (NSString*) apiKey;
+ (NSString*) siteName;

@end
