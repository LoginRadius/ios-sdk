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
import Alamofire
/* Google Native SignIn
import GoogleSignIn
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
        
        if(LoginRadiusSDK.invalidateAndDeleteAccessTokenOnLogout())
        {
            showProfileController()
        }
        
        /* Google Native SignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        */
        self.setupForm()
        
        //fetch me the social provider list
        LoginRadiusSocialLoginManager.sharedInstance().getSocialProvidersList
        { data, error in
        
            if let providersObj = data?["Providers"] as? [String]
            {
                self.socialProviders = providersObj
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
                self.socialLoadingTimer?.invalidate()
                self.setupSocialLoginForm()
            }
        }
        
        LoginRadiusRegistrationManager.sharedInstance().getRegistrationSchema
        { schema, error in

            if let err = error
            {
                //success on getting registration schema
                self.showAlert(title: "ERROR", message: err.localizedDescription )
                if let loadingRow = self.form.rowBy(tag: "Dynamic Registration Loading") as? LabelRow
                {
                    loadingRow.title = (error?.localizedDescription ?? "unknown error").capitalized
                    loadingRow.updateCell()
                }
            }
            
            //You can access registration schema on the callback or from the shared instance
            //print(schema)
            //print(LoginRadiusRegistrationSchema.sharedInstance().fields)
            
            DispatchQueue.main.async
            {
                let dynamicRegisterCondition = Condition.function(["Dynamic Registration"], { form in
                    return !((form.rowBy(tag: "Dynamic Registration") as? SwitchRow)?.value ?? false)
                })
                
                self.registrationLoadingTimer?.invalidate()
                self.setupDynamicRegistrationForm(
                lrFields: LoginRadiusRegistrationSchema.sharedInstance().fields,
                dynamicRegSection: self.form.sectionBy(tag: "Dynamic Registration Section")!,
                loadingRow: self.form.rowBy(tag: "Dynamic Registration Loading"),
                hiddenCondition: dynamicRegisterCondition,
                sendHandler: {
                    self.requestSOTT(completion: self.dynamicRegistration)
                })
            }
        
        }
        
        socialLoadingTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(ViewController.updateSocialLoadingText), userInfo: nil, repeats: true)
        registrationLoadingTimer = Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(ViewController.updateDynamicRegistrationLoadingText), userInfo: nil, repeats: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This is do when there are 2 apps sharing 1 LoginRadius sitename login
        //If the other app logged in, this logs in too.
        
        if LoginRadiusSDK.invalidateAndDeleteAccessTokenOnLogout()
        {
            NotificationCenter.default.addObserver(self, selector: #selector(self.showProfileController), name:  NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if LoginRadiusSDK.invalidateAndDeleteAccessTokenOnLogout()
        {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        }
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateSocialLoadingText()
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
    
    func updateDynamicRegistrationLoadingText()
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
        self.navigationController?.navigationBar.topItem?.title = "LoginRadius SwiftDemo 4.0.0 🇨🇦"
        self.form = Form()
        
        //These is the just rules to toggle visibility of the UI elements
        let loginCondition = Condition.function(["Login"], { form in
            return !((form.rowBy(tag: "Login") as? SwitchRow)?.value ?? false)
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
            <<< SwitchRow("Login")
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
                $0.add(rule: RuleMinLength(minLength: 6, msg: "Length of password must be at least 6"))
            }
            <<< ButtonRow("Login send")
            {
                $0.title = "Login"
                $0.hidden = loginCondition
                }.onCellSelection{ cell, row in
                    self.traditionalLogin()
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
                self.toggleEmailRegisterAvailability(emailRowTag:row.tag!, available:nil)
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
                }.onCellSelection{ row in
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
            
            
            if !LoginRadiusSDK.invalidateAndDeleteAccessTokenOnLogout()
            {
                form +++ Section("Touch ID")
                {
                    $0.tag = "Touch ID"
                }
                
                <<< ButtonRow ("Touch ID")
                {
                    $0.title = $0.tag
                    }.onCellSelection{ row in
                        self.showTouchIDLogin()
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
                
                if (AppDelegate.useGoogleNative)
                {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.processGoogleNativeLogin), name: Notification.Name("userAuthenticatedFromNativeGoogle"), object: nil)

                    nativeSocialLoginSection <<< ButtonRow("Native Google")
                    {
                        $0.title = "Google"
                        }.onCellSelection{ cell, row in
                            self.showNativeGoogleLogin()
                    }
                }
                
                if (AppDelegate.useFacebookNative)
                {

                    nativeSocialLoginSection <<< ButtonRow("Native Facebook")
                    {
                        $0.title = "Facebook"
                        }.onCellSelection{ cell, row in
                            self.showNativeFacebookLogin()
                    }
                }
                
                if (AppDelegate.useTwitterNative)
                {

                    nativeSocialLoginSection <<< ButtonRow("Native Twitter")
                    {
                        $0.title = "Twitter"
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
                let modifiedTag = row.tag![range]
                
                if var dict = parameter["CustomFields"] as? [String:Any]
                {
                    dict[modifiedTag] = parameter[row.tag!]!
                    parameter["CustomFields"] = dict
                }else
                {
                    parameter["CustomFields"] = [modifiedTag:parameter[row.tag!]!]
                }
                
                parameter.removeValue(forKey: row.tag!)
            }
            
            if LoginRadiusField.addressFields().contains(row.tag!)
            {
                if parameter["addresses"] == nil
                {
                    parameter["addresses"] = [[row.tag!:row.baseValue!]]
                }else if var arr = parameter["addresses"] as? [[String:Any]]
                {
                    arr[0][row.tag!] = row.baseValue!
                    parameter["addresses"] = arr
                }
                
                parameter.removeValue(forKey: row.tag!)

            }
            
        }
        
        LoginRadiusRegistrationManager.sharedInstance().authRegistration(withData:parameter, withSott: sott, verificationUrl: "", emailTemplate: "", completionHandler: { (data, error) in
        
            if let err = error
            {
                self.checkForMissingFieldError(data:data, error:err)
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

        let parameter = [  "Email": [
                                        email
                                    ],
                           "Password": form.rowBy(tag: "Password Static Registration")!.baseValue!
        ]
        
        LoginRadiusRegistrationManager.sharedInstance().authRegistration(withData:parameter, withSott: sott, verificationUrl: "", emailTemplate: "", completionHandler: { (data, error) in
        
            if let err = error
            {
                self.checkForMissingFieldError(data:data, error:err)
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
    
        LoginRadiusRegistrationManager.sharedInstance().authLogin(withEmail: email, withPassword: password, loginUrl: "", verificationUrl: "", emailTemplate: "", completionHandler: { (data, error) in
            if let err = error {
                self.checkForMissingFieldError(data:data, error:err)
            } else {
                self.showProfileController()
            }
        })
    }
    
    func forgotPassword() {
    
        var errors = form.rowBy(tag: "Email Forgot")!.validate()
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let email = form.rowBy(tag: "Email Forgot")!.baseValue! as! String
        
        LoginRadiusRegistrationManager.sharedInstance().authForgotPassword(withEmail: email, resetPasswordUrl:"" , emailTemplate:"" , completionHandler:{ (data, error) in
            if let err = error {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            } else {
                self.showAlert(title: "SUCCESS", message: "Check your email for reset link")
            }
        })
    }
    
    /* use web hosted page for resetting it
    func resetPassword()
    {
    }
    */
    
    func showSocialLogins(provider:String)
    {
        LoginRadiusSocialLoginManager.sharedInstance().login(withProvider: provider, in: self, completionHandler: { (data, error) in
        
            DispatchQueue.main.async
            {
                if let err = error {
                    self.checkForMissingFieldError(data:data, error:err)
                } else {
                    print("successfully logged in with \(provider)");
                    self.showProfileController();
                }
            }
        })

    }
    
    func showNativeGoogleLogin()
    {
        /* Google Native SignIn
        GIDSignIn.sharedInstance().signIn()
        */
    }
    
    func processGoogleNativeLogin(notif:NSNotification)
    {
        if let userInfo = notif.userInfo
        {
            if let err = userInfo["error"] as? NSError
            {
                checkForMissingFieldError(data:userInfo["data"] as? [AnyHashable : Any], error:err)
            }else
            {
                showProfileController()
            }
        }
    }
    
    func showNativeTwitterLogin()
    {
        LoginRadiusSocialLoginManager.sharedInstance().nativeTwitter(withConsumerKey: "<Your twitter consumer key>", consumerSecret: "<Your twitter secret key>", in: self, completionHandler: {(data,  error) in
            
            if let err = error{
                self.checkForMissingFieldError(data:data, error:err)
            }else{
                self.showProfileController()
            }
        })
    }
    
    func showNativeFacebookLogin()
    {
        LoginRadiusSocialLoginManager.sharedInstance().nativeFacebookLogin(withPermissions: ["facebookPermissions": ["public_profile"]], in: self, completionHandler: {( data, error) -> Void in

            if let err = error {
                self.checkForMissingFieldError(data:data, error:err)
            } else {
                self.showProfileController();
            }
        })
    }
    
    func showTouchIDLogin()
    {
        LRTouchIDAuth.sharedInstance().localAuthentication(withFallbackTitle: "", completion: { (success, error) in
            if let err = error{
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                self.showProfileController();
            }
        })
    }
    
    func checkForMissingFieldError(data:[AnyHashable:Any]?, error:Error )
    {
        let e = error as NSError
        if e.code == LRErrorCode.userRequireAdditionalFieldsError.rawValue
        {
            self.performSegue(withIdentifier: "missingfields", sender: data);
        }else
        {
            let descriptiveReason = (e.localizedFailureReason != nil) ? "\n\n\(e.localizedFailureReason!)" : ""
            self.showAlert(title: "ERROR", message: "\(e.localizedDescription)\(descriptiveReason)")
        }
    }
    
    func showProfileController () {
        DispatchQueue.main.async
        {
            if LoginRadiusSDK.sharedInstance().session.isLoggedIn
            {
                self.performSegue(withIdentifier: "profile", sender: self);
            }else
            {
                print("Attempted to go to profile view controller when not logged in")
            }
        }
    }
    
        
    //to eliminate "< Back" button showing up when user already logged in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "profile"
        {
            segue.destination.navigationItem.hidesBackButton = true
        } else if segue.identifier == "missingfields",
            let data = sender as? Dictionary<String, Any>,
            let token = data["AccessToken"] as? String,
            let missingFields = data["MissingRequiredFields"] as?[LoginRadiusField]
        {
            let mfVC = segue.destination as! MissingFieldsViewController
            mfVC.accessToken = token
            mfVC.lrFields = missingFields
        }else{
            print("unknown handler for segue")
        }
    }
}

