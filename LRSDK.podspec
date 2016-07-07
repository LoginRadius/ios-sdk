Pod::Spec.new do |s|

s.name         = 'LRSDK'
s.version      = '3.0.1'
s.summary      = 'A library that helpes integrating the LoginRadius User Registration Service or Social Login in an iOS app.'

s.description  = <<-DESC
LoginRadius is an Identity Management Platform that simplifies user registration and social login while securing data.
DESC

s.homepage     = 'https://github.com/LoginRadius/ios-sdk/'
s.license      = 'MIT'
s.authors             = { 'LoginRadius' => 'support@loginradius.com'}, { 'Raviteja Ghanta' => 'ravi@loginradius.com' }
s.social_media_url   = 'https://twitter.com/LoginRadius'

s.platform     = :ios, '8.0'

s.source       = { :git => 'https://github.com/LoginRadius/sdk-ios-customer-identity.git', :branch => 'dev'}

s.source_files = 'LRSDK/**/*.{h,m}'

s.dependency 'FBSDKLoginKit', '~> 4.13'

s.requires_arc = ['LRSDK/Classes/*.{h,m}', 'LRSDK/FacebookNative/*.{h,m}', 'LRSDK/RegistrationService/*.{h,m}', 'LRSDK/SocialLogin/*.{h,m}', 'LRSDK/TwitterNative/*.{h,m}']
end