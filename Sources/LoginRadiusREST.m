//
//  LoginRadiusREST.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusREST.h"
#import "NSDictionary+LRDictionary.h"
#import "NSError+LRError.h"
#import "LRResponseSerializer.h"

NSString *const API_BASE_URL = @"https://api.loginradius.com/";

@interface LoginRadiusREST()
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation LoginRadiusREST

+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusREST *_instance;
	dispatch_once(&onceToken, ^{
		_instance = [[LoginRadiusREST alloc]init];
    });
	return _instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [LRResponseSerializer serializer];
    }
    return self;
}

- (void)sendGET:(NSString *)url queryParams:(id)queryParams completionHandler:(LRAPIResponseHandler)completion {
    [self.manager GET:url parameters:queryParams progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)sendPOST:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion {
    NSString *requestUrl = queryParams ? [url stringByAppendingString:[queryParams queryString]]: url;

    [self.manager POST:requestUrl parameters:body progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)sendPUT:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion {
    NSString *requestUrl = queryParams ? [url stringByAppendingString:[queryParams queryString]]: url;

    [self.manager PUT:requestUrl parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

- (void)sendDELETE:(NSString *)url queryParams:(id)queryParams body:(id)body completionHandler:(LRAPIResponseHandler)completion {
    NSString *requestUrl = queryParams ? [url stringByAppendingString:[queryParams queryString]]: url;

    [self.manager DELETE:requestUrl parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completion(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

@end
