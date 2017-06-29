//
//  LoginRadiusCustomObjectManager.m
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusCustomObjectManager.h"
#import "LoginRadiusREST.h"

@implementation LoginRadiusCustomObjectManager

+ (instancetype)sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusCustomObjectManager *instance;

	dispatch_once(&onceToken, ^{
		instance = [[LoginRadiusCustomObjectManager alloc] init];
	});

	return instance;
}

- (void)createCustomObjectWithName:(NSString*)name
                       accessToken:(NSString*)accessToken
                              data:(NSDictionary*)data
                 completionHandler:(LRAPIResponseHandler)completion{

	[[LoginRadiusREST apiInstance] sendPOST:@"identity/v2/auth/customobject"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"objectname": name
												 }
										  body:data
                             completionHandler:completion];
}

- (void)getCustomObjectWithName:(NSString*)name
                    accessToken:(NSString*)accessToken
              completionHandler:(LRAPIResponseHandler)completion{
    
     [[LoginRadiusREST apiInstance] sendGET:@"identity/v2/auth/customobject"
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"objectname": name
												 }
                             completionHandler:completion];
}

- (void)getCustomObjectWithName:(NSString*)name
                    accessToken:(NSString*)accessToken
                 objectRecordId:(NSString*)objectRecordId
              completionHandler:(LRAPIResponseHandler)completion{
    
    NSString* url = [NSString stringWithFormat:@"identity/v2/auth/customobject/%@", objectRecordId];
	 [[LoginRadiusREST apiInstance] sendGET:url
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"objectname": name
												 }
                             completionHandler:completion];
}

- (void)putCustomObjectWithName:(NSString*)name
                    accessToken:(NSString*)accessToken
                 objectRecordId:(NSString*)objectRecordId
                           data:(NSDictionary*)data
              completionHandler:(LRAPIResponseHandler)completion{
    
    NSString* url = [NSString stringWithFormat:@"identity/v2/auth/customobject/%@", objectRecordId];
     [[LoginRadiusREST apiInstance] sendPUT:url
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"objectname": name
												 }
										  body:data
                             completionHandler:completion];
}


- (void)deleteCustomObjectWithName:(NSString*)name
                       accessToken:(NSString*)accessToken
                    objectRecordId:(NSString*)objectRecordId
                 completionHandler:(LRAPIResponseHandler)completion{
    
    NSString* url = [NSString stringWithFormat:@"identity/v2/auth/customobject/%@", objectRecordId];
     [[LoginRadiusREST apiInstance] sendDELETE:url
								   queryParams:@{
												 @"apikey": [LoginRadiusSDK apiKey],
												 @"access_token": accessToken,
												 @"objectname": name
												 }
                                          body:nil
                             completionHandler:completion];
}



#pragma mark Application delegate methods
- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions {
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	return YES;
}

@end
