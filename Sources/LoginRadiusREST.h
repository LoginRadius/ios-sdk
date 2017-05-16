//
//  LoginRadiusREST.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusSDK.h"
#import <AFNetworking/AFNetworking.h>

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

/**
 shared singleton

 @return singleton instance of REST client
 */
+ (instancetype) sharedInstance;

#pragma mark - Methods

/**
 HTTP GET Method

 @param url LoginRadius Endpoint
 @param queryParams Query Parameters
 @param completion API response completion Handler
 */
- (void)sendGET:(NSString *)url queryParams:(id)queryParams completionHandler:(LRAPIResponseHandler)completion;

/**
 HTTP POST Method

 @param url LoginRadius Endpoint
 @param queryParams Query Parameters
 @param body JSON Payload
 @param completion API response completion Handler
 */
- (void)sendPOST:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion;

/**
 HTTP PUT Method

 @param url LoginRadius Endpoint
 @param queryParams Query Parameters
 @param body JSON Payload
 @param completion API response completion Handler
 */

- (void)sendPUT:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion;

/**
 HTTP DELETE Method

 @param url LoginRadius Endpoint
 @param queryParams Query Parameters
 @param body JSON Payload
 @param completion API response completion Handler
 */

- (void)sendDELETE:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion;

@end
