//
//  ViewController.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import LoginRadiusSDK
import Eureka
import SwiftyJSON
import AuthenticationServices
import LocalAuthentication

/* Google Native SignIn
 import GoogleSignIn
 */

/* Twitter Native Sign in
 import TwitterKit
 */

class ViewController: FormViewController
    /* Google Native SignIn
     , GIDSignInUIDelegate
     */
{
    
    var socialProviders:[String]? = nil
    var socialLoadingTimer:Timer? = nil
    var socialLoadingDots:Int = 0
    var registrationLoadingTimer:Timer? = nil
    var registrationLoadingDots:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Go to Profile VC if already login
        
        if(LoginRadiusSDK.sharedInstance().session.isLoggedIn)
        {
            showProfileController()
        }
        
        /* Google Native SignIn
         GIDSignIn.sharedInstance().uiDelegate = self
         */
        self.setupForm()
        //fetch me the social provider list
        ConfigurationAPI.configInstance().getConfigurationSchema
            { data, error in
                if let err = error
                {
                    
                    self.showAlert(title: "ERROR", message: err.localizedDescription )
                    if let loadingRow = self.form.rowBy(tag: "Loading") as? LabelRow
                    {
                        loadingRow.title = (error?.localizedDescription ?? "unknown error").capitalized
                        loadingRow.updateCell()
                    }
                    
                    
                }else{
                    // To set LoginRadius Schema (The one that you configured in the LoginRadius dashboard) through:
                    
                    LoginRadiusSchema.sharedInstance().setSchema(data!)
                    
                    if let providersObj = data!["SocialSchema"]{
                        
                        let  fields:[LoginRadiusField] = LoginRadiusSchema.sharedInstance().providers!
                        let providersList: NSMutableArray = NSMutableArray()
                        for field in fields
                        {
                            providersList.add(field.providerName!)
                            
                        }
                        self.socialProviders = providersList as? [String]
                        
                    }else
                    {
                        self.showAlert(title: "ERROR", message: error?.localizedDescription ?? "unknown error")
                        if let loadingRow = self.form.rowBy(tag: "Social Logins Loading") as? LabelRow
                        {
                            loadingRow.title = (error?.localizedDescription ?? "unknown error").capitalized
                            loadingRow.updateCell()
                        }
                    }
                    
                    DispatchQueue.main.async
                        {
                            // for social login form
                            
                            
                            self.socialLoadingTimer?.invalidate()
                            self.setupSocialLoginForm()
                            
                            
                            // for registration form
                            
                            
                            let dynamicRegisterCondition = Condition.function(["Dynamic Registration"], { form in
                                return !((form.rowBy(tag: "Dynamic Registration") as? SwitchRow)?.value ?? false)
                            })
                            
                            self.registrationLoadingTimer?.invalidate()
                            self.setupDynamicRegistrationForm(
                                lrFields: LoginRadiusSchema.sharedInstance().fields,
                                dynamicRegSection: self.form.sectionBy(tag: "Dynamic Registration Section")!,
                                loadingRow: self.form.rowBy(tag: "Dynamic Registration Loading"),
                                hiddenCondition: dynamicRegisterCondition,
                                sendHandler: {
                                    self.requestSOTT(completion: self.dynamicRegistration)
                            })
                    }
                }
        }
        
        
        socialLoadingTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(ViewController.updateSocialLoadingText), userInfo: nil, repeats: true)
        registrationLoadingTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(ViewController.updateDynamicRegistrationLoadingText), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This is do when there are 2 apps sharing 1 LoginRadius sitename login
        //If the other app logged in, this logs in too.
        
        if LoginRadiusSDK.sharedInstance().session.isLoggedIn
        {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showProfileController), name:  UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if LoginRadiusSDK.sharedInstance().session.isLoggedIn
        {
            NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func updateSocialLoadingText()
    {
        var loadingTxt = "Loading"
        
        socialLoadingDots = (socialLoadingDots + 1)%3
        for _ in 0...socialLoadingDots
        {
            loadingTxt.append(".")
        }
        
        if let loadingRow = form.rowBy(tag: "Social Logins Loading") as? LabelRow
        {
            loadingRow.title = loadingTxt
            loadingRow.updateCell()
        }
    }
    
    @objc func updateDynamicRegistrationLoadingText()
    {
        var loadingTxt = "Loading"
        
        registrationLoadingDots = (registrationLoadingDots + 1)%3
        for _ in 0...registrationLoadingDots
        {
            loadingTxt.append(".")
        }
        
        if let loadingRow = form.rowBy(tag: "Dynamic Registration Loading") as? LabelRow
        {
            loadingRow.title = loadingTxt
            loadingRow.updateCell()
        }
    }
    
    func setupForm()
    {
        self.navigationController?.navigationBar.topItem?.title = "LoginRadius SwiftDemo 5.5.0 🇨🇦"
        self.form = Form()
        
        //These is the just rules to toggle visibility of the UI elements
        let loginCondition = Condition.function(["Login by Email"], { form in
            return !((form.rowBy(tag: "Login by Email") as? SwitchRow)?.value ?? false)
        })
        
        let loginByUsernameCondition = Condition.function(["Login by Username"], { form in
            return !((form.rowBy(tag: "Login by Username") as? SwitchRow)?.value ?? false)
        })
        
        let staticRegisterCondition = Condition.function(["Static Registration"], { form in
            return !((form.rowBy(tag: "Static Registration") as? SwitchRow)?.value ?? false)
        })
        
        let dynamicRegisterCondition = Condition.function(["Dynamic Registration"], { form in
            return !((form.rowBy(tag: "Dynamic Registration") as? SwitchRow)?.value ?? false)
        })
        
        let forgotCondition = Condition.function(["Forgot Password"], { form in
            return !((form.rowBy(tag: "Forgot Password") as? SwitchRow)?.value ?? false)
        })
        //end of conditions
        
        //Create UI forms
        form +++ Section("Traditional Login")
            <<< SwitchRow("Login by Email")
            {
                $0.title = $0.tag
            }
            <<< EmailRow("Email Login")
            {
                $0.title = "Email"
                $0.hidden = loginCondition
                $0.add(rule: RuleRequired(msg: "Email Required"))
                $0.add(rule: RuleEmail(msg: "Incorrect Email format"))
            }
            <<< PasswordRow("Password Login")
            {
                $0.title = "Password"
                $0.hidden = loginCondition
                $0.add(rule: RuleRequired(msg: "Password Required"))
            }
            <<< ButtonRow("Login send")
            {
                $0.title = "Login"
                $0.hidden = loginCondition
                }.onCellSelection{ cell, row in
                    self.traditionalLogin()
            }
            <<< SwitchRow("Login by Username")
            {
                $0.title = $0.tag
            }
            <<< AccountRow("Username Login")
            {
                $0.title = "Username"
                $0.hidden = loginByUsernameCondition
                $0.add(rule: RuleRequired(msg: "Username Required"))
            }
            <<< PasswordRow("Password Username Login")
            {
                $0.title = "Password"
                $0.hidden = loginByUsernameCondition
                $0.add(rule: RuleRequired(msg: "Password Required"))
            }
            <<< ButtonRow("Login Username send")
            {
                $0.title = "Login"
                $0.hidden = loginByUsernameCondition
                }.onCellSelection{ cell, row in
                    self.usernameLogin()
            }
            
            +++ Section("Dynamic Registration Section")
            {
                $0.header = nil
                $0.tag = "Dynamic Registration Section"
            }
            <<< SwitchRow("Dynamic Registration")
            {
                $0.title = $0.tag
                $0.value =  true
            }
            <<< LabelRow ("Dynamic Registration Loading")
            {
                $0.title = "Loading"
                $0.hidden = dynamicRegisterCondition
                $0.cellStyle = .default
                }
                .cellUpdate{ (cell, row) in
                    cell.textLabel?.textAlignment = .center
            }
            
            //These are all static and may differ from your login radius registration schema
            +++ Section("Static Registration Section")
            {
                $0.header = nil
            }
            <<< SwitchRow("Static Registration")
            {
                $0.title = $0.tag
            }
            <<< EmailRow("Email Static Registration")
            {
                $0.title = "Email"
                $0.hidden = staticRegisterCondition
                $0.add(rule: RuleRequired(msg: "Email Required"))
                $0.add(rule: RuleEmail(msg: "Incorrect Email format"))
                }.onChange{ row in
                    self.toggleRegisterAvailability(rowTag:row.tag!,msgName: "email", available:nil)
                }.onCellHighlightChanged{ cell, row in
                    //if the user resign other email input field and press something else
                    if (!row.isHighlighted)
                    {
                        //check for email availability
                        self.checkEmailAvailability(emailStr: row.value ?? "", emailRowTag: row.tag!)
                    }
            }
            <<< PasswordRow("Password Static Registration")
            {
                $0.title = "Password"
                $0.hidden = staticRegisterCondition
                $0.add(rule: RuleRequired(msg: "Password Required"))
                $0.add(rule: RuleMinLength(minLength: 6, msg: "Length of password must be at least 6"))
            }
            <<< PasswordRow("Confirm Password Static Registration") {
                $0.title =  "Confirm Password"
                $0.hidden = staticRegisterCondition
                $0.add(rule: RuleRequired(msg: "Confirming your password is required"))
                $0.add(rule: RuleEqualsToRow(form: self.form, tag: "Password Static Registration", msg: "Mismatch on confirming your password"))
            }
            <<< ButtonRow("Static Registration Send")
            {
                $0.title = "Register"
                $0.hidden = staticRegisterCondition
                }.onCellSelection{ cell, row in
                    self.requestSOTT(completion: self.traditionalRegistration)
            }
            
            +++ Section("Forgot Password Section")
            {
                $0.header = nil
            }
            <<< SwitchRow("Forgot Password")
            {
                $0.title = $0.tag
                
            }
            <<< EmailRow("Email Forgot")
            {
                $0.title = "Email"
                $0.hidden = forgotCondition
                $0.add(rule: RuleRequired(msg: "Email Required"))
                $0.add(rule: RuleEmail(msg: "Incorrect Email format"))
            }
            <<< ButtonRow("Forgot send")
            {
                $0.title = "Request Password"
                $0.hidden = forgotCondition
                }.onCellSelection{ row,arg  in
                    self.forgotPassword()
        }
        
        /* use web hosted page for resetting it
         +++ Section("Reset Password")
         {
         $0.tag = "Reset Password"
         $0.hidden = Condition(booleanLiteral:  true)
         }
         <<< ButtonRow("Reset Password")
         {
         $0.title = $0.tag
         }.onCellSelection{ cell,row in
         self.resetPassword()
         }*/
        
        
        if !LoginRadiusSDK.sharedInstance().session.isLoggedIn
        {
            form +++ Section("Touch / Face ID")
            {
                $0.tag = "Touch / Face ID"
                }
                
                <<< ButtonRow ("Touch / Face ID")
                {
                    $0.title = $0.tag
                    }.onCellSelection{ row,arg  in
                        self.biometryType()
            }
        }
        
        form +++ Section("Social Logins Using Icons")
        {
            $0.tag = "Social Logins Using Icons"
            }
            <<< LabelRow ("Social Logins Loading")
            {
                $0.title = "Loading"
                $0.cellStyle = .default
                }
                .cellUpdate{ (cell, row) in
                    cell.textLabel?.textAlignment = .center
        }
        /*
         <<< SocialProvidersPickerRow("Social Logins Icons") { (row) in
         }
         .onCellSelection { (cell, row) in
         self.showSocialLogins(provider:row.value!)
         }
         
         form +++ Section("Normal Social Logins")
         {
         $0.tag = "Normal Social Logins"
         }*/
        
        let socialNativeLoginEnabled = AppDelegate.useGoogleNative ||  AppDelegate.useTwitterNative || AppDelegate.useFacebookNative
        
        if(socialNativeLoginEnabled)
        {
            let nativeSocialLoginSection = Section("Native Social Login")
            form +++ nativeSocialLoginSection
            
            if (AppDelegate.useAppleSignInNative)
            {
                nativeSocialLoginSection <<< ButtonRow("Native Apple")
                {
                    $0.title = "Apple Native Login"
                    }.onCellSelection{ cell, row in
                        self.actionHandleAppleSignin()
                }
               // self.setupSOAppleSignIn();
            }
            
            if (AppDelegate.useGoogleNative)
            {
                NotificationCenter.default.addObserver(self, selector: #selector(self.processGoogleNativeLogin), name: Notification.Name("userAuthenticatedFromNativeGoogle"), object: nil)
                
                nativeSocialLoginSection <<< ButtonRow("Native Google")
                {
                    $0.title = "Google Native Login"
                    }.onCellSelection{ cell, row in
                        self.showNativeGoogleLogin()
                }
            }
            
            if (AppDelegate.useFacebookNative)
            {
                
                nativeSocialLoginSection <<< ButtonRow("Native Facebook")
                {
                    $0.title = "Facebook Native Login"
                    }.onCellSelection{ cell, row in
                        self.showNativeFacebookLogin()
                }
            }
            
            if (AppDelegate.useTwitterNative)
            {
                
                nativeSocialLoginSection <<< ButtonRow("Native Twitter")
                {
                    $0.title = "Twitter Native Login"
                    }.onCellSelection{ cell, row in
                        self.showNativeTwitterLogin()
                }
            }
        }
    }
    
    func setupSocialLoginForm()
    {
        let socialLoginSection = form.sectionBy(tag: "Social Logins Using Icons")!
        let loadingRow = form.rowBy(tag: "Social Logins Loading")!
        
        if let providers = socialProviders
        {
            
            socialLoginSection <<< SocialProvidersPickerRow("Social Logins Icons") { (row) in
                }.cellSetup { cell, row in
                    cell.socialProviders = SocialProvidersManager.generateSocialProviderObjects(providers: providers)
                }.onCellSelection { cell, row in
                    self.showSocialLogins(provider:row.value!)
            }
            
            
            loadingRow.hidden = Condition(booleanLiteral: true);
            loadingRow.evaluateHidden()
        }else
        {
            loadingRow.title = "No Social Providers"
            loadingRow.updateCell()
        }
    }
    
    // Request SOTT from your own server, then do client side validation, you can do the other way around.
    func requestSOTT(completion:@escaping (String)->Void)
    {
        //You have to handle your own server, networking, and response processing
        //Replace this code with your own
        /*
         let url = "http://localhost:3000/sott"
         
         Alamofire.request(url).responseJSON { response in
         if let data = response.data,
         let sott = String(data:data, encoding: .utf8)
         {
         print("sott: \(sott)")
         completion(sott)
         }
         }*/
        
        // Alternatively if you don't care about security then take
        // The SOTT staticly from LoginRadius Dashboard with the longest endDate
        
        let sott = "<Your static sott>"
        
        if(sott == "<Your static sott>"){
            showAlert(title: "ERROR", message: "For registration you need a SOTT, you can find it in the LoginRadius dashboard or generate one in your server")
            return
        }
        
        completion(sott)
        
    }
    
  func dynamicRegistration(sott:String)
    {
        guard let dynamicRegSection = form.sectionBy(tag: "Dynamic Registration Section") else
        {
            showAlert(title: "ERROR", message: "No Dynamic Registration Section")
            return
        }
        
        var errors:[ValidationError] = []
        
        for row in dynamicRegSection
        {
            errors += row.validate()
        }
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        var parameter:[String:Any] = [:]
        
        for i in 1...dynamicRegSection.count-2 //don't include the button row
        {
            let row = dynamicRegSection[i]
            
            if (row.tag! == "confirmpassword"){continue}
            
            if (row.tag! != "email" && row.tag! != "emailid")
            {
                if let dateRow = row as? DateRow
                {
                    //let mm-dd-yyyy
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    parameter[row.tag!] = dateFormatter.string(from: dateRow.value!)
                }else
                {
                    
                    parameter[row.tag!] = row.baseValue
                }
            }else{
                parameter["email"] = [["type":"Primary","value":row.baseValue!]]
            }
            
            if row.tag!.hasPrefix("cf_")
            {
                
                let range =  row.tag!.index(row.tag!.startIndex, offsetBy: 3)..<row.tag!.endIndex
                let modifiedTag = String(row.tag![range])
                
                if var dict = parameter["CustomFields"] as? [String:Any]
                {
                    if(parameter[row.tag!] != nil){
                        dict[modifiedTag] = parameter[row.tag!]!
                        parameter["CustomFields"] = dict
                    }
                   
                }else 
                {
                    if(parameter[row.tag!] != nil){
                         parameter["CustomFields"] = [modifiedTag:parameter[row.tag!]!]
                    }
                   
                }
                
                parameter.removeValue(forKey: row.tag!)
            }
           
            if LoginRadiusField.addressFields().contains(row.tag!)
            {
                 if var arr = parameter["addresses"] as? [[String:Any]]
                {
                    arr[0][row.tag!] = row.baseValue!
                    parameter["addresses"] = arr
                }
                
                parameter.removeValue(forKey: row.tag!)
                
            }
            
        }
       
        
        AuthenticationAPI.authInstance().userRegistration(withSott:sott,payload:parameter, emailtemplate:nil, smstemplate:nil,preventVerificationEmail:false , completionHandler:{ (data, error) in
            
            if let err = error
            {
                self.errorAlert(data:data, error:err)
            }else{
                print("successfully registered");
                self.showAlert(title:"SUCCESS", message:"Please verify your email")
            }
            
        })
        
    }
    
    func traditionalRegistration(sott:String)
    {
        
        var errors = form.rowBy(tag: "Email Static Registration")!.validate()
        errors += form.rowBy(tag: "Password Static Registration")!.validate()
        errors += form.rowBy(tag: "Confirm Password Static Registration")!.validate()
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        

        let email:AnyObject = ["Type":"Primary",
                               "Value":form.rowBy(tag: "Email Static Registration")!.baseValue!
            ] as AnyObject
        
        let parameter:AnyObject = [  "Email": [
            email
            ],
                           "Password": form.rowBy(tag: "Password Static Registration")!.baseValue!
        ]as AnyObject
        
        print(parameter)
        
        AuthenticationAPI.authInstance().userRegistration(withSott:sott,payload:parameter as! [AnyHashable : Any], emailtemplate:nil, smstemplate:nil,preventVerificationEmail:false , completionHandler: { (data, error) in
            
            if let err = error
            {
                 print("successfully registered");
                self.errorAlert(data:data, error:err)
            }else{
                print("successfully registered");
                self.showAlert(title:"SUCCESS", message:"Please verify your email")
            }
            
        })
    }
    
    func traditionalLogin()
    {
        var errors = form.rowBy(tag: "Email Login")!.validate()
        errors += form.rowBy(tag: "Password Login")!.validate()
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let email = form.rowBy(tag: "Email Login")!.baseValue! as! String
        let password = form.rowBy(tag: "Password Login")!.baseValue! as! String
        
        let parameter:AnyObject = [
                           "email":email,
                           "password":password,
                           "securityanswer":""
        ]as AnyObject
        
        
        AuthenticationAPI.authInstance().login(withPayload:parameter as! [AnyHashable : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler: { (data, error) in
            if let err = error {
                self.errorAlert(data:data, error:err)
            } else {
                let access_token = data!["access_token"] as! NSString
                let profile = data!["Profile"] as! [AnyHashable:Any]?
                self.checkRequiredFields(profile:profile,token:access_token)
               
            }
        })
    }
    
    func usernameLogin(){
        var errors = form.rowBy(tag: "Username Login")!.validate()
        errors += form.rowBy(tag: "Password Username Login")!.validate()
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let username = form.rowBy(tag: "Username Login")!.baseValue! as! String
        let password = form.rowBy(tag: "Password Username Login")!.baseValue! as! String
        let parameter:AnyObject = [
            "username":username,
            "password":password,
            "securityanswer":""
        ]as AnyObject
        
        
        
        AuthenticationAPI.authInstance().login(withPayload:parameter as! [AnyHashable : Any], loginurl:nil, emailtemplate:nil, smstemplate:nil, g_recaptcha_response:nil,completionHandler:{ (data, error) in
            if let err = error {
                self.errorAlert(data:data, error:err)
            } else {
                let access_token = data!["access_token"] as! NSString
                let profile = data!["Profile"] as! [AnyHashable:Any]?
                self.checkRequiredFields(profile:profile,token:access_token)
            }
        })
    }
    
    func forgotPassword() {
        
        let errors = form.rowBy(tag: "Email Forgot")!.validate()
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let email = form.rowBy(tag: "Email Forgot")!.baseValue! as! String
        
        AuthenticationAPI.authInstance().forgotPassword(withEmail:email, emailtemplate:nil,completionHandler:{ (data, error) in
            if let err = error {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            } else {
                self.showAlert(title: "SUCCESS", message: "Check your email for reset link")
            }
        })
    }
    
    func showSocialLogins(provider:String)
    {

        LoginRadiusSocialLoginManager.sharedInstance().login(withProvider: provider, in: self, completionHandler: { (data, error) in
            
            DispatchQueue.main.async
                {
                    if(error?.localizedDescription == "Social Login cancelled"){
                        return
                    }
                   
                   
                    let access_token = data!["access_token"] as! NSString
                    
                    AuthenticationAPI.authInstance().profiles(withAccessToken: access_token as String? , completionHandler: {(response, error) in
                            
                       self.checkRequiredFields(profile:response,token:access_token)
                        
                        })
                   
            }
            
        })
        
    }
    
    func showNativeGoogleLogin()
    {
        if let childVC = self.presentedViewController
        {
            childVC.dismiss(animated: false, completion: self.showNativeGoogleLogin)
            return
        }
        
        /* Google Native Sign in
         GIDSignIn.sharedInstance().signIn()
         */
    }
    
    @objc func processGoogleNativeLogin(notif:NSNotification)
    {
        if let userInfo = notif.userInfo
        {
            if let err = userInfo["error"] as? NSError
            {
                errorAlert(data:userInfo["data"] as? [AnyHashable : Any], error:err)
            }else
            {
                let data = userInfo["data"] as? [AnyHashable : Any]
                let access_token = data!["access_token"] as! NSString
                
                AuthenticationAPI.authInstance().profiles(withAccessToken: access_token as String? , completionHandler: {(response, error) in
                    
                    self.checkRequiredFields(profile:response,token:access_token)
                    
                })
            }
        }
    }
    
    func showNativeTwitterLogin()
    {

         /* Twitter Native Sign in
         TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
         if let session = session {
         LoginRadiusSocialLoginManager.sharedInstance().convertTwitterToken(toLRToken: session.authToken, twitterSecret: session.authTokenSecret, withSocialAppName:"", in: self,  completionHandler: {(data, error) in
         if let _ = data
         {
         let access_token = data!["access_token"] as! NSString
         
         AuthenticationAPI.authInstance().profiles(withAccessToken: access_token as String! , completionHandler: {(response, error) in
         
         self.checkRequiredFields(profile:response,token:access_token)
         
         })
         }else if let err = error
         {
         self.showAlert(title:"ERROR",message:err.localizedDescription)
         }
         })
         } else if let err = error{
         self.showAlert(title:"ERROR",message:err.localizedDescription)
         }
         })
         
         */
    }
    
    func showNativeFacebookLogin()
    {
        LoginRadiusSocialLoginManager.sharedInstance().nativeFacebookLogin(withPermissions: ["facebookPermissions": ["public_profile"]], withSocialAppName:"",  in: self, completionHandler: {( data, error) -> Void in
            
            if let err = error {
                self.errorAlert(data:data, error:err)
            } else {
                let access_token = data!["access_token"] as! NSString
                
                AuthenticationAPI.authInstance().profiles(withAccessToken: access_token as String? , completionHandler: {(response, error) in
                    
                    self.checkRequiredFields(profile:response,token:access_token)
                    
                })
            }
        })
    }
    
    func showTouchIDLogin()
    {
        LRTouchIDAuth.sharedInstance().localAuthentication(withFallbackTitle: "", completion: { (success, error) in
            if let err = error{
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                self.showAlert(title: "SUCCESS", message:"Valid User")
            }
        })
    }
    
    func showFaceIDLogin()
    {
        LRFaceIDAuth.sharedInstance().localAuthentication(withFallbackTitle: " ", completion: {
        (success, error) in
            if let err = error{
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                self.showAlert(title: "SUCCESS", message:"Valid User")
                print("Face ID authentication successfull")
                self.showProfileController()
            }
        })
    }
    
    
    func biometryType()
    {
        
        let context = LAContext()
            
            var error: NSError?
            
            if context.canEvaluatePolicy(
                LAPolicy.deviceOwnerAuthenticationWithBiometrics,
                error: &error) {
           if (error != nil) {
               print(error?.description)
           } else {

               if #available(iOS 11.0.1, *) {
                   if (context.biometryType == .faceID) {
                       //localizedReason = "Unlock using Face ID"
                       self.showFaceIDLogin()

                      print("Face ID supports")

                   } else if (context.biometryType == .touchID) {
                       //localizedReason = "Unlock using Touch ID"
                       self.showTouchIDLogin()
                       print("TouchId support")

                  } else {
                       //localizedReason = "Unlock using Application Passcode"
                     print("No Biometric support")
                    }

                }
            }
        }

    }
    func errorAlert(data:[AnyHashable:Any]?, error:Error )
    {
        
            let e = error as NSError
            self.showAlert(title: "ERROR", message:e.localizedDescription)
           

}
    
  
    
    @objc func showProfileController () {
        DispatchQueue.main.async
            {
                
                print(LoginRadiusSDK.sharedInstance().session.isLoggedIn);
                if LoginRadiusSDK.sharedInstance().session.isLoggedIn
                {
                    self.attemptToSegue(identifier: "profile", sender: self)
                }else
                {
                    print("Attempted to go to profile view controller when not logged in")
                }
        }
    }
    
    
    func attemptToSegue(identifier: String, sender: Any?){
        if(self.shouldPerformSegue(withIdentifier: identifier, sender: sender)){
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        var shouldSegue = false
        if let nav = self.navigationController{
            shouldSegue = nav.viewControllers.count <= 1
        }
        return shouldSegue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "profile"
        {
            //to eliminate "< Back" button showing up when user already logged in
            segue.destination.navigationItem.hidesBackButton = true
            resetFormValues()
        }else{
            print("unknown handler for segue")
        }
        
    }
    
    func resetFormValues(){
        for rows in form.allRows {
            rows.baseValue = nil
        }
        tableView.reloadData()
        
    }
    
    
    //Add button for Sign in with Apple
       func setupSOAppleSignIn() {
        
        if #available(iOS 13.0, *) {
            let btnAuthorization = ASAuthorizationAppleIDButton()
            btnAuthorization.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
            btnAuthorization.center = self.view.center
            btnAuthorization.addTarget(self, action: #selector(actionHandleAppleSignin), for: .touchUpInside)
            self.view.addSubview(btnAuthorization)
        } else {
            // Fallback on earlier versions
        }
           
       }
    
    // Perform acton on click of Sign in with Apple button
       @objc func actionHandleAppleSignin() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
           
       }
    
    
    func checkRequiredFields(profile:[AnyHashable:Any]?, token:NSString) {

        ConfigurationAPI.configInstance().getConfigurationSchema
            {schema, error in
                
                
                LoginRadiusSchema.sharedInstance().checkRequiredFields(withSchema:schema!, profile:profile!, completionHandler: {(data, error) in
            
           if(data?.index(forKey: "MissingRequiredFields") != nil){
            
            // UserDefaults for temp save token for update missing profile 
            
            UserDefaults.standard.set(token, forKey: "token")
            DispatchQueue.main.async{
             self.attemptToSegue(identifier: "missingfields", sender: self)
            }
            }else{
            
                let session = LRSession.init(accessToken:token as String, userProfile:profile!)
                print("session",session)
                self.showProfileController();

            }
            
            
        })
     }
        
    }
    
    
}


extension ViewController: ASAuthorizationControllerDelegate {
    
    // ASAuthorizationControllerDelegate function for authorization failed
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // ASAuthorizationControllerDelegate function for successful authorization
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // Create an account as per your requirement
           let appleUserToken = appleIDCredential.authorizationCode!
           if let code = String(bytes: appleUserToken, encoding: .utf8) {
            
            // Convert apple Code to LoginRadius Acess Token
            
            LoginRadiusSocialLoginManager.sharedInstance()?.convertAppleCode(toLRToken:code, withSocialAppName:"",  completionHandler: {(data, error) in
              
                if let _ = data
                {
                let access_token = data!["access_token"] as! NSString
                
                AuthenticationAPI.authInstance().profiles(withAccessToken: access_token as String? , completionHandler: {(response, error) in
                
                self.checkRequiredFields(profile:response,token:access_token)
                
                })
                }else if let err = error
                {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
                }
                
            })
           
                print(code)
            } else {
                print("not a valid UTF-8 sequence")
            }
        }
    }
    
}

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    //For present window
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
