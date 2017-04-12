//
//  LoginRadiusSDK.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 API Response Completion Handler

 @param data API Response
 @param error API Error
 */
typedef void (^LRAPIResponseHandler)(NSDictionary *data, NSError *error);


/**
 LoginRadius Registration Service / Social Login Response Handler

 @param success Service success
 @param error Service Error
 */
typedef void (^LRServiceCompletionHandler)(BOOL success, NSError *error);

/**
 *  This class is the entry point for all loginradius functionality
 */
@interface LoginRadiusSDK : NSObject

#pragma mark - Properties

/**
 LoginRadius API Key
 */
@property (strong, readonly, nonatomic) NSString* apiKey;


/**
 LoginRadius SiteName
 */
@property (strong, readonly, nonatomic) NSString* siteName;


/**
 Google v2Recaptcha key
 */
@property (strong, readonly, nonatomic) NSString* v2RecaptchaSiteKey;

/**
 *  Set language for the loginradius hosted pages for user registration service, currently we support english, spanish,
 *  german, french should be one of these[@"es", @"de", @"fr"]
 *  Default is english. Please contact support for customizing the hosted pages.
 */
@property (nonatomic, copy) NSString* appLanguage;

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

#pragma mark - Class Methods to access Readonly Properties

/**
 LoginRadius API Key

 @return Returns LoginRadius API key
 */
+ (NSString*)apiKey;


/**
 LoginRadius SiteName

 @return Returns LoginRadius SiteName
 */
+ (NSString*)siteName;


/**
 Google v2Recaptcha key

 @return Returns Google v2Recaptcha key
 */
+ (NSString*)v2RecaptchaSiteKey;

#pragma mark - Application Delegate methods

/**
 App Launched Delegate method
 */
- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;


/**
 App Open URL Delegate method. Call this method in your AppDelegate for native social login to work properly

 @return If LoginRadius can handle the url it return YES otherwise NO.
 */
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;


/**
 App DidBecomeActive Delegate method
 */
- (void)applicationDidBecomeActive:(UIApplication *)application;


#pragma mark - Logout

/**
 *  Log out the user
 */
+ (void) logout;

@end
