# LoginRadius iOS SDK
![Home Image](https://d2lvlj7xfpldmj.cloudfront.net/support/github/banner-1544x500.png)

## Introduction ##
LoginRadius is an Identity Management Platform that simplifies user registration while securing data. LoginRadius Platform simplifies and secures your user registration process, increases conversion with Social Login that combines 30 major social platforms, and offers a full solution with Traditional Customer Registration. You can gather a wealth of user profile data from Social Login or Traditional Customer Registration.

LoginRadius centralizes it all in one place, making it easy to manage and access. Easily integrate LoginRadius with all of your third-party applications, like MailChimp, Google Analytics, Livefyre and many more, making it easy to utilize the data you are capturing.

LoginRadius helps businesses boost user engagement on their web/mobile platform, manage online identities, utilize social media for marketing, capture accurate consumer data, and get unique social insight into their customer base.

Please visit [here](http://www.loginradius.com/) for more information.

## Requirements
You'll need iOS 8 or later.
This release have breaking changes from the previous SDK. Please refer to CHANGELOG.md.

## Install

 Download the project and open LR-iOS-SDK-Sample.xcodeproj in demo/LR-iOS-SDK-Sample/

## Starting Point

Change these to your loginradius apikey and loginradius siteName

```
#define CLIENT_SITENAME @"<your loginradius sitename>"
#define API_KEY @"<your loginradius apikey>"
```

Details on obtaining Site name [here](http://support.loginradius.com/hc/en-us/articles/204614109-How-do-I-get-my-LoginRadius-Site-Name-) and API key [here](http://apidocs.loginradius.com/docs/get-api-key-and-secret)


```objc
#import <LRSDK/LRSDK.h>
//  AppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [LoginRadiusSDK instanceWithAPIKey:API_KEY siteName:CLIENT_SITENAME application:application launchOptions:launchOptions];
    
    /* Uncomment this to use native social login.
     you need follow social login guide to add the neccessary keys to info.plist file
     http://apidocs.loginradius.com/v2.0/docs/ios-library-v3#section-native-social-login
    */
    
    //[LoginRadiusSDK sharedInstance].useNativeSocialLogin = YES;
    
    /* uncomment and set the desired language for user registration service
     default is english
     only supports spanish @"es" , german - @"de" && french - @"fr" 
    */
    
    // [LoginRadiusSDK sharedInstance].appLanguage = @"es";
    return YES;
}

```
You can enable/diable native social login by setting useNativeSocialLogin to YES/NO respectively.
You can set the appLanguage for registration service by setting appLanguage to @"es" or @"de" or @"fr" 

### Registration Service in action
Registration service supports traditional registration and login methods using hosted pages.

Supported actions are __login__, __registration__, __forgotpassword__, __social__

In `ViewController.m`

For Registration

```
- (IBAction)registerWithEmail:(id)sender {
    [LoginRadiusSDK registrationServiceWithAction:@"registration" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully registered");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

```

For Login

```
- (IBAction)loginWithEmail:(id)sender {
    [LoginRadiusSDK registrationServiceWithAction:@"login" inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}
```

### Social Login
Social Login with the given provider.

In `ViewController.m`

For twitter login
```
- (IBAction)loginWithTwitter:(id)sender {
    [LoginRadiusSDK socialLoginWithProvider:@"twitter" parameters:nil inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in with twitter");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

```

For Facebook native login. set useNativeSocialLogin to YES in AppDelegate.m for this to work. and follow the [apidocs](http://apidocs.loginradius.com/docs/ios-library)

```
- (IBAction)loginWithFacebook:(id)sender {
    [LoginRadiusSDK socialLoginWithProvider:@"facebook" parameters:@{@"facebookPermissions": @[@"public_profile", @"user_likes"]} inController:self completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"successfully logged in with facebook");
            [self showProfileController];
        } else {
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

```

###For fetching userprofile

In `DetailViewController.m`, check

```
- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSDictionary * profile =  [lrUser objectForKey:@"lrUserProfile"];
    NSString * fullname = [NSString stringWithFormat:@"%@ %@ %@", profile[@"FirstName"], profile[@"MiddleName"], profile[@"LastName"]];
    [self.name setText:fullname];
}

```

### Logout
In `DetailViewController.m`, check

```
- (IBAction)logoutPressed:(id)sender {
    [LoginRadiusSDK logout];
    [self.navigationController popViewControllerAnimated:YES];
}

```
## Documentation
You can find the full documentation for this library on that [LoginRadius API docs](http://apidocs.loginradius.com/docs/ios-library).

## Author

[LoginRadius](https://www.loginradius.com/)

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.