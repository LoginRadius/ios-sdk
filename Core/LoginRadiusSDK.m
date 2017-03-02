//
//  LoginRadiusSDK.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSDK.h"
#import "LoginRadiusSocialLoginManager.h"
#import "LoginRadiusRegistrationManager.h"
#import "LRTouchIDAuth.h"

static NSString * const LoginRadiusPlistFileName = @"LoginRadius";
static NSString * const LoginRadiusAPIKey = @"ApiKey";
static NSString * const LoginRadiusSiteName = @"SiteName";

@interface LoginRadiusSDK ()
@property (strong, nonatomic) LoginRadiusRegistrationManager *registrationManager;
@property (strong, nonatomic) LoginRadiusSocialLoginManager *socialLoginManager;
@property (strong, nonatomic) LRTouchIDAuth *touchIDManager;
@end

@interface LoginRadiusSDK ()

@end

@implementation LoginRadiusSDK

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:LoginRadiusPlistFileName ofType:@"plist"];
    NSDictionary* values = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = values[LoginRadiusAPIKey];
    NSString *siteName = values[LoginRadiusSiteName];
    NSAssert(apiKey, @"ApiKey cannot be null in LoginRadius.plist");
    NSAssert(siteName, @"SiteName cannot be null in LoginRadius.plist");

    self = [super init];

    if (self) {
        _apiKey = apiKey;
        _siteName = siteName;
		_registrationManager = [[LoginRadiusRegistrationManager alloc] init];
		_socialLoginManager = [[LoginRadiusSocialLoginManager alloc] init];
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
	[[LoginRadiusSocialLoginManager sharedInstance] logout];
	// Clearing all stored tokens userprofiles for loginradius
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (NSHTTPCookie *cookie in [storage cookies]) {
		[storage deleteCookie:cookie];
	}

	NSUserDefaults *lrUserDefault = [NSUserDefaults standardUserDefaults];
	[lrUserDefault removeObjectForKey:@"isLoggedIn"];
	[lrUserDefault removeObjectForKey:@"lrAccessToken"];
	[lrUserDefault removeObjectForKey:@"lrUserBlocked"];
	[lrUserDefault removeObjectForKey:@"lrUserProfile"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*) apiKey {
	return [LoginRadiusSDK sharedInstance].apiKey;
}

+ (NSString*) siteName {
	return [LoginRadiusSDK sharedInstance].siteName;
}

#pragma mark Application Delegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
    [self.socialLoginManager applicationLaunchedWithOptions:launchOptions];
	[self.registrationManager applicationLaunchedWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	if ([[LoginRadiusSocialLoginManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation]) {
		return YES;
	}
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end
