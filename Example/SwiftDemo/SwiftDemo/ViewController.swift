//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import LoginRadiusSDK
import Eureka

class ViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if already login
        let defaults = UserDefaults.standard
        let user = defaults.integer(forKey: "isLoggedIn")
        if (user == 1) {
            self.performSegue(withIdentifier: "profile", sender: self);
        }
        
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

    }
    
    func traditionalRegistration() {
        LoginRadiusManager.sharedInstance().registration(withAction: "registration", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully registered");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    func traditionalLogin() {
        LoginRadiusManager.sharedInstance().registration(withAction: "login", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    func forgotPassword() {
        LoginRadiusManager.sharedInstance().registration(withAction: "forgotpassword", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully request forgot password");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    func showSocialLogins(provider:String)
    {
        LoginRadiusManager.sharedInstance().login(withProvider: provider, in: self, completionHandler: { (success, error) in
            if (success) {
                //this needs to be handled from app delegate call, see AppDelegate.swift
                print("successfully logged in with \(provider)");
            } else {
                
            }
        });
    }
    
    func showSocialOnly() {
        LoginRadiusManager.sharedInstance().registration(withAction: "social", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with social hosted page");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    func showProfileController () {
        let defaults = UserDefaults.standard
        if let _:String = defaults.object(forKey: "lrAccessToken") as? String {
            self.performSegue(withIdentifier: "profile", sender: self);
        }else
        {
            DispatchQueue.main.async
            {
                let alert = UIAlertController(title: "Not Authenticated", message: "Login Radius Access Token is missing", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
                self.present(alert, animated: true, completion:nil)
            }
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

