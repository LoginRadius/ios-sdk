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
static NSString * const LoginRadiusRegistrationSource = @"registrationSource";
static NSString * const LoginRadiusCustomHeaders = @"customHeaders";
static NSString * const LoginRadiusSiteName = @"siteName";
static NSString * const LoginRadiusVerificationUrl = @"verificationUrl";
static NSString * const LoginRadiusKeychain = @"useKeychain";
static NSString * const LoginRadiusCustomDomain = @"customDomain";


@interface LoginRadiusSDK ()
@property (strong, nonatomic) LoginRadiusSocialLoginManager *socialLoginManager;
@property (strong, nonatomic) LRTouchIDAuth *touchIDManager;
@end

@implementation LoginRadiusSDK

- (instancetype)init {
    NSString *path = [[NSBundle mainBundle] pathForResource:LoginRadiusPlistFileName ofType:@"plist"];
    NSDictionary* values = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *apiKey = values[LoginRadiusAPIKey];
    NSString *registrationSource = values[LoginRadiusRegistrationSource];
    NSDictionary *customHeaders = values[ LoginRadiusCustomHeaders];
    NSString *siteName = values[LoginRadiusSiteName];
    NSString *verificationUrl = values[LoginRadiusVerificationUrl] ? values[LoginRadiusVerificationUrl] : @"https://auth.lrcontent.com/mobile/verification/index.html";
    BOOL useKeychain = values[LoginRadiusKeychain] ? [values[LoginRadiusKeychain] boolValue] : NO; // if nil set to false
    NSString *customDomain = values[LoginRadiusCustomDomain] ? values[LoginRadiusCustomDomain] : @"";
    
    if([apiKey isEqualToString:@"<Your LoginRadius ApiKey>"] || [apiKey isEqualToString:@""]){
        NSString *str = nil;
        NSAssert(str, @"apiKey or siteName cannot be null in LoginRadius.plist");
    }
    
    NSAssert(apiKey, @"apiKey cannot be null in LoginRadius.plist");
    NSAssert(siteName, @"siteName cannot be null in LoginRadius.plist");
    
    if(!registrationSource){
        registrationSource = @"iOS";
    }
    
    self = [super init];
    
    if (self) {
        _apiKey = apiKey;
        _registrationSource = registrationSource;
        _siteName = siteName;
        _verificationUrl=verificationUrl;
        _customDomain =customDomain;
        _useKeychain = useKeychain;
        _session = [[LRSession alloc] init];
        _socialLoginManager = [[LoginRadiusSocialLoginManager alloc] init];
        _touchIDManager = [[LRTouchIDAuth alloc] init];
        _customHeaders = customHeaders;
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

+ (BOOL) logout {
    
    BOOL is = [(LRSession *)[[self sharedInstance] session] logout];
    [[LoginRadiusSocialLoginManager sharedInstance] logout];
    // Clearing all stored tokens userprofiles for loginradius
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    return is;
}

+ (NSString*) apiKey {
    return [LoginRadiusSDK sharedInstance].apiKey;
}
+ (NSString*) registrationSource {
    return [LoginRadiusSDK sharedInstance].registrationSource;
}
+ (NSString*) siteName {
    return [LoginRadiusSDK sharedInstance].siteName;
}

+ (NSString*) verificationUrl {
    return [LoginRadiusSDK sharedInstance].verificationUrl;
}

+ (NSString*) customDomain {
    return [LoginRadiusSDK sharedInstance].customDomain;
}

+ (BOOL) useKeychain {
    return [LoginRadiusSDK sharedInstance].useKeychain;
}
+ (NSDictionary*) customHeaders {
    return [LoginRadiusSDK sharedInstance].customHeaders;
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
