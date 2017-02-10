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
+ (instancetype) sharedInstance;

#pragma mark - Methods

- (void)sendGET:(NSString *)url queryParams:(id)queryParams completionHandler:(LRAPIResponseHandler)completion;
- (void)sendPOST:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion;
- (void)sendPUT:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion;
- (void)sendDELETE:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion;

@end
