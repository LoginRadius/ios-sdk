//
//  LRClient.m
//  Pods
//
//  Created by Raviteja Ghanta on 20/02/17.
//
//

#import "LRClient.h"
#import "LRUserProfile.h"

@implementation LRClient

+ (instancetype) sharedInstance {
	static dispatch_once_t onceToken;
	static LRClient *_instance;
	dispatch_once(&onceToken, ^{
		_instance = [[LRClient alloc]init];
	});
	return _instance;
}

- (BOOL)getUserProfileWithAccessToken:(NSString *)token completionHandler:(LRAPIResponseHandler) completion {

    [[LoginRadiusREST sharedInstance] sendGET:@"api/v2/userprofile"
                                  queryParams:@{
                                                @"access_token": token
                                                }
                            completionHandler:^(NSDictionary *userProfile, NSError *error) {

		LRUserProfile *profile = [[LRUserProfile alloc] initWithDictionary:userProfile];
		NSString *uid = [userProfile objectForKey:@"Uid"];

		if (uid && ![uid isEqualToString: @""]) {
			[[LoginRadiusREST sharedInstance] sendGET:@"raas/client/auth/linkedprofiles"
										  queryParams:@{
														@"appkey": [LoginRadiusSDK apiKey],
														@"access_token": token
														}
									completionHandler:^(NSDictionary *data, NSError *error) {

									}];
		} else {
			completion(profile, nil);
		}
    }];
}

@end
