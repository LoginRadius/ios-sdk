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

## Installation
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
pod 'LoginRadiusSDK', '~> 3.3'
end
```
Then, run the following command:

```
$ pod install
```

## Demo
Link to [Demo app](https://github.com/LoginRadius/ios-sdk/tree/master/Example)

The demo app contains implementations of social login and user registration service.

Steps to setup Demo apps.

- Clone the repo.
- Run `pod install`
- Create a plist file named LoginRadius.plist and add it the demo project.
- Add your Sitename and API key in LoginRadius.plist
- For Native social login to work follow the documentation

## Documentation
You can find the full documentation for this library on that [LoginRadius API docs](https://docs.loginradius.com/api/v1/mobile-libraries/ios-library).

## Author

[LoginRadius](https://www.loginradius.com/)

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.