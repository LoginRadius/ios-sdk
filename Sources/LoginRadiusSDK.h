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
 Hosted Page URL
 */
@property (strong, readonly, nonatomic) NSString* hostedPageURL;

/**
 Google Native Key
 */
@property (readonly, nonatomic) BOOL useGoogleNativeLogin;

/**
 Facebook Native Key
 */
@property (readonly, nonatomic) BOOL useFacebookNativeLogin;

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

/**
 Hosted Page URL

 @return Returns Hosted Page URL
 */
+ (NSString*)hostedPageURL;

/**
 Configuration on using google native login

 @return Returns whether to use google native login
 */
+ (BOOL)useGoogleNativeLogin;

/**
 Configuration on using facebook native login

 @return Returns whether to use facebook native login
 */
+ (BOOL)useFacebookNativeLogin;

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
