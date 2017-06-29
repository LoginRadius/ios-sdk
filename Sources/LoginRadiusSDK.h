//
//  LoginRadiusSDK.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LRSession.h"

typedef void (^LRAPIResponseHandler)(NSDictionary * _Nullable data, NSError * _Nullable error);
typedef void (^LRServiceCompletionHandler)(BOOL success, NSError * _Nullable error);

/**
 *  This class is the entry point for all loginradius functionality
 */
@interface LoginRadiusSDK : NSObject

@property (strong, readonly, nonatomic) NSString* _Nonnull apiKey;
@property (strong, readonly, nonatomic) NSString* _Nonnull siteName;
@property (strong, atomic) LRSession* _Nonnull session;
@property (readonly, nonatomic) BOOL useKeychain;
@property (readonly, nonatomic) BOOL askForRequiredFields;
@property (readonly, nonatomic) BOOL askForVerifiedFields;
@property (readonly, nonatomic) BOOL invalidateAndDeleteAccessTokenOnLogout;

#pragma mark - Initilizers

/**
 *  Initilization, this should be the first function that should be called before any other call to LoginRadiusSDK.
 */
+ (instancetype _Nonnull )instance;

/**
 *  LoginRadiusSDK singleton
 *
 *  @return LoginRadius singleton object
 */
+ (instancetype _Nonnull )sharedInstance;
+ (NSString*_Nonnull)apiKey;
+ (NSString*_Nonnull)siteName;
+ (BOOL)useKeychain;
+ (BOOL)askForRequiredFields;
+ (BOOL)askForVerifiedFields;
+ (BOOL)invalidateAndDeleteAccessTokenOnLogout;

#pragma mark - Application Delegate methods

/** Application Delegate methods
 */

- (void)applicationLaunchedWithOptions:(NSDictionary *_Nullable)launchOptions;

- (BOOL)application:(UIApplication *_Nonnull)application
            openURL:(NSURL *_Nonnull)url
  sourceApplication:(NSString *_Nonnull)sourceApplication
         annotation:(id _Nullable )annotation;

- (void)applicationDidBecomeActive:(UIApplication *_Nonnull)application;


#pragma mark - Logout
/**
 *  Log out the user
 */
+ (void) logout;

@end
