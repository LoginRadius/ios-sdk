//
//  ConfigurationAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 14/12/17.
//

#import "ConfigurationAPI.h"

@implementation ConfigurationAPI


+ (instancetype)configInstance{
    static dispatch_once_t onceToken;
    static ConfigurationAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[ConfigurationAPI alloc] init];
    });
    
    return instance;
}


- (void)getConfigurationSchema:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST configInstance] sendGET:@"ciam/appInfo"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey]
                                             }
                         completionHandler:completion];
    
}
@end



