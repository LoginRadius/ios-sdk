//
//  DetailViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 19/05/16.
//  Copyright © 2016 Raviteja Ghanta. All rights reserved.
//

class DetailViewController: UIViewController {
    
    @IBOutlet weak var name: UITextView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        var first:String = ""
        var middle:String = ""
        var last:String = ""
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let user:NSDictionary = defaults.objectForKey("lrUserProfile") as? NSDictionary {
            print(user)
            first = user.objectForKey("FirstName")! as! String
            middle = user.objectForKey("MiddleName")! as! String
            last = user.objectForKey("LastName")! as! String
        }
        
        let fullname = String(format: "%@ %@ %@", first, middle, last)
        self.name.text = fullname
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        LoginRadiusSDK.logout()
        self.navigationController?.popViewControllerAnimated(false)
    }
}
