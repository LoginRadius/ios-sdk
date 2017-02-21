//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 Raviteja Ghanta. All rights reserved.
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
        LoginRadiusSocialLoginManager.sharedInstance().login(withProvider: "twitter", parameters: nil, in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with twitter");
                self.showProfileController();
            } else {

            }
        });
    }

    var a:LRServiceCompletionHandler!;

    @IBAction func loginWithFacebook(_ sender: UIButton) {
        LoginRadiusSocialLoginManager.sharedInstance().login(withProvider: "facebook", parameters: nil, in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with facebook");
                self.showProfileController();
            } else {

            }
        });
    }
    
    @IBAction func loginWithLinkedin(_ sender: UIButton) {
        LoginRadiusSocialLoginManager.sharedInstance().login(withProvider: "linkedin", parameters: nil, in: self, completionHandler: { (success, error) in
            if (success) {
                print("successfully logged in with linkedin");
                self.showProfileController();
            } else {

            }
        });
    }
    
    @IBAction func signupWithEmail(_ sender: UIButton) {

    }
    
    @IBAction func loginWithEmail(_ sender: UIButton) {
    }
    
    func showProfileController () {
        self.performSegue(withIdentifier: "profile", sender: self);
    }
}

