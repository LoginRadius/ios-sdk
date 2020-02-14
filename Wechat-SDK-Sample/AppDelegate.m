//
//  AppDelegate.m
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import "AuthWechatManager.h"
#import "ProfileViewController.h"
#import "UserAuth.h"



@interface AppDelegate () <WXApiDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //init the manager.
    [[AuthWechatManager shareInstance] initManager];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[AuthWechatManager shareInstance] isWechatUrl:[url absoluteString]]) {
        [self handleWechatUrl:url];
    }
    return true;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([[AuthWechatManager shareInstance] isWechatUrl:[url absoluteString]]) {
        [self handleWechatUrl:url];
    }
    return true;
}

//handle wechat url
- (BOOL)handleWechatUrl:(NSURL *)url {
    //check if there is a connected user to avoid to handle the Wechat url
    if ([UserAuth shareInstance].connectedUser) {
        [self handleConnectedUser];
        return true;
    }
    
    //present a loading controller, waiting to fetch the user data.
    self.window.rootViewController = [self instanceControllerWithId:@"loadingStoryboard"];
    return [[AuthWechatManager shareInstance] handleOpenUrl:url completion:^(WechatUser * _Nullable user, NSError * _Nullable error) {
        //get the user information see the WechatUser model.
        //preparing to present the profile controller
        //store the connected user, to keep him logged
        [[AuthWechatManager shareInstance] initManager];
        dispatch_async(dispatch_get_main_queue(), ^{
            ProfileViewController *controller = (ProfileViewController *)[self instanceControllerWithId:@"profileStoryboard"];
            [UserAuth shareInstance].connectedUser = user;
            controller.user = user;
            self.window.rootViewController = controller;
        });
    }];
}

- (void)handleConnectedUser {
    ProfileViewController *controller = (ProfileViewController *)[self instanceControllerWithId:@"profileStoryboard"];
    controller.user = [UserAuth shareInstance].connectedUser;
    self.window.rootViewController = controller;
}

//helper to instance controller
- (UIViewController *)instanceControllerWithId:(NSString *)identifier {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:identifier];
}

@end
