/*!
 @header LoginRadiusUserRegistration.h
 
 @brief This class handles all the actions relate with LoginRadius User Registration services.
 It includes: Register, Login, ForgotPassword, Facebook Native Login, and Logout.
 Social Login will not be handled here, it is handled in LoginRadiusLoginViewController.
 
 @author LoginRadius Team
 @copyright  2015 LoginRadius
 @version    2015-06
 @helper LoginRadiusUtilities.h
 */

#import <Foundation/Foundation.h>
#import "LoginRadiusUtilities.h"

@class LoginRadiusUserRegistration;


/*!
    @protocol responseDelegate
    @discussion ResponseDelegate handles the reponse of User Registration services.
    @param status To indicate if the action succeeds or not.
    @param response It contains the response message.
 */
@protocol responseDelegate

-(void)handleResponse :(BOOL)status :(NSDictionary *)response;

@end



@interface LoginRadiusUserRegistration : NSObject <responseDelegate>
/*!
 * @brief The Delegate of LoginRadius User Registrtation, to call the callback of the parent Class.
 */

@property (weak) id <responseDelegate> delegate;
/*!
 * @function lrRegister
 * @brief LoginRadius REGISTER service through Email
 * @param key LoginRadius API Key
 * @param secret LoginRadius API Secret
 * @result It will send an email to User's email verification url to identify it is a valid user
 * @return Nothing will be returned other than calling delegate to notify the action is done
 */
- (void)lrRegister :(NSString *)key :(NSString *)secret :(NSMutableDictionary *)registerData;

/*!
 * @function lrLogin
 * @brief LoginRadius LOGIN service through Email
 * @param key LoginRadius API Key
 * @param secret LoginRadius API Secret
 * @param username The username of the user account, most of time it is the email address.
 * @param password The user's password.
 * @result A User object will be caught, and saved into NSUserDefault
 * @return Nothing will be returned other than calling delegate to notify the action is done
 */
- (void)lrLogin :(NSString *)key :(NSString *)secret :(NSString *)username :(NSString *)password;

/*!
 * @function lrForgotPassword
 * @brief LoginRadius FORGOT PASSWORD service through Email
 * @param key LoginRadius API Key
 * @param email The email address LoginRadius will send a notification email to ask the user to reset his password.
 * @param forgotpasswordUrl The web url which contains the function to reset the user's password.
 * @warning The webpage of forgotpasswordUrl must contain the logic to handle the url being passed in and call the function in LoginRadius
 * User Registration SDK.
 * @seealso https://apidocs.loginradius.com/v2.0/docs/user-registration
 * @return Nothing will be returned other than calling delegate to notify the action is done
 */
- (void)lrForgotPassword :(NSString *)key :(NSString *)email :(NSString *)forgotpasswordUrl;

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

extern NSString *const REGISTER_URL;
extern NSString *const LOGIN_URL;
extern NSString *const FORGOTPASSWORD_URL;
extern NSString *const NATIVE_AUTH_URL;
