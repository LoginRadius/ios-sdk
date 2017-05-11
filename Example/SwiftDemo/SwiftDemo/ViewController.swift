//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import LoginRadiusSDK

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if already login
        let defaults = UserDefaults.standard
        let user = defaults.integer(forKey: "isLoggedIn")
        if (user == 1) {
            self.performSegue(withIdentifier: "profile", sender: self);
        }
    }
    
    @IBAction func loginWithTwitter(_ sender: UIButton) {
        LoginRadiusRegistrationManager.sharedInstance().login(withProvider: "twitter", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with twitter");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }

    @IBAction func loginWithFacebook(_ sender: UIButton) {
        LoginRadiusRegistrationManager.sharedInstance().login(withProvider: "facebook", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with facebook");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    @IBAction func loginWithLinkedin(_ sender: UIButton) {
        LoginRadiusRegistrationManager.sharedInstance().login(withProvider: "linkedin", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with linkedin");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    @IBAction func signupWithEmail(_ sender: UIButton) {
        LoginRadiusRegistrationManager.sharedInstance().registration(withAction: "registration", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully registered");
                self.showProfileController();
            } else {
                print(error!.localizedDescription)
            }
        });
    }
    
    @IBAction func loginWithEmail(_ sender: UIButton) {
        LoginRadiusRegistrationManager.sharedInstance().registration(withAction: "login", in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in");
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
        }
    }
}

