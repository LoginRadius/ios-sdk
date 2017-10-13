//
//  DetailViewController.m
//  ObjCDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

#import "DetailViewController.h"
#import <LoginRadiusSDK/LoginRadius.h>

static NSArray<NSString *>* _countries = nil;
@interface DetailViewController ()
@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSDictionary *userProfile;
@end

@implementation DetailViewController

+ (NSArray<NSString *>*)countries {
    if (!_countries) {
        NSLocale *locale = [NSLocale currentLocale];
        NSArray *countryArray = [NSLocale ISOCountryCodes];

        NSMutableArray<NSString *> *countryArr = [[NSMutableArray<NSString *> alloc] init];

        for (NSString *countryCode in countryArray) {

            NSString *displayNameString = [locale displayNameForKey:NSLocaleCountryCode value:countryCode];
            [countryArr addObject:displayNameString];

        }

        [countryArr sortUsingSelector:@selector(localizedCompare:)];
        _countries = [countryArr copy];
    }

    return _countries;
}

    //NSArray<NSString *> *countries = NSLocale

      /* NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }*/

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setupForm)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [self setupForm];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void) dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupForm{

    NSUserDefaults *lrUser = [NSUserDefaults standardUserDefaults];
    NSDictionary * profile =  [lrUser objectForKey:@"lrUserProfile"];
    NSString * userAccessToken =  [lrUser objectForKey:@"lrAccessToken"];

    if (userAccessToken == nil)
    {
        [self showAlert:@"ERROR" message:@"Access token is missing or logged out"];
        [self logoutPressed:self];
        return;
    }
    
    self.accessToken = userAccessToken;
    self.userProfile = profile;
    
    [[self navigationItem] setHidesBackButton:YES animated:NO];
    [self navigationItem].title = @"User Profile ObjC";
    
    XLFormDescriptor * form;
    XLFormSectionDescriptor * section;
    XLFormRowDescriptor * row;
    XLFormRowDescriptor * switchRow;
    
    form = [XLFormDescriptor formDescriptor];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Logout" rowType:XLFormRowDescriptorTypeButton title:@"Log out"];
    row.action.formBlock = ^(XLFormRowDescriptor *block)
    {
        [self logoutPressed:self];
    };
    [section addFormRow:row];
    
    //User Profile Section
    NSString *userEmail = [[_userProfile objectForKey:@"Email"][0] objectForKey:@"Value"];
    
    id countryObj = [_userProfile objectForKey:@"Addresses"];
    NSString *userCountry  = ([countryObj isKindOfClass:[NSArray class]]) ? [[_userProfile objectForKey:@"Addresses"][0]  objectForKey:@"Country"] : nil;
    NSString *gender = [_userProfile objectForKey:@"Gender"];

    section = [XLFormSectionDescriptor formSectionWithTitle:@"User Profile Section"];
    [form addFormSection:section];
    
    switchRow = [XLFormRowDescriptor formRowDescriptorWithTag:@"UserProfile" rowType:XLFormRowDescriptorTypeBooleanSwitch title:@"User Profile"];
    switchRow.value = @1;
    [section addFormRow:switchRow];

    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"FirstName" rowType:XLFormRowDescriptorTypeText title:@"First Name"];
    row.required = YES;
    //bug on validator returning nil when theres no validator
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"First Name is required!" regex:@".+"]];
    row.value = [_userProfile objectForKey:@"FirstName"];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row setDisabled:@YES];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"LastName" rowType:XLFormRowDescriptorTypeText title:@"Last Name"];
    row.required = YES;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Last Name is required!" regex:@".+"]];
    row.value = [_userProfile objectForKey:@"LastName"];
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row setDisabled:@YES];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Email" rowType:XLFormRowDescriptorTypeEmail title:@"Email"];
    row.required = YES;
    row.value = userEmail;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row.cellConfig setObject:@(NSTextAlignmentRight) forKey:@"textField.textAlignment"];
    [row setDisabled:@YES];
    [section addFormRow:row];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Gender" rowType:XLFormRowDescriptorTypeSelectorSegmentedControl title:@"Gender"];
    row.selectorOptions = @[@"M",@"F",@"?"];
    row.value = gender;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Gender is required!" regex:@".+"]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row setDisabled:@YES];
    [section addFormRow:row];
    
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Country" rowType:XLFormRowDescriptorTypeSelectorPush title:@"Country"];
    row.selectorOptions = [DetailViewController countries];
    row.value = userCountry;
    [row addValidator:[XLFormRegexValidator formRegexValidatorWithMsg:@"Country is required!" regex:@".+"]];
    row.required = YES;
    row.hidden = [NSString stringWithFormat:@"$%@ == 0", switchRow];
    [row setDisabled:@YES];
    [section addFormRow:row];
    
    section = [XLFormSectionDescriptor formSection];
    [form addFormSection:section];
    
    row = [XLFormRowDescriptor formRowDescriptorWithTag:@"Information" rowType:XLFormRowDescriptorTypeButton title:@"Information"];
    row.action.formBlock = ^(XLFormRowDescriptor *block)
    {
        [self showAlert:@"Information" message:@"For more usage examples,\nSee our Swift demo!"];
    };
    [section addFormRow:row];

    self.form = form;
}

- (void)logoutPressed:(id)sender {

    /* Google Native Sign in
    [[GIDSignIn sharedInstance] signOut];
    */
    /* Twitter Native Sign in
    [self twitterLogout];
    */

    [LoginRadiusSDK logout];
    [self.navigationController popViewControllerAnimated:YES];
}
/* Twitter Native Sign in
- (void) twitterLogout
{
    NSArray * twitterSessions;
    twitterSessions = [[[Twitter sharedInstance] sessionStore] existingUserSessions];
    if (twitterSessions){
        for (id session in twitterSessions){
            [[[Twitter sharedInstance] sessionStore] logOutUserID:[session userID]];
        }
    }
}
*/
- (void) showAlert : (NSString*) title
            message: (NSString*) message
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:title
        message:message
        preferredStyle:UIAlertControllerStyleAlert];

        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

@end
