//
//  CustomObjectAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 13/12/17.
//

#import "CustomObjectAPI.h"

@implementation CustomObjectAPI

+ (instancetype)customInstance {
    static dispatch_once_t onceToken;
    static CustomObjectAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[CustomObjectAPI alloc] init];
    });
    
    return instance;
}

- (void)createCustomObjectWithObjectName:(NSString*)objectname
                       accessToken:(NSString*)accessToken
                              payload:(NSDictionary*)payload
                 completionHandler:(LRAPIResponseHandler)completion{
    
    [[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/customobject"
                                queryParams:@{
                                              @"apikey": [LoginRadiusSDK apiKey],
                                              @"access_token": accessToken,
                                              @"objectname": objectname
                                              }
                                       body:payload
                          completionHandler:completion];
}

- (void)getCustomObjectWithObjectName:(NSString*)objectname
                    accessToken:(NSString*)accessToken
              completionHandler:(LRAPIResponseHandler)completion{
    
    [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/customobject"
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": accessToken,
                                             @"objectname": objectname
                                             }
                         completionHandler:completion];
}

- (void)getCustomObjectWithObjectRecordId:(NSString*)objectRecordId
                    accessToken:(NSString*)accessToken
                 objectname:(NSString*)objectname
              completionHandler:(LRAPIResponseHandler)completion{
    
    NSString* url = [NSString stringWithFormat:@"identity/v2/auth/customobject/%@", objectRecordId];
    [[LoginRadiusREST apiInstance] sendGET:url
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": accessToken,
                                             @"objectname": objectname
                                             }
                         completionHandler:completion];
}

- (void)updateCustomObjectWithObjectName:(NSString*)objectname
                    accessToken:(NSString*)accessToken
                 objectRecordId:(NSString*)objectRecordId
                 updatetype:(NSString*)updatetype
                payload:(NSDictionary*)payload
              completionHandler:(LRAPIResponseHandler)completion{
   
    NSString* url = [NSString stringWithFormat:@"identity/v2/auth/customobject/%@", objectRecordId];
    [[LoginRadiusREST apiInstance] sendPUT:url
                               queryParams:@{
                                             @"apikey": [LoginRadiusSDK apiKey],
                                             @"access_token": accessToken,
                                             @"objectname": objectname,
                                             @"updatetype":updatetype
                                             }
                                      body:payload
                         completionHandler:completion];
}


- (void)deleteCustomObjectWithObjectRecordId:(NSString*)objectRecordId
                       accessToken:(NSString*)accessToken
                    objectname:(NSString*)objectname
                 completionHandler:(LRAPIResponseHandler)completion{
    
    NSString* url = [NSString stringWithFormat:@"identity/v2/auth/customobject/%@",objectRecordId];
    [[LoginRadiusREST apiInstance] sendDELETE:url
                                  queryParams:@{
                                                @"apikey": [LoginRadiusSDK apiKey],
                                                @"access_token": accessToken,
                                                @"objectname": objectname
                                                }
                                         body:@{}
                            completionHandler:completion];
}

@end
