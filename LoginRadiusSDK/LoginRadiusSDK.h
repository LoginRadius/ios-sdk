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
@property (strong, readonly, nonatomic) NSString* _Nonnull registrationSource;
@property (strong, readonly, nonatomic) NSDictionary* _Nonnull customHeaders;
@property (strong, readonly, nonatomic) NSString* _Nonnull apiKey;
@property (strong, readonly, nonatomic) NSString* _Nonnull siteName;
@property (strong, readonly, nonatomic) NSString* _Nonnull verificationUrl;
@property (strong, readonly, nonatomic) NSString* _Nonnull customDomain;
@property (strong, atomic) LRSession* _Nonnull session;
@property (readonly, nonatomic) BOOL useKeychain;
@property (readonly, nonatomic) BOOL setEncryption;


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
+ (NSString*_Nonnull)registrationSource;
+ (NSDictionary*_Nonnull)customHeaders;
+ (NSString*_Nonnull)siteName;
+ (NSString*_Nonnull)verificationUrl;
+ (NSString*_Nonnull)customDomain;
+ (BOOL)useKeychain;
+ (BOOL)setEncryption;
#pragma mark - Application Delegate methods

/** Application Delegate methods
 */

- (void)applicationLaunchedWithOptions:(NSDictionary *_Nullable)launchOptions;

- (BOOL)application:(UIApplication *_Nonnull)application
            openURL:(NSURL *_Nonnull)url
  sourceApplication:(NSString *_Nullable)sourceApplication
         annotation:(id _Nullable )annotation;

- (void)applicationDidBecomeActive:(UIApplication *_Nonnull)application;


#pragma mark - Logout
/**
 *  Log out the user
 */
+ (BOOL) logout;

@end
