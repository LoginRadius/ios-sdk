#
# Be sure to run `pod lib lint LoginRadiusSwiftSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LoginRadiusSwiftSDK'
  s.version          = '1.0.0'
  s.summary          = 'Official LoginRadius SDK for iOS to integrate User Registration Service or Social Login in your app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description  = <<-DESC
LoginRadius is an Identity Management Platform that simplifies user registration and social login while securing data.

The SDK provides the following

* Traditional User Registration and Login services.
* Social login with various social network providers.
* Native facebook and twitter login

DESC


  s.homepage         = 'https://github.com/LoginRadius/ios-swift-sdk.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.authors             = { 'LoginRadius' => 'support@loginradius.com'}
  s.social_media_url   = 'https://twitter.com/LoginRadius'
  s.source           = { :git => 'https://github.com/LoginRadius/ios-swift-sdk.git', :tag => "#{s.version}" }

  s.ios.deployment_target = '11.0'

  s.source_files = s.source_files = ['Sources/**/*']
  
  # s.resource_bundles = {
  #   'MyLibrary' => ['MyLibrary/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  
  s.swift_version = '5.0'
  
  s.dependency 'FBSDKLoginKit', '~> 14.1.0'
  

  s.ios.frameworks = 'Foundation', 'UIKit', 'SystemConfiguration', 'Social', 'Accounts', 'SafariServices'
end
