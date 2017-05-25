//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import LoginRadiusSDK
import Eureka
/* Google Native SignIn
import GoogleSignIn
*/
class ViewController: FormViewController
/* Google Native SignIn
, GIDSignInUIDelegate
*/
{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if already login
        let defaults = UserDefaults.standard
        let user = defaults.integer(forKey: "isLoggedIn")
        if (user == 1) {
            self.performSegue(withIdentifier: "profile", sender: self);
        }
        
        /* Google Native SignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        */
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveRegistration), name: NSNotification.Name(rawValue: LoginRadiusRegistrationEvent), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveLogin), name: NSNotification.Name(rawValue: LoginRadiusLoginEvent), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveForgotPassword), name: NSNotification.Name(rawValue: LoginRadiusForgotPasswordEvent), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.receiveSocialLogin), name: NSNotification.Name(rawValue: LoginRadiusSocialLoginEvent), object: nil)
        
        self.navigationController?.navigationBar.topItem?.title = "Login Radius iOS pod 3.4.0"
        self.form = Form()
        
        //Create UI forms
        form +++ Section("")
            <<< ButtonRow("Login LR API")
            {
                $0.title = "Login"
                }.onCellSelection{ cell, row in
                    self.login()
            }
            <<< ButtonRow("Register LR API")
            {
                $0.title = "Register"
                }.onCellSelection{ cell, row in
                    self.registration()
            }
            <<< ButtonRow("Forgot LR API")
            {
                $0.title = "Forgot Password"
                }.onCellSelection{ row in
                    self.forgotPassword()
            }
            <<< ButtonRow("Social Login Only")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell, row in
                    self.socialLoginOnly()
            }
            let socialNativeLoginEnabled = LoginRadiusSDK.sharedInstance().enableGoogleNativeInHosted ||  LoginRadiusSDK.sharedInstance().enableFacebookNativeInHosted
        
            if(socialNativeLoginEnabled)
            {
                let nativeSocialLoginSection = Section("Native Social Login")
                form +++ nativeSocialLoginSection
                
                //WARNING FOR DEV/Testers:
                //whenever the googleNative is set to true or facebookNative to true,
                //it is set to true the safariViewController will save it on a cookie
                //so if you immediately set the googleNative to false in the plist, and run the app
                //it won't reflect the changes on the cookie of the default cdn site. (meaning it still thinks you had googleNative set to true)
                //the workaround is to reset safari's cache, so on the Simulator go to Preferences > Safari > Clear History and Website Data
                
                if (LoginRadiusSDK.sharedInstance().enableGoogleNativeInHosted)
                {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.showProfileController), name: Notification.Name("userAuthenticatedFromNativeGoogle"), object: nil)
                    NotificationCenter.default.addObserver(self, selector: #selector(self.showNativeGoogleLogin), name: Notification.Name("googleNative"), object: nil)

                    nativeSocialLoginSection <<< ButtonRow("Native Google")
                    {
                        $0.title = "Google"
                        }.onCellSelection{ cell, row in
                            self.showNativeGoogleLogin()
                    }
                }
                
                if (LoginRadiusSDK.sharedInstance().enableFacebookNativeInHosted)
                {
                    NotificationCenter.default.addObserver(self, selector: #selector(self.showNativeFacebookLogin), name: Notification.Name("facebookNative"), object: nil)

                    nativeSocialLoginSection <<< ButtonRow("Native Facebook")
                    {
                        $0.title = "Facebook"
                        }.onCellSelection{ cell, row in
                            self.showNativeFacebookLogin()
                    }
                }

                
            }

    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func registration() {
        LoginRadiusManager.sharedInstance().registration(withAction: "registration", in: self)
    }
    
    func login() {
        LoginRadiusManager.sharedInstance().registration(withAction: "login", in: self)
    }
    
    func forgotPassword() {
        LoginRadiusManager.sharedInstance().registration(withAction: "forgotpassword", in: self);
    }
    
    func socialLoginOnly() {
        LoginRadiusManager.sharedInstance().registration(withAction: "social", in: self);
    }
    
    func receiveRegistration(notification:Notification)
    {
        if let userInfo  = notification.userInfo,
           let error  = userInfo["error"] as? Error
        {
            self.showAlert(title: "ERROR", message: error.localizedDescription)
        }else
        {
            let lrUser = UserDefaults.standard
            let profile = lrUser.integer(forKey: "isLoggedIn")
            if (profile == 1) {
                self.showProfileController()
            }else{
                self.showAlert(title: "SUCCESS", message: "Registration Successful, check your email for verification")
            }
        }
    }
    
    func receiveLogin(notification:Notification)
    {
        if let userInfo  = notification.userInfo,
           let error  = userInfo["error"] as? Error
        {
            self.showAlert(title: "ERROR", message: error.localizedDescription)
        }else
        {
            self.showProfileController()
        }
    }
    
    func receiveForgotPassword(notification:Notification)
    {
        if let userInfo  = notification.userInfo,
           let error  = userInfo["error"] as? Error
        {
            self.showAlert(title: "ERROR", message: error.localizedDescription)
        }else
        {
            self.showAlert(title: "SUCCESS", message: "Forgot password link send to your email id, please reset your password")
        }
    }
    
    func receiveSocialLogin(notification:Notification)
    {
        if let userInfo  = notification.userInfo,
           let error  = userInfo["error"] as? Error
        {
            self.showAlert(title: "ERROR", message: error.localizedDescription)
        }else
        {
            self.showProfileController()
        }
    }
    
    func showNativeGoogleLogin()
    {
        /*
        GIDSignIn.sharedInstance().signIn()
        */
    }
    
    func showNativeFacebookLogin()
    {
        LoginRadiusManager.sharedInstance().nativeFacebookLogin(withPermissions: ["facebookPermissions": ["public_profile"]], in: self, completionHandler:  {(_ success: Bool, _ error: Error?) -> Void in
            
            if success
            {
                self.showProfileController()
            }else if let err = error
            {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
            }
        })

    }
    
    func showProfileController () {
        let defaults = UserDefaults.standard
        if let _:String = defaults.object(forKey: "lrAccessToken") as? String {
            self.performSegue(withIdentifier: "profile", sender: self);
        }else
        {
            self.showAlert(title:"Not Authenticated",message:"Login Radius Access Token is missing")
        }
    }
    
    fileprivate func showAlert(title:String, message:String)
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    //to eliminate "< Back" button showing up when user already logged in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profile"
        {
            segue.destination.navigationItem.hidesBackButton = true
        }
    }
}

