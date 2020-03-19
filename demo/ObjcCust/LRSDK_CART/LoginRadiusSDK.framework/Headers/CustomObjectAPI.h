//
//  CustomObjectAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 13/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"
@interface CustomObjectAPI : NSObject
+ (instancetype)customInstance;


#pragma mark - Methods

- (void)createCustomObjectWithObjectName:(NSString*)objectname
                             accessToken:(NSString*)accessToken
                                    payload:(NSDictionary*)payload
                       completionHandler:(LRAPIResponseHandler)completion;


- (void)getCustomObjectWithObjectName:(NSString*)objectname
                          accessToken:(NSString*)accessToken
                    completionHandler:(LRAPIResponseHandler)completion;


- (void)getCustomObjectWithObjectRecordId:(NSString*)objectRecordId
                              accessToken:(NSString*)accessToken
                                     objectname:(NSString*)objectname
                        completionHandler:(LRAPIResponseHandler)completion;


- (void)updateCustomObjectWithObjectName:(NSString*)objectname
                             accessToken:(NSString*)accessToken
                          objectRecordId:(NSString*)objectRecordId
                               updatetype:(NSString*)updatetype
                                    payload:(NSDictionary*)payload
                       completionHandler:(LRAPIResponseHandler)completion;


- (void)deleteCustomObjectWithObjectRecordId:(NSString*)objectRecordId
                                 accessToken:(NSString*)accessToken
                                        objectname:(NSString*)objectname
                           completionHandler:(LRAPIResponseHandler)completion;



@end
