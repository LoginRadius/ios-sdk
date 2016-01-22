/*!
 @header LoginRadiusService.h
 
 @brief This file contains LoginRadiusService NSObject, which grants the access to LoginRadius Social APIs.
 
        Currently it only supports Post Status API.
 
 @author LoginRadius Team
 @copyright  2015 LoginRadius
 @version    2015-06
 @helper LoginRadiusUtilities.h
 */



#import <Foundation/Foundation.h>
#import "LoginRadiusServiceDelegate.h"

@interface LoginRadiusService : NSObject

/*!
    @property updatedUserProfile
    @deprecated
 */
@property NSMutableDictionary *updatedUserProfile;

/*!
    @property LoginRadiusServiceDelegate
    @
 */
@property (weak) id <LoginRadiusServiceDelegate> delegate;
/*!
 @function loginradiusUserProfile
 @deprecated Profile is getting in LoginRadiusLoginViewController
 */
- (void)loginradiusUserProfile: (NSString *)token;

/*!
 @function loginradiusPostStatus
 @brief Call LoginRadius Post Status API to post status into user's wall
 @param title The title of status
 @param description The actual body of your status
 @seealso https://apidocs.loginradius.com/v2.0/docs/status-posting
 @return Server response indicating the status of the post
 */

- (void)loginradiusPostStatus:(NSString *)title description:(NSString *)description;

/*!
 @function loginradiusContact
 @deprecated
 */
- (void)loginradiusContact: (NSString *)token :(NSString *)nextcursor;

@end

