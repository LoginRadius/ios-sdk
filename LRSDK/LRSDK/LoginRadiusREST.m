//
//  LoginRadiusREST.m
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "LoginRadiusREST.h"
#import "NSDictionary+LRDictionary.h"

NSString *const API_BASE_URL = @"https://api.loginradius.com/";

@implementation LoginRadiusREST

+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	static LoginRadiusREST *_instance;
	dispatch_once(&onceToken, ^{
		_instance = [[LoginRadiusREST alloc]init];
	});
	return _instance;
}

- (void)callAPIEndpoint:(NSString*)endpoint
				 method:(NSString*)httpMethod
				 params:(NSDictionary*)params
	  completionHandler:(LRAPIResponseHandler)completion {

	NSURL* url = [self clientURLRequest:endpoint params:params];
	if ([httpMethod isEqualToString:@"GET"]) {
		[self sendGET:url completionHandler:completion];
	} else if ([httpMethod isEqualToString:@"POST"]) {
		[self sendPOST:url completionHandler:completion];
	}
}

- (NSURL*)clientURLRequest:(NSString*)path params:(NSDictionary*) params {
	NSString* str = [API_BASE_URL stringByAppendingString:path];
	#pragma GCC diagnostic push
	#pragma GCC diagnostic ignored "-Wdeprecated"
	return [NSURL URLWithString:[[str stringByAppendingString:[params queryString]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	#pragma GCC diagnostic pop
}

- (void)sendPOST :(NSURL *)url completionHandler:(LRAPIResponseHandler)completion {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	[[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

		// TODO: Pass all the error logging functionality to a separate class
		if (error) {
			NSLog(@"Network error: %@", error);
			return;
		}

		if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
			NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
			if (200 <= statusCode && statusCode <= 299) {
				NSError *parseError;
				id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
				if (!responseObject) {
					NSLog(@"JSON parse error: %@", parseError);
					completion(nil, parseError);
				} else {
					completion(responseObject, nil);
				}
			} else {
				NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
			}
		}
	}] resume];
}

- (void)sendGET :(NSURL *)url completionHandler:(LRAPIResponseHandler)completion {
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSURLSession * session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
	[[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

		// TODO: Pass all the error logging functionality to a separate class
		if (error) {
			NSLog(@"Network error: %@", error);
			return;
		}

		if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
			NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
			if (200 <= statusCode && statusCode <= 299) {
				NSError *parseError;
				id responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
				if (!responseObject) {
					NSLog(@"JSON parse error: %@", parseError);
					completion(nil, parseError);
				} else {
					completion(responseObject, nil);
				}
			} else {
				// TODO: pass this to logging system
				NSLog(@"Expected responseCode == 200; received %ld", (long)statusCode);
			}
		}
	}] resume];
}
@end
