//
//  ConfigurationAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"


@interface ConfigurationAPI : NSObject

+ (instancetype)configInstance;
- (void)getConfigurationSchema:(LRAPIResponseHandler)completion;
@end
