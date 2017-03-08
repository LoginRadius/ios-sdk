//
//  LoginRadiusRegistrationManager.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusRegistrationManager.h"
#import "LoginRadiusRSViewController.h"

@implementation LoginRadiusRegistrationManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static LoginRadiusRegistrationManager *instance;

    dispatch_once(&onceToken, ^{
        instance = [[LoginRadiusRegistrationManager alloc] init];
    });

    return instance;
}

- (void) registrationWithAction:(NSString*) action inController:(UIViewController*)controller completionHandler:(LRServiceCompletionHandler)handler {
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
