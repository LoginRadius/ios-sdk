//
//  LoginRadiusREST.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"

/**
 *  REST client
 */
@interface LoginRadiusREST : NSObject

#pragma mark - Init

/**
 *  shared singleton
 *
 *  @return singleton instance of REST client
 */
+ (instancetype) sharedInstance;

#pragma mark - Methods

/**
 *  Call API end point
 *
 *  @param endpoint   API end point
 *  @param httpMethod HTTP method {GET, POST, DELETE}
 *  @param params     Necessary params for the end point
 *  @param completion API service reponse handler
 */

- (void)callAPIEndpoint:(NSString*)endpoint
				 method:(NSString*)httpMethod
				 params:(NSDictionary*)params
	  completionHandler:(LRAPIResponseHandler)completion;

@end
