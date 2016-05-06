//
//  LoginRadiusREST.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

@interface LoginRadiusREST : NSObject
+ (instancetype) sharedInstance;
- (void)callAPIEndpoint:(NSString*)endpoint
				 method:(NSString*)httpMethod
				 params:(NSDictionary*)params
	  completionHandler:(LRAPIResponseHandler)completion;

@end
