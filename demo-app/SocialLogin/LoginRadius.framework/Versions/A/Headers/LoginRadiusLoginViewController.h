/*!
 @header LoginRadiusLoginViewController.h
 
 @brief It is a ViewController which generates the Social Platform Login Interface contained by UIWebView.
 
    It also handles the callback from the authentication results and notify the parent ViewController the status of the authentication.
 
 @author LoginRadius Team
 @copyright  2016 LoginRadius
 @version    2015-06
 @helps All other classes in the framework.
 */

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@class LoginRadiusLoginViewController;

/*!
  @protocol LoginDelegate
  @brief The delegate to notify the authentication from server.
 */
@protocol LoginDelegate

-(void)handleLoginResponse :(BOOL)isLoggedin :(BOOL)isBlocked;

@end

@interface LoginRadiusLoginViewController : UIViewController <UIWebViewDelegate> {
    UIWebView *webView;
}

/*!
    @property provider
    @brief NSString of Social Id provider being selected
 */
@property (nonatomic, retain) NSString *provider;
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
    @deprecated for twitterSecret, accountStore, accountType
 */
@property (nonatomic, retain) NSString *twitterSecret;
@property (nonatomic, retain) ACAccountStore *accountStore;
@property (nonatomic, retain) ACAccountType *accountType;
@property BOOL isConfigured;

/*!
    @property delegate
    @brief LoginDelegate
 */
@property (weak) id <LoginDelegate> delegate;

/*!
    @function checkNativeLoginConfiguration
    @brief It checks the native configuration for Twitter.
    @deprecated for now
 */
- (void)checkNativeLoginConfiguration;


@end
