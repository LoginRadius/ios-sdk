//
//  WechatUser.m
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import "WechatUser.h"

@implementation WechatUser

- (instancetype)initWithJSON:(NSDictionary *)json { 
    self = [super init];
    
    if (self) {
        self.accessToken = [json objectForKey:@"access_token"];
        self.refreshToken = [json objectForKey:@"refresh_token"];
        self.expiresIn = [[json objectForKey:@"expires_in"] integerValue];
        self.scope = [json objectForKey:@"scope"];
    }
    return self;
}

- (void)addInformationProfileWithJSON:(NSDictionary *)json {
    NSDictionary *_headimgurl = [json objectForKey:@"ProfileImageUrls"];
    NSDictionary *_country = [json objectForKey:@"Country"];
    self.city = [json objectForKey:@"City"];
    self.nickname = [json objectForKey:@"NickName"];
    self.headimgurl = [_headimgurl objectForKey:@"Profile"];
    self.country = [_country objectForKey:@"Name"];
    self.province = [json objectForKey:@"State"];
    self.sex = [json objectForKey:@"Gender"];
    self.language = [json objectForKey:@"Language"];
}

@end
