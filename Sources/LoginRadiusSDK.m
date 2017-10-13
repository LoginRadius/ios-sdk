//
//  LoginRadiusSDK.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSDK.h"
#import "LoginRadiusManager.h"
#import "LRTouchIDAuth.h"

static NSString * const LoginRadiusPlistFileName = @"LoginRadius";
static NSString * const LoginRadiusAPIKey = @"ApiKey";
static NSString * const LoginRadiusSiteName = @"SiteName";
static NSString * const LoginRadiusV2RecaptchaSiteKey = @"V2RecaptchaSiteKey";
static NSString * const LoginRadiusHostedPageURL = @"HostedPageURL";
static NSString * const LoginRadiusEnableGoogleNativeInHosted = @"EnableGoogleNativeInHosted";
static NSString * const LoginRadiusEnableFacebookNativeInHosted = @"EnableFacebookNativeInHosted";
static NSString * const LoginRadiusNativeSocialAskForRequiredFields = @"NativeSocialAskForRequiredFields";


@interface LoginRadiusSDK ()
@property (strong, nonatomic) LoginRadiusManager *manager;
@property (strong, nonatomic) LRTouchIDAuth *touchIDManager;
@end

@interface LoginRadiusSDK ()

@end

@implementation LoginRadiusSDK

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:LoginRadiusPlistFileName ofType:@"plist"];
    NSDictionary* values = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = (values[LoginRadiusAPIKey]&&[values[LoginRadiusAPIKey] length] != 0)?values[LoginRadiusAPIKey]:nil;
    NSString *siteName = (values[LoginRadiusSiteName]&&[values[LoginRadiusSiteName] length] != 0)?values[LoginRadiusSiteName]:nil;
    NSString *v2RecaptchaSiteKey = values[LoginRadiusV2RecaptchaSiteKey];
    BOOL enableGoogleNativeInHosted = [values[LoginRadiusEnableGoogleNativeInHosted] boolValue];
    BOOL enableFacebookNativeInHosted = [values[LoginRadiusEnableFacebookNativeInHosted] boolValue];
    BOOL nativeSocialAskForRequiredFields = values[LoginRadiusNativeSocialAskForRequiredFields] ? [values[LoginRadiusNativeSocialAskForRequiredFields] boolValue] : YES; //if nil, always ask to verify those fields
    
    NSString *hostedPageURL = (values[LoginRadiusHostedPageURL]&&[values[LoginRadiusHostedPageURL] length]!= 0)?values[LoginRadiusHostedPageURL]:@"https://cdn.loginradius.com/hub/prod/Theme/mobile-v4/index.html" ;
    NSURL *validateURL = [NSURL URLWithString:hostedPageURL];

    NSAssert(apiKey, @"ApiKey cannot be null or empty in LoginRadius.plist");
    NSAssert(siteName, @"SiteName cannot be null or empty in LoginRadius.plist");
    NSAssert((validateURL && validateURL.scheme && validateURL.host), @"HostedPageURL is invalid in LoginRadius.plist");

    self = [super init];

    if (self) {
        _apiKey = apiKey;
        _siteName = siteName;
        _v2RecaptchaSiteKey = v2RecaptchaSiteKey;
        _enableGoogleNativeInHosted = enableGoogleNativeInHosted;
        _enableFacebookNativeInHosted = enableFacebookNativeInHosted;
        _nativeSocialAskForRequiredFields = nativeSocialAskForRequiredFields;
        _hostedPageURL = [validateURL absoluteString];
		_manager = [[LoginRadiusManager alloc] init];
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
	[[LoginRadiusManager sharedInstance] logout];
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

+ (NSString*) v2RecaptchaSiteKey {
    return [LoginRadiusSDK sharedInstance].v2RecaptchaSiteKey;
}

+ (NSString*) hostedPageURL {
    return [LoginRadiusSDK sharedInstance].hostedPageURL;
}

+ (BOOL) enableFacebookNativeInHosted {
    return [LoginRadiusSDK sharedInstance].enableFacebookNativeInHosted;
}

+ (BOOL) enableGoogleNativeInHosted {
    return [LoginRadiusSDK sharedInstance].enableGoogleNativeInHosted;
}

+ (BOOL) nativeSocialAskForRequiredFields {
    return [LoginRadiusSDK sharedInstance].nativeSocialAskForRequiredFields;
}

#pragma mark Application Delegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
	[self.manager applicationLaunchedWithOptions:launchOptions];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	
	return [[LoginRadiusManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end
