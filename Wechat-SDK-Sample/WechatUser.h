//
//  WechatUser.h
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WechatUser : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *headimgurl;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, assign) NSString *sex;
@property (nonatomic, strong) NSString *openid;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, assign) NSInteger expiresIn;
@property (nonatomic, strong) NSString *refreshToken;
@property (nonatomic, strong) NSString *scope;

- (instancetype)initWithJSON:(NSDictionary *)json;
- (void)addInformationProfileWithJSON:(NSDictionary *)json;

@end
