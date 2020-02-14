//
//  UserAuth.h
//  Wechat-SDK-Sample
//
//  Created by Giriraj Yadav on 06/01/2020.
//  Copyright © 2019 Giriraj Yadav. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WechatUser.h"

@interface UserAuth : NSObject

@property (nonatomic, strong) WechatUser *connectedUser;

+ (instancetype)shareInstance;

@end
