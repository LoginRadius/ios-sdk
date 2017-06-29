//
//  LoginRadiusSDK.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSDK.h"
#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusRegistrationManager.h"
#import "LoginRadiusCustomObjectManager.h"
#import "LRTouchIDAuth.h"
#import "LRSession.h"

static NSString * const LoginRadiusPlistFileName = @"LoginRadius";
static NSString * const LoginRadiusAPIKey = @"ApiKey";
static NSString * const LoginRadiusSiteName = @"SiteName";
static NSString * const LoginRadiusKeychain = @"useKeychain";
static NSString * const LoginRadiusRequiredFields = @"askForRequiredFields";
static NSString * const LoginRadiusVerifiedFields = @"askForVerifiedFields";
static NSString * const LoginRadiusInvalidateAndDeleteAccessTokenOnLogout = @"invalidateAndDeleteAccessTokenOnLogout";

@interface LoginRadiusSDK ()
@property (strong, nonatomic) LoginRadiusRegistrationManager *registrationManager;
@property (strong, nonatomic) LoginRadiusSocialLoginManager *socialLoginManager;
@property (strong, nonatomic) LoginRadiusCustomObjectManager *customObjectManager;
@property (strong, nonatomic) LRTouchIDAuth *touchIDManager;
@end

@implementation LoginRadiusSDK

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:LoginRadiusPlistFileName ofType:@"plist"];
    NSDictionary* values = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = values[LoginRadiusAPIKey];
    NSString *siteName = values[LoginRadiusSiteName];
    BOOL useKeychain = values[LoginRadiusKeychain] ? [values[LoginRadiusKeychain] boolValue] : NO; // if nil set to false
    BOOL askForRequiredFields = values[LoginRadiusRequiredFields] ? [values[LoginRadiusRequiredFields] boolValue] : YES; //if nil, always ask for missing mandatory fields
    BOOL askForVerifiedFields = values[LoginRadiusVerifiedFields] ? [values[LoginRadiusVerifiedFields] boolValue] : YES; //if nil, always ask to verify those fields
    BOOL invalidateAndDeleteAccessTokenOnLogout = values[LoginRadiusInvalidateAndDeleteAccessTokenOnLogout] ? [values[LoginRadiusInvalidateAndDeleteAccessTokenOnLogout] boolValue] : YES; //if nil, always delete keychain info
    
    
    NSAssert(apiKey, @"ApiKey cannot be null in LoginRadius.plist");
    NSAssert(siteName, @"SiteName cannot be null in LoginRadius.plist");
    self = [super init];

    if (self) {
        _apiKey = apiKey;
        _siteName = siteName;
        _useKeychain = useKeychain;
        _askForRequiredFields = askForRequiredFields;
        _askForVerifiedFields = askForVerifiedFields;
        _invalidateAndDeleteAccessTokenOnLogout = invalidateAndDeleteAccessTokenOnLogout;
        _session = [[LRSession alloc] init];
		_registrationManager = [[LoginRadiusRegistrationManager alloc] init];
		_socialLoginManager = [[LoginRadiusSocialLoginManager alloc] init];
        _customObjectManager = [[LoginRadiusCustomObjectManager alloc] init];
        _touchIDManager = [[LRTouchIDAuth alloc] init];
    }

    return self;
}

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusSDK *instance;
	dispatch_once(&onceToken, ^{
		instance = [LoginRadiusSDK instance];
	});

	return instance;
}

+ (instancetype)instance {

    return [[LoginRadiusSDK alloc] init];
}

+ (void) logout {
    
    [[[self sharedInstance] session] logout];
    [[LoginRadiusSocialLoginManager sharedInstance] logout];

	// Clearing all stored tokens userprofiles for loginradius
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}
    
}

+ (NSString*) apiKey {
	return [LoginRadiusSDK sharedInstance].apiKey;
}

+ (NSString*) siteName {
	return [LoginRadiusSDK sharedInstance].siteName;
}

+ (BOOL) useKeychain {
	return [LoginRadiusSDK sharedInstance].useKeychain;
}

+ (BOOL) askForRequiredFields {
	return [LoginRadiusSDK sharedInstance].askForRequiredFields;
}

+ (BOOL) askForVerifiedFields {
	return [LoginRadiusSDK sharedInstance].askForVerifiedFields;
}

+ (BOOL) invalidateAndDeleteAccessTokenOnLogout {
	return [LoginRadiusSDK sharedInstance].invalidateAndDeleteAccessTokenOnLogout;
}

#pragma mark Application Delegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
    [self.socialLoginManager applicationLaunchedWithOptions:launchOptions];
	[self.registrationManager applicationLaunchedWithOptions:launchOptions];
    [self.customObjectManager applicationLaunchedWithOptions:launchOptions];
    [self.registrationManager getRegistrationSchema:^(NSDictionary *data, NSError *error){if (error){NSLog(@"%@", error.localizedDescription);}}];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

	return [[LoginRadiusSocialLoginManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end
