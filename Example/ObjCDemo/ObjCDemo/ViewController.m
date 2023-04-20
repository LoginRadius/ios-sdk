//
//  ViewController.m
//  ObjCDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "ViewController.h"
#import "LoginRadius.h"
#import "DetailViewController.h"
#import "XLFormViewControllerExtension.h"
#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()
@property ( nonatomic, nullable)  BOOL *isEmailAvailable;
@property ( nonatomic, nullable) NSArray<NSString *> *socialProviders;
@property ( nonatomic, nullable) NSTimer *socialLoadingTimer;
@property ( nonatomic) int socialLoadingDots;
@property ( nonatomic, nullable) NSTimer *registrationLoadingTimer;
@property ( nonatomic) int registrationLoadingDots;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Check if already login
    if([[[LoginRadiusSDK sharedInstance] session] isLoggedIn])
    {
        [self showProfileController];
    }
    
    /* Google Native SignIn
     [GIDSignIn sharedInstance].uiDelegate = self;
     */
    [self setupForm];
    
    [[ConfigurationAPI configInstance] getConfigurationSchema:^(NSDictionary *data, NSError *error) {
        
        if (data[@"SocialSchema"]){
            
            [[LoginRadiusSchema sharedInstance] setSchema:data];
            NSArray<LoginRadiusField *> *rFields = [[LoginRadiusSchema sharedInstance] providers];
            
            NSMutableArray *providersList = [[NSMutableArray alloc] init];
            for (LoginRadiusField *provider in rFields)
            {
                [providersList addObject:[provider providerName]];
            }
           self.socialProviders = providersList;
            
          }else{
              
         [self showAlert:@"ERROR" message:[error localizedDescription]];
     }
     
     dispatch_async(dispatch_get_main_queue(), ^(void)
                    {
                        [[self socialLoadingTimer] invalidate];
                        [self setupSocialLoginForm];
                    });
     }];
    
    self.socialLoadingTimer = [NSTimer scheduledTimerWithTimeInterval:0.25 target:self selector:@selector(updateSocialLoadingText) userInfo:nil repeats:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([[[LoginRadiusSDK sharedInstance] session] isLoggedIn])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showProfileController)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateSocialLoadingText
{
    NSString *staticloadingTxt = @"Loading";
    NSMutableString *loadingTxt = [staticloadingTxt mutableCopy];
    
    _socialLoadingDots = (_socialLoadingDots + 1)%3;
    
    for (int i = 0; i <= _socialLoadingDots; i++)
    {
        [loadingTxt appendFormat:@"%c", '.'];
    }
    
    if ( [self.form formRowWithTag:@"SocialLoginsLoading"])
    {
        XLFormRowDescriptor *loadingRow = [self.form formRowWithTag:@"SocialLoginsLoading"];
        loadingRow.title = [loadingTxt copy];
        [self reloadFormRow:loadingRow];
    }
}

- (void) setupForm
{
    [[[self navigationController] navigationBar] topItem].title = @"LoginRadius ObjCDemo 5.5.0 🇮🇳";
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * switchRow;
    
    form = [XLFormDescriptor formDescriptor];
    
    //Login Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Traditional Login"];
    [form addFormSection:section];
    
    switchRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"Login" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Login"];
    switchRow.value = @0;
    [section addFormRow:switchRow];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"EmailLogin" rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    [row addValidator:[XLFormValidator emailValidator]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"PasswordLogin" rowType:XLFormRowDescriptorTypePassword title:@"Password"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Length of password must be at least 6" regex:@"^.{6,}$"]];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Login send" rowType:XLFormRowDescriptorTypeButton title:@"Login"];
    row.action.formSelector = @selector(traditionalLogin);
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [section addFormRow:row];
    //end of Login Section
    
    //Register Section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    switchRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"StaticRegistration" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Static Registration"];
    switchRow.value = @0;
    [section addFormRow:switchRow];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"EmailStaticRegister" rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    [row addValidator:[XLFormValidator emailValidator]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"PasswordStaticRegister" rowType:XLFormRowDescriptorTypePassword title:@"Password"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Length of password must be at least 6" regex:@"^.{6,}$"]];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ConfirmStaticPassword" rowType:XLFormRowDescriptorTypePassword title:@"Confirm Password"];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"StaticRegistrationSend" rowType:XLFormRowDescriptorTypeButton title:@"Register"];
    row.action.formSelector = @selector(requestSOTT);
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [section addFormRow:row];
    //end of Register Section
    
    //Forgot Password Section
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    switchRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"ForgotPassword" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"Forgot Password"];
    switchRow.value = @0;
    [section addFormRow:switchRow];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"EmailForgot" rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    [row addValidator:[XLFormValidator emailValidator]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"ForgotSend" rowType:XLFormRowDescriptorTypeButton title:@"Request Password"];
    row.action.formSelector = @selector(forgotPassword);
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [section addFormRow:row];
    //end of Forgot Password Section
    
    //Social Login Section
    if(![[[LoginRadiusSDK sharedInstance] session] isLoggedIn])
    {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Touch / Face ID"];
        [form addFormSection:section];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Touch / Face ID" rowType:XLFormRowDescriptorTypeButton title:@"Touch / Face ID"];
        row.action.formSelector = @selector(biometryType);
        [section addFormRow:row];
    }
    
    //Social Login Section
    section = [XLFormSectionDescriptor formSectionWithTitle:@"Normal Social Logins"];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"SocialLoginsLoading" rowType:XLFormRowDescriptorTypeInfo title:@"Loading"];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textLabel.textAlignment"];
    [section addFormRow:row];
    //end of Social PasswoLoginrd Section
    
    BOOL socialNativeLoginEnabled = (AppDelegate.useGoogleNative ||  AppDelegate.useTwitterNative || AppDelegate.useFacebookNative);
    
    if(socialNativeLoginEnabled)
    {
        section = [XLFormSectionDescriptor formSectionWithTitle:@"Native Social Login"];
        [form addFormSection:section];
    }
    
    if(AppDelegate.useGoogleNative)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(processGoogleNativeLogin:)
                                                     name:@"userAuthenticatedFromNativeGoogle"
                                                   object:nil];
        
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeGoogle" rowType:XLFormRowDescriptorTypeButton title:@"Google"];
        row.action.formSelector = @selector(showNativeGoogleLogin);
        [section addFormRow:row];
    }
    
    if(AppDelegate.useFacebookNative)
    {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeFacebook" rowType:XLFormRowDescriptorTypeButton title:@"Facebook"];
        row.action.formSelector = @selector(showNativeFacebookLogin);
        [section addFormRow:row];
    }
    
    if(AppDelegate.useTwitterNative)
    {
        row = [XLFormRowDescriptor formRowDescriptorWithTag:@"NativeTwitter" rowType:XLFormRowDescriptorTypeButton title:@"Twitter"];
        row.action.formSelector = @selector(showNativeTwitterLogin);
        [section addFormRow:row];
    }
    
    self.form = form;
}

- (void) setupSocialLoginForm
{
    int socialLoginIndex = 3;//careful on adding sections
    if(![[[LoginRadiusSDK sharedInstance] session] isLoggedIn])
    {
        socialLoginIndex += 1;
    }
    
    XLFormSectionDescriptor *socialLoginSection = [self.form formSectionAtIndex:socialLoginIndex];//careful on adding sections
    
    XLFormRowDescriptor *loadingRow = [self.form formRowWithTag:@"SocialLoginsLoading"];
    
    if(self.socialProviders)
    {
        for (int i = 0; i < [self.socialProviders count]; i++)
        {
            XLFormRowDescriptor * row;
            row = [XLFormRowDescriptor formRowDescriptorWithTag:self.socialProviders[i] rowType:XLFormRowDescriptorTypeButton title:self.socialProviders[i]];
            row.action.formBlock = ^(XLFormRowDescriptor *block)
            {
                [self showSocialLogins:self.socialProviders[i]];
            };
            
            [socialLoginSection addFormRow:row];
            
        }
        
        loadingRow.hidden = @YES;
    }else
    {
        loadingRow.title = @"No Social Providers";
    }
    [self reloadFormRow:loadingRow];
}

// Request SOTT from your own server, then do client side validation, you can do the other way around.
- (void) requestSOTT
{
    //You have to handle your own server, networking, and response processing
    //Replace this code with your own
    //asking "http://localhost:3000/sott"
    /*
     NSString *url = @"http://localhost:3000/";
     AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
     manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     
     [manager GET:@"sott" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     NSString *sottStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
     [self traditionalRegistration:sottStr];
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     [self showAlert:@"ERROR" message:[error localizedDescription]];
     }];
     */
    // Alternatively if you don't care about security then take
    // The SOTT staticly from LoginRadius Dashboard with the longest endDate
    
    NSString *sott = @"<your static sott>";
    [self traditionalRegistration:sott];
    
}

- (void) traditionalRegistration:(NSString *)sott
{
    XLFormRowDescriptor *emailRow = [[self form] formRowWithTag:@"EmailStaticRegister"];
    XLFormRowDescriptor *passRow = [[self form] formRowWithTag:@"PasswordStaticRegister"];
    XLFormRowDescriptor *conPassRow = [[self form] formRowWithTag:@"ConfirmStaticPassword"];
    
    NSMutableArray<XLFormValidationStatus *> *errors = [[NSMutableArray<XLFormValidationStatus *> alloc] init];
    [errors addObject:[emailRow doValidation]];
    [errors addObject:[passRow doValidation]];
    
    XLFormValidationStatus *matchPass = [[XLFormValidationStatus alloc] init];
    matchPass.msg = @"Password and Confirm Password do not match";
    matchPass.isValid = ([(NSString*)passRow.value isEqualToString:(NSString*)conPassRow.value]);
    [errors addObject:matchPass];
    
    for (int i = 0; i < [errors count]; i++)
    {
        if (!errors[i].isValid)
        {
            [self showAlert:@"ERROR" message:[errors[i] msg]];
            return;
        }
    }
    
    NSDictionary *email = @{
                            @"Type":@"Primary",
                            @"Value":[emailRow value]
                            };
    
    NSDictionary *parameter =   @{
                                  @"Email":@[email],
                                  @"Password":[passRow value]
                                  };
    
    
    
    [[AuthenticationAPI authInstance]  userRegistrationWithSott:sott  payload:parameter emailtemplate:nil smstemplate:nil preventVerificationEmail:TRUE completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
         if (error)
         {
             [self errorMessage:data error:error];
         }else
         {
             NSLog(@"successfully registered");
             [self showAlert:@"SUCCESS" message:@"Please verify your email"];
             
             
         }
     }];

    
  
}

- (void) traditionalLogin
{
    XLFormRowDescriptor *emailRow = [[self form] formRowWithTag:@"EmailLogin"];
    XLFormRowDescriptor *passRow = [[self form] formRowWithTag:@"PasswordLogin"];
   
    NSMutableArray<XLFormValidationStatus *> *errors = [[NSMutableArray<XLFormValidationStatus *> alloc] init];
    [errors addObject:[emailRow doValidation]];
    [errors addObject:[passRow doValidation]];
    for (int i = 0; i < [errors count]; i++)
    {
        if (!errors[i].isValid)
        {
            [self showAlert:@"ERROR" message:[errors[i] msg]];
            return;
        }
    }
    NSDictionary *parameter =   @{
                                  @"Email":[emailRow value],
                                  @"Password":[passRow value],
                                  @"securityanswer":@""
                                  };
    
    
   
        
    
    [[AuthenticationAPI authInstance] loginWithPayload:parameter loginurl:nil emailtemplate:nil smstemplate:nil g_recaptcha_response:nil completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
         if (error)
         {
            
             [self errorMessage:data error:error];
             
         }else
         {
            
             NSString *access_token= [data objectForKey:@"access_token"];
             NSDictionary *_data =[data objectForKey:@"Profile"];
             LRSession *session = [[LRSession alloc] initWithAccessToken:access_token userProfile:[[_data mutableCopy] replaceNullWithBlank]];
             NSLog(@"LRSession Store Token%@",session.accessToken);
             NSLog(@"LRSession Store UserProfile%@",session.userProfile);
             [self showProfileController];
         }
     }];
}


- (void) forgotPassword
{
    XLFormRowDescriptor *emailRow = [[self form] formRowWithTag:@"EmailForgot"];
    XLFormValidationStatus *status = [emailRow doValidation];
    if(!status.isValid)
    {
        [self showAlert:@"ERROR" message:status.msg];
        return;
    }
    
   
   [[AuthenticationAPI authInstance] forgotPasswordWithEmail:emailRow.value emailtemplate:nil completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
         if (error)
         {
             [self showAlert:@"ERROR" message:error.localizedDescription];
         }else
         {
             [self showAlert:@"SUCCESS" message:@"Check your email for reset link"];
         }
     }];
}

/* use web hosted page for resetting it
 - (void) resetPassword
 {
 }
 */

- (void) showSocialLogins:(NSString *)provider
{
    [[LoginRadiusSocialLoginManager sharedInstance] loginWithProvider:provider inController:self completionHandler:^(NSDictionary * data, NSError * error){
        if([error.localizedDescription  isEqual: @"Social Login cancelled"]){
            return;
        }
        
        NSString *access_token= [data objectForKey:@"access_token"];

            [[AuthenticationAPI authInstance] profilesWithAccessToken:access_token completionHandler:^(NSDictionary *response, NSError *error) {
                
                NSLog(@"get profile api error %@",error.localizedDescription);
                
                
                LRSession *session = [[LRSession alloc] initWithAccessToken:access_token userProfile:[[response mutableCopy] replaceNullWithBlank]];
                
                NSLog(@"LRSession Store Token%@",session.accessToken);
                NSLog(@"LRSession Store UserProfile%@",session.userProfile);
                
               
               [self showProfileController];
            }];
        
     }];
}

- (void) showNativeGoogleLogin
{
    /* Google Native SignIn
     
     if (self.presentedViewController != nil)
     {
     [self.presentedViewController dismissViewControllerAnimated:NO completion:^{[self showNativeGoogleLogin];}];
     return;
     }
     
     [[GIDSignIn sharedInstance] signIn];
     */
}

- (void) processGoogleNativeLogin:(NSNotification *)notif
{
    if (notif.userInfo)
    {
        if (![[notif.userInfo objectForKey:@"error"] isEqual:[NSNull null]])
        {
            [self errorMessage: ([notif.userInfo objectForKey:@"data"]) ? [notif.userInfo objectForKey:@"data"] : nil error:[notif.userInfo objectForKey:@"error"]];
        }else
        {
            NSDictionary *data= [notif.userInfo objectForKey:@"data"];
            NSString *access_token= [data objectForKey:@"access_token"];
            
            [[AuthenticationAPI authInstance] profilesWithAccessToken:access_token completionHandler:^(NSDictionary *response, NSError *error) {
                
                NSLog(@"get profile api error %@",error.localizedDescription);
                
                
                LRSession *session = [[LRSession alloc] initWithAccessToken:access_token userProfile:[[response mutableCopy] replaceNullWithBlank]];
                
                NSLog(@"LRSession Store Token%@",session.accessToken);
                NSLog(@"LRSession Store UserProfile%@",session.userProfile);
                
                
                [self showProfileController];
            }];
        }
    }
}

- (void) showNativeTwitterLogin
{
    /*Twitter Native SignIn
     
     [[TWTRTwitter sharedInstance] logInWithCompletion:
     ^(TWTRSession * _Nullable session, NSError * _Nullable error) {
     if (session){
     [[LoginRadiusSocialLoginManager sharedInstance] convertTwitterTokenToLRToken:session.authToken twitterSecret:session.authTokenSecret withSocialAppName:@"" inController:self completionHandler:^(NSDictionary * _Nullable data, NSError * _Nullable error) {
     if (error){
     [self showAlert:@"ERROR" message:error.localizedDescription];
     }else{
     [self showProfileController];
     }
     }];
     } else if (error){
     [self showAlert:@"ERROR" message:error.localizedDescription];
     }
     }];*/
}

- (void) showNativeFacebookLogin
{
    [[LoginRadiusSocialLoginManager sharedInstance] nativeFacebookLoginWithPermissions:@{@"facebookPermissions":@[@"public_profile",@"email"]} withSocialAppName:@"" inController:self completionHandler: ^(NSDictionary *data, NSError *error){
        if(error)
        {
            [self errorMessage:data error:error];
        }else
        {
            NSString *access_token= [data objectForKey:@"access_token"];
            
            [[AuthenticationAPI authInstance] profilesWithAccessToken:access_token completionHandler:^(NSDictionary *response, NSError *error) {
                
                NSLog(@"get profile api error %@",error.localizedDescription);
                
                
                LRSession *session = [[LRSession alloc] initWithAccessToken:access_token userProfile:[[response mutableCopy] replaceNullWithBlank]];
                
                NSLog(@"LRSession Store Token%@",session.accessToken);
                NSLog(@"LRSession Store UserProfile%@",session.userProfile);
                
                
                [self showProfileController];
            }];
        }
    }];
}

- (void) showTouchIDLogin
{
    [[LRTouchIDAuth sharedInstance] localAuthenticationWithFallbackTitle:@"" completion:^(BOOL success, NSError *error) {
        if (success) {
            [self showAlert:@"Success" message:@"Successfully Authenticated"];
            NSLog(@"successfully authenticated with touch id");
            [self showProfileController];
        } else {
            [self showAlert:@"Error" message:error.description];
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (void) showFaceIDLogin
{
    [[LRFaceIDAuth sharedInstance]localAuthenticationWithFallbackTitle:@"" completion:^(BOOL success, NSError *error) {
        if (success){
            [self showAlert:@"Success" message:@"Successfully Authenticated"];
            NSLog(@"Successfully authenticated with Face ID");
            [self showProfileController];
        }else{
            [self showAlert:@"Error" message:error.description];
            NSLog(@"Error: %@", [error description]);
        }
    }];
}

- (void) biometryType
{
    LAContext *laContext = [[LAContext alloc] init];
    
    NSError *error;

    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {

        if (error != NULL) {
            NSLog(error.description);
        } else {

            if (@available(iOS 11.0.1, *)) {
                if (laContext.biometryType == LABiometryTypeFaceID) {
                    //localizedReason = "Unlock using Face ID"
                    [self showFaceIDLogin];
                    NSLog(@"FaceId support");
                    
                } else if (laContext.biometryType == LABiometryTypeTouchID) {
                    //localizedReason = "Unlock using Touch ID"
                    [self showTouchIDLogin];
                    NSLog(@"TouchId support");

                } else {
                    //localizedReason = "Unlock using Application Passcode"
                    NSLog(@"No Biometric support");
                }

            }
        }
    }
}


- (void) errorMessage:(NSDictionary *)data
                             error: (NSError *) error{
   
        [self showAlert:@"ERROR" message:error.localizedDescription];
   
}

- (void) showProfileController {
    
    dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if ([[LoginRadiusSDK sharedInstance] session].isLoggedIn)
                       {
                           NSString *additionalErrorMsg = [NSString stringWithFormat:@"See our Swift Demo for an example to handle missing required fields."];
                           [self showAlert:@"ERROR" message:additionalErrorMsg];
                           [self performSegueWithIdentifier:@"profile" sender:self];
                       }else
                       {
                           NSLog(@"Attempted to go to profile view controller when not logged in");
                       }
                   });
}

//to eliminate "< Back" button showing up when user already logged in
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"profile"])
    {
        [[segue destinationViewController] navigationItem].hidesBackButton = YES;
    }
}

@end

