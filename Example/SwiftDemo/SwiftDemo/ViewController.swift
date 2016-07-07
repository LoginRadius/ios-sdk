//
//  ViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 18/05/16.
//  Copyright © 2016 Raviteja Ghanta. All rights reserved.
//


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if already login
        let defaults = NSUserDefaults.standardUserDefaults()
        let user = defaults.integerForKey("isLoggedIn")
        if (user == 1) {
            self.performSegueWithIdentifier("profile", sender: self);
        }
    }
    
    @IBAction func loginWithTwitter(sender: UIButton) {
        LoginRadiusSDK.socialLoginWithProvider("twitter", parameters: nil, inController: self) { (success:Bool, error:NSError!) in
            if (success) {
                NSLog("successfully logged in with twitter");
                self.showProfileController();
            } else {
                NSLog("Error: %@", error.description);
            }
        }
    }
    
    @IBAction func loginWithFacebook(sender: UIButton) {
        LoginRadiusSDK.socialLoginWithProvider("facebook", parameters: nil, inController: self) { (success:Bool, error:NSError!) in
            if (success) {
                NSLog("successfully logged in with facebook");
                self.showProfileController();
            } else {
                NSLog("Error: %@", error.description);
            }
        }
    }
    
    @IBAction func loginWithLinkedin(sender: UIButton) {
        LoginRadiusSDK.socialLoginWithProvider("linkedin", parameters: nil, inController: self) { (success:Bool, error:NSError!) in
            if (success) {
                NSLog("successfully logged in with linkedin");
                self.showProfileController();
            } else {
                NSLog("Error: %@", error.description);
            }
        }
    }
    
    @IBAction func signupWithEmail(sender: UIButton) {
        LoginRadiusSDK.registrationServiceWithAction("registration", inController: self) { (success:Bool, error:NSError!) in
            if (success) {
                NSLog("successfully registered");
            } else {
                NSLog("Error: %@", error.description);
            }
        }
    }
    
    @IBAction func loginWithEmail(sender: UIButton) {
        LoginRadiusSDK.registrationServiceWithAction("login", inController: self) { (success:Bool, error:NSError!) in
            if (success) {
                NSLog("successfully logged in");
            } else {
                NSLog("Error: %@", error.description);
            }
        }
    }
    
    func showProfileController () {
        self.performSegueWithIdentifier("profile", sender: self);
    }
}

