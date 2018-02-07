//
//  LoginRadiusSDK.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusSDK.h"
#import "LoginRadiusSocialLoginManager.h"
#import "LRTouchIDAuth.h"
#import "LRSession.h"

static NSString * const LoginRadiusPlistFileName = @"LoginRadius";
static NSString * const LoginRadiusAPIKey = @"apiKey";
static NSString * const LoginRadiusSiteName = @"siteName";
static NSString * const LoginRadiusVerificationUrl = @"verificationUrl";
static NSString * const LoginRadiusKeychain = @"useKeychain";


@interface LoginRadiusSDK ()
@property (strong, nonatomic) LoginRadiusSocialLoginManager *socialLoginManager;
@property (strong, nonatomic) LRTouchIDAuth *touchIDManager;
@end

@implementation LoginRadiusSDK

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:LoginRadiusPlistFileName ofType:@"plist"];
    NSDictionary* values = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = values[LoginRadiusAPIKey];
    NSString *siteName = values[LoginRadiusSiteName];
    NSString *verificationUrl = values[LoginRadiusVerificationUrl] ? values[LoginRadiusVerificationUrl] : @"https://auth.lrcontent.com/mobile/verification/index.html";
    BOOL useKeychain = values[LoginRadiusKeychain] ? [values[LoginRadiusKeychain] boolValue] : NO; // if nil set to false

    if([apiKey isEqualToString:@"<Your LoginRadius ApiKey>"] || [apiKey isEqualToString:@""]){
        NSString *str = nil;
        NSAssert(str, @"apiKey or siteName cannot be null in LoginRadius.plist");
    }
    
    NSAssert(apiKey, @"apiKey cannot be null in LoginRadius.plist");
    NSAssert(siteName, @"siteName cannot be null in LoginRadius.plist");
    
    
    self = [super init];

    if (self) {
        _apiKey = apiKey;
        _siteName = siteName;
        _verificationUrl=verificationUrl;
        _useKeychain = useKeychain;
        _session = [[LRSession alloc] init];
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
    
    [(LRSession *)[[self sharedInstance] session] logout];
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

+ (NSString*) verificationUrl {
    return [LoginRadiusSDK sharedInstance].verificationUrl;
}

+ (BOOL) useKeychain {
	return [LoginRadiusSDK sharedInstance].useKeychain;
}


#pragma mark Application Delegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
    [self.socialLoginManager applicationLaunchedWithOptions:launchOptions];
	
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {

	return [[LoginRadiusSocialLoginManager sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

@end
