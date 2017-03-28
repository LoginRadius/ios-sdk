# LoginRadius iOS SDK
![Home Image](https://d2lvlj7xfpldmj.cloudfront.net/support/github/banner-1544x500.png)

## Introduction ##
LoginRadius is an Identity Management Platform that simplifies user registration while securing data. LoginRadius Platform simplifies and secures your user registration process, increases conversion with Social Login that combines 30 major social platforms, and offers a full solution with Traditional Customer Registration. You can gather a wealth of user profile data from Social Login or Traditional Customer Registration.

LoginRadius centralizes it all in one place, making it easy to manage and access. Easily integrate LoginRadius with all of your third-party applications, like MailChimp, Google Analytics, Livefyre and many more, making it easy to utilize the data you are capturing.

LoginRadius helps businesses boost user engagement on their web/mobile platform, manage online identities, utilize social media for marketing, capture accurate consumer data, and get unique social insight into their customer base.

Please visit [here](http://www.loginradius.com/) for more information.

## Requirements
You'll need iOS 8 or later.

> **This release has breaking changes from the previous SDK.**

> This version is a complete revamp of the previous SDK. Please refer to the [changelog](https://github.com/LoginRadius/ios-sdk/blob/master/CHANGELOG.md)
 for a complete list of changes and improvements.

###Installation
We recommend to use CocoaPods for installing the library in a project.

[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like AFNetworking in your projects. See the ["CocoaPods" documentation for more information](https://guides.cocoapods.org/). You can install it with the following command:

```
$ gem install cocoapods
```

__Podfile__

To integrate LRSDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'LoginRadiusSDK', :git => 'https://github.com/LoginRadius/ios-sdk.git', :tag => '4.0.0-beta'
end
```
Then, run the following command:

```
$ pod install
```

###Initailize SDK

1. Create a new File `LoginRadius.plist` and add it to your App

2. Add the following entries to your `LoginRadius.plist`

  |   Key             |  Value
  | :------------:        | :------------:
  | ApiKey              |       Your LoginRadius API Key
  | SiteName              |       Your LoginRadius Sitename


  > Obtaining Sitename and API key

  > Details on obtaining Sitename [here](http://support.loginradius.com/hc/en-us/articles/204614109-How-do-I-get-my-LoginRadius-Site-Name-) and API key [here](https://docs.loginradius.com/account-settings/get-api-key-and-secret)


1. Import the module in your source code.

```
#import <LoginRadiusSDK/LoginRadius.h>

```


> Swift

> For Swift projects, you need to create an Objective-C Bridging Header, please check [Apple Documentation](https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html)

__Application is launched__

Initilize the SDK with your API key and Site name in your `AppDelegate.m`


```
//  AppDelegate.m

#import <LoginRadiusSDK/LoginRadius.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  LoginRadiusSDK * sdk =  [LoginRadiusSDK instance];
   [sdk applicationLaunchedWithOptions:launchOptions];
    //Your code
  return YES;
}
```


__Application is asked to open URL__

Call this to handle URL's for social login to work properly in your `AppDelegate.m`

```
//  AppDelegate.m

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[LoginRadiusSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
```


###Integrate Registration Service
Registration service supports traditional registration and login methods.

Registration Service is done through Authentication API.

Registration requires a parameter called SOTT. You can create the SOTT token by following this [doc](http://apidocs.loginradius.com/v2.0/user-registration/sott)

**Registration by Email:**

```
[[LoginRadiusRegistrationManager sharedInstance] authRegistrationWithData:@{
                                                                            @"Email": @[
                                                                                      @{
                                                                                          @"Type": @"Primary",
                                                                                          @"Value": @"test@gmail.com"
                                                                                      }
                                                                                      ],
                                                                            @"Password": @"password"
                                                                            }
                                                                 withSott:@"<your sott here>"
                                                          verificationUrl:@"<your verification url>"
                                                            emailTemplate:@""
                                                        completionHandler:^(NSDictionary *data, NSError *error) {
                                                                                if (!error) {
                                                                                    // Registration only registers the user. Call login to set the session
                                                                                    NSLog(@"successfully reg %@", data);
                                                                                } else {
                                                                                    NSLog(@"Error: %@", [error description]);
                                                                                }
                                                                            }];
```

> Registration API will only creates an userprofile. To retrieve access_token and set session, please call
> Login API.

For all the possible Data Fields. Please check the User Registration by Email [API](http://apidocs.loginradius.com/v2.0/user-registration/AuthUserRegistrationbyEmail)


**Login by Email:**

Call this function to Login in the User and set the session.

```
[[LoginRadiusRegistrationManager sharedInstance] authLoginWithEmail:@"test@gmail.com"
                                                       withPassword:@"password"
                                                           loginUrl:@""
                                                    verificationUrl:@""
                                                      emailTemplate:@""
                                                  completionHandler:^(NSDictionary *data, NSError *error) {
                                                    if (!error) {
                                                        NSLog(@"successfully logged in %@", data);

                                                    } else {
                                                        NSLog(@"Error: %@", [error description]);
                                                    }
                                                }];
```

After successfull login you can fetch the token, user profile like this,

```
// Check for `isLoggedIn` on app launch to check if the user is logged in.

NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
NSDictionary *profile =  [lrUser objectForKey:@"lrUserProfile"];
NSString *access_token =  [lrUser objectForKey:@"lrAccessToken"];
NSString *alreadyLoggedIn =  [lrUser objectForKey:@"isLoggedIn"];

```

For all available API's in iOS SDK, please check `LoginRadiusRegistrationManager.h`.
For all available LoginRadius API's, please check [API Docs](http://apidocs.loginradius.com/v2.0/getting-started/introduction).

###Integrate Social Login

#### Traditional Social Login
Social Login with the given provider. Call this function in the view controller you have setup for the button views.

Provider name is uncapitalized. e.g facebook, twitter, linkedin, google e.t.c
For complete list of social login providers: Ref to this [support doc](https://support.loginradius.com/hc/en-us/articles/202078178-What-Social-ID-providers-are-supported-by-LoginRadius-)

```
// Social Login using SFSafariViewController or UIWebview

[[LoginRadiusSocialLoginManager sharedInstance] loginWithProvider:@"facebook" inController:self completionHandler:^(BOOL success, NSError *error) {
    if (success) {
        NSLog(@"Successfully logged in with facebook");
    } else {
        NSLog(@"Error: %@", [error description]);
    }
}];

```
#### Native Social Login

**Facebook native login**

> For Native facebook login to work, configure the Xcode project as per the facebook docs. https://developers.facebook.com/docs/ios/getting-started#xcode

Call the function to start Facebook Native Login.

```

/**
 *  Native Login with Facebook
 *
 *  @param params     dict of parameters
                            These are the valid keys
                            - facebookPermissions : should be an array of strings
                            - facebookLoginBehavior : should be FBSDKLoginBehaviorNative / FBSDKLoginBehaviorBrowser / FBSDKLoginBehaviorSystemAccount / FBSDKLoginBehaviorWeb
                            recommended approach is to use FBSDKLoginBehaviorNative
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */

[[LoginRadiusSocialLoginManager sharedInstance] nativeFacebookLoginWithPermissions: @{
                  @"facebookPermissions": @[@"public_profile"]
                }
                inController:self
             completionHandler:^(BOOL success, NSError *error) {
    if (success) {
        NSLog(@"Successfully logged in with facebook");
    } else {
        NSLog(@"Error: %@", [error description]);
    }
}];

```

<br>

**Twitter native login**

Call the function to start Twitter Native Login.

```

/**
 *  Native Login with Twitter
 *  @param consumerKey Your twitter app Consumer Key
 *  @param consumerSecret Your twitter app Consumer Secret
 *  @param controller view controller where social login take place should not be nil
 *  @param handler    code block executed after completion
 */


[[LoginRadiusSocialLoginManager sharedInstance] nativeTwitterWithConsumerKey:@"<you twitter consumer key>"
                                                              consumerSecret:@"<you twitter consumer secret>"
                                                                inController:self
                                                           completionHandler:^(BOOL success, NSError *error) {
    if (success) {
        NSLog(@"successfully logged in with twitter");

    } else {
        NSLog(@"Error: %@", [error description]);
    }
}];

```

> We suggest you to OBFUSCATE YOUR KEYS.

**Google native login**

For Google Native Login configure your app, according to the steps described in the [documentation](https://developers.google.com/identity/sign-in/ios/start-integrating) for Google.

Add Google Sign In by following the [documentation](https://developers.google.com/identity/sign-in/ios/sign-in)

As the final step as per [documentation](https://developers.google.com/identity/sign-in/ios/backend-auth), you have to exchange Google token with LoginRadius Token. Call the following function.

```
- (void)signIn:(GIDSignIn *)signIn
    didSignInForUser:(GIDGoogleUser *)user
           withError:(NSError *)error {
  NSString *idToken = user.authentication.accessToken;
  [[LoginRadiusSocialLoginManager sharedInstance] nativeGoolgleLoginWithAccessToken: idToken
                                                                  completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in with google");

        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

```

###Logout
Log out the user.

```
[LoginRadiusSDK logout];

```

###Demo
Link to [Demo app](https://github.com/LoginRadius/ios-sdk/tree/master/Example)

The demo app contains implementations of social login and user registration service.

Steps to setup Demo apps.

- Clone the repo.
- Run `pod install`
- Create a plist file named LoginRadius.plist and add it the demo project.
- Add your Sitename and API key in LoginRadius.plist
- For Native social login to work follow the Social Login guide above.

## Documentation
You can find the full documentation for this library on that [LoginRadius API docs](https://apidocs.loginradius.com/v2.0/mobile-libraries/ios-library).

## Author

[LoginRadius](https://www.loginradius.com/)

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.
