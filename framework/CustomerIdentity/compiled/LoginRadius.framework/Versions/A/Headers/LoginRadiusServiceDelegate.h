/*!
 @header LoginRadiusServiceDelegate.h
 
 @brief This class contains the protocol to handle the callback of the LoginRadius service call.
 
 @author LoginRadius Team
 @copyright  2016 LoginRadius
 @version    2015-06
 @helps All other classes in the framework.
 */

@class LoginRadiusService;

/*!
   @protocol LoginRadiusServiceDelegate
 */
@protocol LoginRadiusServiceDelegate <NSObject>

@optional

- (void)LoginRadiusPostStatusSuccess: (BOOL)statusWall;

@end