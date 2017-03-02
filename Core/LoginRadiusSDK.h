//
//  LoginRadiusSDK.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LRAPIResponseHandler)(NSDictionary *data, NSError *error);
typedef void (^LRServiceCompletionHandler)(BOOL success, NSError *error);

/**
 *  This class is the entry point for all loginradius functionality
 */
@interface LoginRadiusSDK : NSObject

@property (strong, readonly, nonatomic) NSString* apiKey;
@property (strong, readonly, nonatomic) NSString* siteName;

#pragma mark - Initilizers

/**
 *  Initilization, this should be the first function that should be called before any other call to LoginRadiusSDK.
 */
+ (instancetype)instance;

/**
 *  LoginRadiusSDK singleton
 *
 *  @return LoginRadius singleton object
 */
+ (instancetype)sharedInstance;
+ (NSString*)apiKey;
+ (NSString*)siteName;
#pragma mark - Application Delegate methods

/** Application Delegate methods
 */

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)applicationDidBecomeActive:(UIApplication *)application;


#pragma mark - Logout
/**
 *  Log out the user
 */
+ (void) logout;

@end
