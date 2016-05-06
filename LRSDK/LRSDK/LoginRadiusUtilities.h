//
//  LoginRadiusUtilities.h
//
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginRadiusUtilities.h"

@interface LoginRadiusUtilities : NSObject

/*!
 * @function sendSyncGetRequest
 * @brief Send a sync get request to the specified API url being passed in.
 * @param urlString The url address of the API server for the GET API call.
 * @return a NSMutableDictionary object contains the reponse from server.
 */
+ (NSMutableDictionary *)sendSyncGetRequest :(NSString *)urlString;


/*!
 * @function createPostAPIRequest
 * @brief Create a POST API call based on the passed in parameters
 * @param endpoint The url of the POST API.
 * @param method @"POST"
 * @param dataLength The length of the data in POST body
 * @param postData The post data in JSON format
 * @warning The header of @"Content-Type" is @"applciation/json"
 * @return a NSMutableRequest request for the POST API call
 */
+ (NSMutableURLRequest *)createPostAPIRequest :(NSString *)endpoint :(NSString *)method :(NSString *)dataLength :(NSData *)postData;


/*!
    @function parseDatatoJsonData
    @brief Parse the NSMutableDictionary data into JSON format and return
    @param data The data of the body of the POST call
    @return NSData of the passed in data
 */
+ (NSData *)parseDatatoJsonData :(NSMutableDictionary *)data;

+ (BOOL)lrSaveUserData :(NSMutableDictionary *)userProfile lrToken:(NSString *)token;

+ (BOOL)lrSaveUserRaaSData :(NSString *)token APIKey:(NSString *)key;

+ (NSMutableDictionary *)lrGetUserProfile :(NSString *)token;

+ (NSMutableDictionary *)lrGetUserLinkedProfile :(NSString *)token APIKey:(NSString *)key;
@end