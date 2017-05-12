//
//  DetailViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 19/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import LoginRadiusSDK

class DetailViewController: UIViewController {
    
    @IBOutlet weak var name: UITextView!
    @IBOutlet weak var uid: UITextView!
    @IBOutlet weak var email: UITextView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        var first:String = ""
        var middle:String = ""
        var last:String = ""
        var uid:String = ""
        var emails: [Dictionary<String, String>] = []
        var email:String = ""

        let defaults = UserDefaults.standard
        if let user:NSDictionary = defaults.object(forKey: "lrUserProfile") as? NSDictionary {
            print(user)
            first = user.object(forKey: "FirstName")! as! String
            middle = user.object(forKey: "MiddleName")! as! String
            last = user.object(forKey: "LastName")! as! String
            uid = user.object(forKey: "Uid")! as! String
            
            //Need to unwrap properly, some social providers doesnt give the email
            if  let emailArr = user.object(forKey: ("Email" as Any)) as? Array<Dictionary<String,String>>,
                let value = emailArr[0]["Value"]
            {
                email = value
            }
        }

        let fullname = String(format: "%@ %@ %@", first, middle, last)
        self.name.text = fullname
        self.uid.text = uid
        self.email.text = email
    }
    
    @IBAction func logoutPressed(_ sender: AnyObject) {
        LoginRadiusSDK.logout()
        self.navigationController?.popViewController(animated: false)
    }
}
