//
//  LoginRadiusREST.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusREST.h"
#import "NSDictionary+LRDictionary.h"
#import "NSError+LRError.h"
#import "LRResponseSerializer.h"

typedef NS_ENUM(NSUInteger, BASE_URL_ENUM) {
    API,
    CDN
};
#define BASE_URL_STRING(enum) [@[@"https://api.loginradius.com/",@"https://cdn.loginradius.com/"] objectAtIndex:enum]


@interface LoginRadiusREST()
@property(nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation LoginRadiusREST

+ (instancetype) apiInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusREST *_instance;
	dispatch_once(&onceToken, ^{
		_instance = [[LoginRadiusREST alloc]init:API];
    });
	return _instance;
}

+ (instancetype) cdnInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusREST *_instance;
	dispatch_once(&onceToken, ^{
		_instance = [[LoginRadiusREST alloc]init:CDN];
    });
	return _instance;
}

- (instancetype) init {
    return [self init: API];
}

- (instancetype) init:(BASE_URL_ENUM) baseUrlEnum {
    self = [super init];
    if (self) {
        _manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL_STRING(baseUrlEnum)]];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [LRResponseSerializer serializer];
        NSMutableSet *acceptableContentTypes = [[_manager.responseSerializer acceptableContentTypes] mutableCopy];
        [acceptableContentTypes addObject:@"application/javascript"];
        [_manager.responseSerializer setAcceptableContentTypes:acceptableContentTypes];
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
