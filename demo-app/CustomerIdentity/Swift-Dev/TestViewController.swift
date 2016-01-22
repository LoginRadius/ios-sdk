//
//  TestViewController.swift
//  Swift-Dev
//
//  Created by Lucius Yu on 2015-09-21.
//  Copyright © 2015 LoginRadius. All rights reserved.
//

import Foundation


class TestViewController: UIViewController {
    
    @IBAction func profileBtnTouched(sender: AnyObject) {
        print("clicked");
        let lrUserDefaults = NSUserDefaults.standardUserDefaults();
        let lrUserProfile: AnyObject? = lrUserDefaults.objectForKey("lrUserProfile");
        
        print(lrUserProfile);
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationVC: UserRegistrationServiceViewController = segue.destinationViewController as! UserRegistrationServiceViewController;
        destinationVC.siteName = "<Your LoginRadius Site Name>";
        destinationVC.apiKey = "<Your LoginRadius API Key>";
        
        switch segue.identifier! {
            case "registration":
                destinationVC.action = "registration";
            case "login":
                destinationVC.action = "login"; // Set it to "emaillogin" to hide social login
            case "social":
                destinationVC.action = "social";
            case "forgotpassword":
                destinationVC.action = "forgotpassword";
            case "resetpassword":
                destinationVC.action = "resetpassword";
            default:
                destinationVC.action = "";
        }
    }
}