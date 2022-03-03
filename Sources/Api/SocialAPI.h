//
//  SocialAPI.h
//  LoginRadiusSDK
//
//  Created by LoginRadius on 11/12/17.
//

#import <Foundation/Foundation.h>
#import "LoginRadius.h"


@interface SocialAPI : NSObject

+ (instancetype)socialInstance;
- (void)postMessageWithAccessToken:(NSString *)access_token
                 to:(NSString *)to
            subject:(NSString *)subject
            message:(NSString *)message
  completionHandler:(LRAPIResponseHandler)completion;

- (void)statusPostingWithAccessToken:(NSString *)access_token
                title:(NSString *)title
                  url:(NSString *)url
             imageurl:(NSString *)imageurl
               status:(NSString *)status
              caption:(NSString *)caption
          description:(NSString *)description
    completionHandler:(LRAPIResponseHandler)completion;

- (void)getAlbumWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getAudioWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getCheckInWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getCompanyWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getContactWithAccessToken:(NSString *)access_token
        nextcursor:(NSString *)nextcursor
 completionHandler:(LRAPIResponseHandler)completion;

- (void)getEventWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getFollowingWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getGroupWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getLikeWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getMentionWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;


- (void)getPageWithAccessToken:(NSString *)access_token
       pagename:(NSString *)pagename
completionHandler:(LRAPIResponseHandler)completion;

- (void)getPhotoWithAccessToken:(NSString *)access_token
         albumid:(NSString *)albumid
completionHandler:(LRAPIResponseHandler)completion;

- (void)getPostWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;

- (void)getStatusWithAccessToken:(NSString *)access_token completionHandler:(LRAPIResponseHandler)completion;


- (void)getVideoWithAccessToken:(NSString *)access_token
      nextcursor:(NSString *)nextcursor
completionHandler:(LRAPIResponseHandler)completion;

@end
