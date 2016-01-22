/*!
 @header LoginRadiusUserRegistration.h
 
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
 @seealso http://apidocs.loginradius.com/v2.0/docs/status-posting
 @return Server response indicating the status of the post
 */

- (void)loginradiusPostStatus:(NSString *)title description:(NSString *)description;

/*!
 @function loginradiusContact
 @deprecated
 */
- (void)loginradiusContact: (NSString *)token :(NSString *)nextcursor;

/*!
 * @function lrFbNativeLogin
 * @brief This method handles the reponse returned from Facebook IOS SDK
 * It exchanges for a LoginRadius access token with the native Facebook access token and saves the user object.
 * @param key LoginRadius API Key.
 * @param token Facebook access toke from Facebook IOS SDK.
 * @return Nothing will be returned other than calling delegate to notify the action is done
 */
- (BOOL)lrFbNativeLogin :(NSString *)key :(NSString *)token;

/*!
 * @function lrLogout
 * @brief LoginRadius user logout, it clears ALL the WebView cookies and remove all the saved info inside NSUserDefault
 * @return Nothing will be returned other than calling delegate to notify the action is done
 */
- (void)lrLogout;

@end

extern NSString *const NATIVE_AUTH_URL;

