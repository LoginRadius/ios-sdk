//
//  LoginRadiusRegistrationManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRegistrationManager.h"
#import "LoginRadiusRSViewController.h"
#import "LoginRadiusSafariLogin.h"
#import <SafariServices/SafariServices.h>

@interface LoginRadiusRegistrationManager() {}
@property(nonatomic, strong) LoginRadiusSafariLogin * safariLogin;
@end

@implementation LoginRadiusRegistrationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoginRadiusRegistrationManager *instance;

    dispatch_once(&onceToken, ^{
        instance = [[LoginRadiusRegistrationManager alloc] init];
    });

    return instance;
}

-(instancetype)init {
	self = [super init];
	if (self) {
        _safariLogin = [[LoginRadiusSafariLogin alloc] init];
	}
	return self;
}

- (void) registrationWithAction:(NSString*) action inController:(UIViewController*)controller completionHandler:(LRServiceCompletionHandler)handler {

    // If SafariVC exist show the traditional login and social in safari
    if ([SFSafariViewController class] != nil) {
        [self.safariLogin initWithAction:action inController:controller completionHandler:handler];
        return;
    }
    
	LoginRadiusRSViewController *webVC = [[LoginRadiusRSViewController alloc] initWithAction:action completionHandler:handler];
	UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:webVC];
	[controller presentViewController:navVC animated:YES completion:nil];
}

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return YES;
}

@end
