# LoginRadius iOS SDK
![Home Image](http://docs.lrcontent.com/resources/github/banner-1544x500.png)

## Introduction ##
LoginRadius is an Identity Management Platform that simplifies user registration while securing data. LoginRadius Platform simplifies and secures your user registration process, increases conversion with Social Login that combines 30 major social platforms, and offers a full solution with Traditional Customer Registration. You can gather a wealth of user profile data from Social Login or Traditional Customer Registration.

LoginRadius centralizes it all in one place, making it easy to manage and access. Easily integrate LoginRadius with all of your third-party applications, like MailChimp, Google Analytics, Livefyre and many more, making it easy to utilize the data you are capturing.

LoginRadius helps businesses boost user engagement on their web/mobile platform, manage online identities, utilize social media for marketing, capture accurate consumer data, and get unique social insight into their customer base.

Please visit [here](http://www.loginradius.com/) for more information.

## Documentation
For full documentation visit [here](https://docs.loginradius.com/api/v2/mobile-libraries/ios-library)

## Author

[LoginRadius](https://www.loginradius.com/)

## License

This project is licensed under the MIT license. See the [LICENSE](LICENSE) file for more info.


#### There are three projects in the library:
a. ObjCDemo - This is the demo application in objective-c.<br>
a. SwiftDemo - This is the demo application in Swift(Supported Swift version 4.2).<br>
b. LoginRadiusSDK -This is the LoginRadius SDK.


## Installing

We recommend using CocoaPods for installing the library in a project.

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:

```
$ gem install cocoapods
```

To integrate LRSDK into your Xcode project using CocoaPods, specify it in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'

target 'TargetName' do

#Comment the next line if you don't want to use dynamic frameworks
use_frameworks!
pod 'LoginRadiusSDK', '~> 5.8.0'
end

```

Then, run the following command:

```
$ pod install

```
