//
//  DetailViewController.swift
//  SwiftDemo
//
//  Created by Raviteja Ghanta on 19/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import LoginRadiusSDK
import Eureka
import SwiftyJSON
/* Google Native SignIn
import GoogleSignIn
*/
class DetailViewController: FormViewController {

    //List of countries provided from Apple's NSLocale class
    let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Extract relevant data for simple profile
        let defaults = UserDefaults.standard
        var user:JSON = JSON([])
        
        if let userDict = defaults.object(forKey: "lrUserProfile") as? NSDictionary
        {
            user = JSON(userDict)
        }

        let userEmail = ((user["Email"].array)?[0]["Value"] )?.string
        
        var userCountry:String? = nil
        if let countryDict = user["Country"].dictionary,
            let countryStr = countryDict["Name"]?.string
        {
            userCountry = countryStr
        }

        let gender = (user["Gender"].stringValue.isEmpty) ? user["Gender"].stringValue:"?"
        //end data extraction
        
        //Small UI modification
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "User Profile"
        
        //Form setup
        self.form = Form()
        
        form  +++ Section("")
            <<< ButtonRow("Log out")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell,row in
                    self.logoutPressed()
            }
        form  +++ Section("")
            <<< ButtonRow("View Full Profile")
            {
                $0.title = $0.tag
                }.onCellSelection{ cell,row in
                    self.showFullProfileController()
            }
        form  +++ Section("")
            <<< NameRow("FirstName")
            {
                $0.title = "First Name"
                $0.disabled = Condition(booleanLiteral: true)
                $0.value = user[$0.tag!].stringValue
            }
            <<< NameRow("LastName")
            {
                $0.title = "Last Name"
                $0.disabled = Condition(booleanLiteral: true)
                $0.value = user[$0.tag!].stringValue
            }
            <<< EmailRow("Email")
            {
                $0.title = $0.tag
                $0.disabled = Condition(booleanLiteral: true)
                $0.value = userEmail ?? nil
            }
            <<< SegmentedRow<String>("Gender"){
                $0.title = $0.tag
                $0.options = ["M","F","?"]
                $0.disabled = Condition(booleanLiteral: true)
                $0.value = gender
            }
        
            <<< PushRow<String>("Country") {
                $0.title = $0.tag
                $0.options = countries
                $0.value = userCountry
                $0.disabled = Condition(booleanLiteral: true) 
                $0.selectorTitle = "Country"
            }

    }
    
    func showFullProfileController () {
        self.performSegue(withIdentifier: "full profile", sender: self);
    }
    
    func logoutPressed() {
        /* Google Native SignIn
        GIDSignIn.sharedInstance().signOut()
        */
        LoginRadiusSDK.logout()
        let _ = self.navigationController?.popViewController(animated: true)
    }
}
