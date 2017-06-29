//
//  LoginRadiusCustomObjectManager.h
//
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"
/**
 *  Social Login Manager
 */
@interface LoginRadiusCustomObjectManager : NSObject

#pragma mark - Init

/**
 *  Initializer
 *  @return singleton instance
 */
+ (instancetype)sharedInstance;


#pragma mark - Methods
- (void)createCustomObjectWithName:(NSString*)name
                       accessToken:(NSString*)accessToken
                              data:(NSDictionary*)data
                 completionHandler:(LRAPIResponseHandler)completion;

- (void)getCustomObjectWithName:(NSString*)name
                    accessToken:(NSString*)accessToken
              completionHandler:(LRAPIResponseHandler)completion;

- (void)getCustomObjectWithName:(NSString*)name
                    accessToken:(NSString*)accessToken
                 objectRecordId:(NSString*)objectRecordId
              completionHandler:(LRAPIResponseHandler)completion;


- (void)putCustomObjectWithName:(NSString*)name
                    accessToken:(NSString*)accessToken
                 objectRecordId:(NSString*)objectRecordId
                           data:(NSDictionary*)data
              completionHandler:(LRAPIResponseHandler)completion;

- (void)deleteCustomObjectWithName:(NSString*)name
                       accessToken:(NSString*)accessToken
                    objectRecordId:(NSString*)objectRecordId
                 completionHandler:(LRAPIResponseHandler)completion;

#pragma mark - AppDelegate methods

- (void)applicationLaunchedWithOptions:(NSDictionary *)launchOptions;

@end
