Pod::Spec.new do |s|

s.name         = 'LoginRadiusSDK'
s.version      = '3.3.1'
s.summary      = 'Official LoginRadius SDK for iOS to integrate User Registration Service or Social Login in your app.'

s.description  = <<-DESC
LoginRadius is an Identity Management Platform that simplifies user registration and social login while securing data.

The SDK provides the following

* Traditional User Registration and Login services.
* Social login with various social network providers.
* Native facebook and twitter login

DESC

s.homepage     = 'https://github.com/LoginRadius/ios-sdk/'
s.license      = 'MIT'
s.authors             = { 'LoginRadius' => 'support@loginradius.com'}, { 'Raviteja Ghanta' => 'ravi@loginradius.com' }
s.social_media_url   = 'https://twitter.com/LoginRadius'

s.ios.deployment_target = '8.0'

s.source       = { :git => 'https://github.com/LoginRadius/ios-sdk.git', :tag => "#{s.version}" }

s.source_files = ['Core/**/*.{h,m}', 'FacebookNative/*.{h,m}', 'RegistrationService/*.{h,m}', 'SocialLogin/*.{h,m}', 'TwitterNative/**/*.{h,m}', 'TouchID/*.{h,m}']

s.dependency 'FBSDKLoginKit', '~> 4.16'
s.dependency 'AFNetworking', '~> 3.1'
s.dependency 'OAuthCore', '~> 0.0.1'

s.ios.frameworks = 'Foundation', 'UIKit', 'SystemConfiguration', 'Social', 'Accounts', 'SafariServices'

end
