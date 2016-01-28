/*!
 @header UserRegistrationServiceViewController.h
 
 @brief This ViewController contains the client side API call to LoginRadius User Registration Service, each time when you want to call an action,
 
 @author LoginRadius Team
 @copyright  2016 LoginRadius
 @version    2015-06
 @helps All other classes in the framework.
 */

#import <UIKit/UIKit.h>

@class UserRegistrationServiceViewController;

@protocol UserRegistrationDelegate

-(void) handleRegistrationResponse :(BOOL)status emailSent:(BOOL)sent;
-(void) handleForgotPasswordResponse :(BOOL)status emailSent:(BOOL)sent;

@end

@interface UserRegistrationServiceViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
}

/*!
 @property siteName
 @brief Your LoginRadius Site Name, you get it in your LoginRadius User Dashboard
 */
@property (nonatomic, retain) NSString *siteName;

/*!
 @property apiKey
 @brief Your LoginRadius API Key
 */
@property (nonatomic, retain) NSString *apiKey;

/*!
 @property action
 @brief ["register", "login", "forgotpassword", "social"]
 */
@property (nonatomic, retain) NSString *action;

@property (weak) id <UserRegistrationDelegate> urDelegate;


@end
