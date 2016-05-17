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

 1. Download the SDK and unzip the archive
 2. Drag the LRSDK.framework to Embedded Frameworks in Project Navigator.
 

## Before Getting Started
Import the module in your source code.

```
#import <LRSDK/LRSDK.h>
```

> For Swift projects, you need to create a Objective-C Bridging Header, please check the [wiki](https://developer.apple.com/library/ios/documentation/swift/conceptual/buildingcocoaapps/MixandMatch.html)

## Initilization

#### Application is launched

Initilize the SDK with your API key and Site name in your `AppDelegate.m`

Details on obtaining Site name [here](http://support.loginradius.com/hc/en-us/articles/204614109-How-do-I-get-my-LoginRadius-Site-Name-) and API key [here](http://apidocs.loginradius.com/docs/get-api-key-and-secret)


```objc
#import <LRSDK/LRSDK.h>
//  AppDelegate.m

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[LoginRadiusSDK instanceWithAPIKey:<your api key>
	                          siteName:<your site name>
	                       application:application
	                     launchOptions:launchOptions];
	//Your code
	return YES;
}
```


#### Application is asked to open URL

Call is to handle URL's for social login to work properly in your `AppDelegate.m`

```objc
#import <LRSDK/LRSDK.h>
//  AppDelegate.m

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return  [[LoginRadiusSDK sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}
```
## Usage

### Registration Service
Registration service supports traditional registration and login methods using hosted pages.

Supported actions are __login__, __registration__, __forgotpassword__, __social__

```
[LoginRadiusSDK registrationServiceWithAction:@"login" inController:self
completionHandler:^(BOOL success, NSError *error) {
	if (success) {
		NSLog(@"successfully logged in");
	} else {
		NSLog(@"Error: %@", [error description]);
	}
}];
```

Check the demo apps for user registration service.

### Social Login
Social Login with the given provider.

```
[LoginRadiusSDK socialLoginWithProvider:@"facebook" parameters:nil inController:self completionHandler:^(BOOL success, NSError *error) {
	if (success) {
		NSLog(@"successfully logged in with facebook");
	} else {
		NSLog(@"Error: %@", [error description]);
	}
}];

```

Check the demo app for social login.

> By default all social authentication will be done using Safari, if you want native integration set useNativeSocialLogin to YES after SDK initilisation
>`[LoginRadiusSDK sharedInstance].useNativeSocialLogin = YES;`
> LoginRadius iOS SDK only supports Facebook & Twitter native login, for detailed documentation please refer to [LoginRadius API docs](http://apidocs.loginradius.com/docs/ios-library).

### Logout
Log out the user.

```
[LoginRadiusSDK logout];
```
## Documentation
You can find the full documentation for this library on that [LoginRadius API docs](http://apidocs.loginradius.com/docs/ios-library).

## Author

[LoginRadius](https://www.loginradius.com/)

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.