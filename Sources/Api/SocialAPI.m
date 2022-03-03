//
//  SocialAPI.m
//  LoginRadiusSDK
//
//  Created by LoginRadius on 11/12/17.
//

#import "SocialAPI.h"

@implementation SocialAPI

+ (instancetype)socialInstance{
    static dispatch_once_t onceToken;
    static SocialAPI *instance;
    
    dispatch_once(&onceToken, ^{
        instance = [[SocialAPI alloc] init];
    });
    
    return instance;
}




                /* ******************************* Post Method  **********************************/

- (void)postMessageWithAccessToken:(NSString *)access_token
                 to:(NSString *)to
          subject:(NSString *)subject
          message:(NSString *)message
     completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPOST:@"api/v2/message"
                                 queryParams:@{
                                               @"access_token": access_token,
                                               @"to": to,
                                               @"subject": subject,
                                               @"message": message
                                               }
                                         body:@{}
                           completionHandler:completion];
    
}

- (void)statusPostingWithAccessToken:(NSString *)access_token
                 title:(NSString *)title
                 url:(NSString *)url
                 imageurl:(NSString *)imageurl
                 status:(NSString *)status
                 caption:(NSString *)caption
                 description:(NSString *)description
  completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendPOST:@"api/v2/status"
                                  queryParams:@{
                                                @"access_token": access_token,
                                                @"title": title,
                                                @"url": url,
                                                @"imageurl": imageurl,
                                                @"status": status,
                                                @"caption": caption,
                                                @"description": description
                                                }
                                         body:@{}
                            completionHandler:completion];
    
}


           /* ******************************* Get Method  **********************************/


- (void)getAlbumWithAccessToken:(NSString *)access_token
    completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/album"
                                queryParams:@{
                                              @"access_token": access_token
                                             }
                       completionHandler:completion];
    
}

- (void)getAudioWithAccessToken:(NSString *)access_token
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/audio"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getCheckInWithAccessToken:(NSString *)access_token
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/checkin"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getCompanyWithAccessToken:(NSString *)access_token
 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/company"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getContactWithAccessToken:(NSString *)access_token
                   nextcursor:(NSString *)nextcursor
 completionHandler:(LRAPIResponseHandler)completion {
    NSString *next_cursor = nextcursor ? nextcursor: @"";
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/contact"
                               queryParams:@{
                                             @"access_token": access_token,
                                             @"nextcursor": next_cursor
                                             }
                         completionHandler:completion];
    
}

- (void)getEventWithAccessToken:(NSString *)access_token
 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/event"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}
- (void)getFollowingWithAccessToken:(NSString *)access_token
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/following"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getGroupWithAccessToken:(NSString *)access_token
   completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/group"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getLikeWithAccessToken:(NSString *)access_token
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/like"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getMentionWithAccessToken:(NSString *)access_token
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/mention"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getPageWithAccessToken:(NSString *)access_token
                pagename:(NSString *)pagename
 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/page"
                               queryParams:@{
                                             @"access_token": access_token,
                                             @"pagename":pagename
                                             }
                         completionHandler:completion];
    
}

- (void)getPhotoWithAccessToken:(NSString *)access_token
       albumid:(NSString *)albumid
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/photo"
                               queryParams:@{
                                             @"access_token": access_token,
                                             @"albumid":albumid
                                             }
                         completionHandler:completion];
    
}

- (void)getPostWithAccessToken:(NSString *)access_token
 completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/post"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getStatusWithAccessToken:(NSString *)access_token
completionHandler:(LRAPIResponseHandler)completion {
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/status"
                               queryParams:@{
                                             @"access_token": access_token
                                             }
                         completionHandler:completion];
    
}

- (void)getVideoWithAccessToken:(NSString *)access_token
        nextcursor:(NSString *)nextcursor
 completionHandler:(LRAPIResponseHandler)completion {
     NSString *next_cursor = nextcursor ? nextcursor: @"";
    
    [[LoginRadiusREST apiInstance] sendGET:@"api/v2/video"
                               queryParams:@{
                                             @"access_token": access_token,
                                             @"nextcursor": next_cursor
                                             }
                         completionHandler:completion];
    
}

@end
