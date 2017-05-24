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
        
        self.navigationController?.navigationBar.topItem?.title = "Login Radius iOS pod 3.4.0"
        self.form = Form()
        
        //Create UI forms
        form +++ Section("Traditional Login")
            <<< ButtonRow("Login LR API")
            {
                $0.title = "Login"
                }.onCellSelection{ cell, row in
                    self.traditionalLogin()
            }
            <<< ButtonRow("Register LR API")
            {
                $0.title = "Register"
                }.onCellSelection{ cell, row in
                    self.traditionalRegistration()
            }
            <<< ButtonRow("Forgot LR API")
            {
                $0.title = "Forgot Password"
                }.onCellSelection{ row in
                    self.forgotPassword()
            }
        
            +++ Section("Direct Social Logins")
            <<< ButtonRow("Google")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell, row in
                    self.showSocialLogins(provider:"google")
            }
            <<< ButtonRow("Facebook")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell, row in
                    self.showSocialLogins(provider:"facebook")
            }
            <<< ButtonRow("Twitter")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell, row in
                    self.showSocialLogins(provider:"twitter")
            }
        
            +++ Section("Only Social Hosted Page")
            <<< ButtonRow("Social Hosted Page")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell, row in
                    self.showSocialOnly()
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
    
    func traditionalRegistration() {
        LoginRadiusManager.sharedInstance().registration(withAction: "registration", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully registered");
                self.showProfileController();
            } else if let err = error {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
            }
        });
    }
    
    func traditionalLogin() {
        LoginRadiusManager.sharedInstance().registration(withAction: "login", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in");
                self.showProfileController();
            } else if let err = error {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
            }
        });
    }
    
    func forgotPassword() {
        LoginRadiusManager.sharedInstance().registration(withAction: "forgotpassword", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully request forgot password");
                self.showAlert(title: "SUCCESS", message: "Forgot Password Requested, check your email inbox to reset")
            } else if let err = error {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
            }
        });
    }
    
    func showSocialLogins(provider:String)
    {
        LoginRadiusManager.sharedInstance().login(withProvider: provider, in: self, completionHandler: { (success, error) in
            if (success) {
                //this needs to be handled from app delegate call, see AppDelegate.swift
                print("successfully logged in with \(provider)");
                self.showProfileController()
            } else if let err = error  {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
            }
        });
    }
    
    func showSocialOnly() {
        LoginRadiusManager.sharedInstance().registration(withAction: "social", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with social hosted page");
                self.showProfileController();
            } else if let err = error {
                self.showAlert(title:"ERROR",message:err.localizedDescription)
            }
        });
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

