//
//  AuthWechatManager.m
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import "AuthWechatManager.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "LoginRadius.h"

NSString *const WECHAT_APP_ID = @"";

// put your wechat app_id

NSString *const UNIVERSAL_LINK = @"";

// put a universal link for the application for example https://github.com/LoginRadius/ios-sdk

typedef void (^RequestCompletedBlock)(NSDictionary * __nullable response, NSError * __nullable error);

@interface AuthWechatManager () <WXApiDelegate>
@property (nonatomic, strong) WechatAuthCompletedBlock completion;
@end

@implementation AuthWechatManager

+ (instancetype)shareInstance {
    static AuthWechatManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AuthWechatManager new];
    });
    return instance;
}

- (BOOL)initManager {
    return [WXApi registerApp:WECHAT_APP_ID universalLink:UNIVERSAL_LINK];
}

- (BOOL)isWechatUrl:(NSString *)url {
    NSString *baseUrl = [[url componentsSeparatedByString:@"://"] firstObject];
    return [baseUrl isEqualToString:WECHAT_APP_ID];
}

- (BOOL)handleOpenUrl:(NSURL *)url completion:(WechatAuthCompletedBlock)completion {
    NSString *urlString = [url absoluteString];
    NSString *urlLink = [[[[urlString componentsSeparatedByString:@"//"] lastObject] componentsSeparatedByString:@"?"] firstObject];

    if (urlLink && ([urlLink isEqualToString:@"oauth"] || [urlLink isEqualToString:@"wapoauth"])) {
        [self initManager];
        self.completion = completion;
        return [WXApi handleOpenURL:url delegate:self];
    }
    return true;
}

- (void)auth:(UIViewController *)controller {
    SendAuthReq *authReq = [SendAuthReq new];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"wechat_auth_login_liulishuo";
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:authReq completion:^(BOOL success) {
            
        }];
       // [WXApi sendReq:authReq];
    }
    else {
        [WXApi sendAuthReq:authReq viewController:controller delegate:self completion:^(BOOL success) {
            
        }];
       // [WXApi sendAuthReq:authReq viewController: controller delegate:self];
        
    }
}

- (void)onResp:(BaseResp*)resp {
    if (resp.errCode != WXSuccess) {
        self.completion(nil, [NSError errorWithDomain:@"wechat_error_domain" code:resp.errCode userInfo:@{NSLocalizedDescriptionKey: resp.errStr}]);
    }
    else {
        if ([resp isKindOfClass:[SendAuthResp class]]) {
            SendAuthResp *temp = (SendAuthResp*)resp;
            NSLog(@"%@", temp.code);
          [[LoginRadiusSocialLoginManager sharedInstance] convertWeChatCodeToLRToken:temp.code completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
                if(error){
                           self.completion(nil, error);
                       }else {
                           NSString *access_token= [data objectForKey:@"access_token"];
                           NSString *refresh_token= [data objectForKey:@"refresh_token"];
                           WechatUser *user = [[WechatUser alloc] initWithJSON:data];
                           NSLog(@"LR Token%@",access_token);
                           NSLog(@"LR Refresh Token%@",refresh_token);
                           [[AuthenticationAPI authInstance] profilesWithAccessToken:access_token completionHandler:^(NSDictionary * _Nullable data, NSError * err) {
                               
                               if(err){
                                   self.completion(nil, err);
                               }else {
                                    [user addInformationProfileWithJSON:data];
                                   self.completion(user, error);
                             }
                           }];

                       }
            }];
            
        
        }
    }
}

- (BOOL)canSend {
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}



@end
