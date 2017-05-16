//
//  LRClient.m
//  Pods
//
//  Created by Raviteja Ghanta on 20/02/17.
//
//

#import "LRClient.h"
#import "LRSession.h"

@implementation LRClient

+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	static LRClient *_instance;
	dispatch_once(&onceToken, ^{
		_instance = [[LRClient alloc]init];
	});
	return _instance;
}

- (void)getUserProfileWithAccessToken:(NSString *)token completionHandler:(LRAPIResponseHandler) completion {

    [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/userprofile"
                                  queryParams:@{
                                                @"access_token": token
                                                }
                            completionHandler:^(NSDictionary *userProfile, NSError *error) {
        if (error) {
            completion(nil, error);
		} else {
            LRSession *session = [[LRSession alloc] initWithAccessToken:token userProfile:userProfile];
			completion(session.userProfile, nil);
		}
    }];
}

@end
