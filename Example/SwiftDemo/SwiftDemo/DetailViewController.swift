//
//  DetailViewController.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 19/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import Eureka
import SwiftyJSON
import LoginRadiusSDK
/* Google Native SignIn
import GoogleSignIn
*/

/* Twitter Native Sign in
import TwitterKit
*/

class DetailViewController: FormViewController {
    
    //List of countries provided from Apple's NSLocale class
    let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }
    
    var accessToken:String!
    var userProfile:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //This is do when there are 2 apps sharing 1 LoginRadius sitename login
        //If the other app logged out, this logs out too.
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupForm), name:  UIApplication.willEnterForegroundNotification, object: nil)
        
        setupForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func setupForm(){
        guard let userAccessToken = LoginRadiusSDK.sharedInstance().session.accessToken
        else
        {
            self.showAlert(title: "ERROR", message: "Access token is missing or logged out")
            self.logoutPressed()
            return
        }
        
        accessToken = userAccessToken
        validateAccessToken(showSuccess: false)
        
        if let userDict = LoginRadiusSDK.sharedInstance().session.userProfile
        {
            if let oldProfile = self.userProfile,
                oldProfile == JSON(userDict)
            {
                //same userProfile, don't reload ui
                return
            }
        
            userProfile = JSON(userDict)
        }else{
            userProfile = JSON([])
        }
        
        //Small UI modification
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.title = "User Profile Swift"

        //Form setup
        self.form = Form()
        
        self.form  +++ Section("")
        <<< ButtonRow("Log out")
        {
            $0.title = $0.tag
            }.onCellSelection{ cell, row in
                self.logoutPressed()
        }
        
        self.smallUserProfileUISetup()
        self.accessTokenUISetup()
        self.customObjectUISetup()
        
    }
    
    // User Profile API Demo
    
    /// Validates simple profile input, see the form construction for form rules
    func validateUserProfileInput()
    {
        let fName = form.rowBy(tag: "FirstName")!
        let lName = form.rowBy(tag: "LastName")!
        let gender = form.rowBy(tag: "Gender")!
        let country = form.rowBy(tag: "Country")!
    
        var errors = fName.validate()
        errors += lName.validate()
        errors += gender.validate()
        errors += country.validate()

        if errors.count > 0{
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        updateProfile(rows:[fName,lName,gender,country])
    }
    
    func updateProfile(rows:[BaseRow])
    {
        var parameters:[String:Any] = [:]
        
        for row in rows
        {
            parameters[row.tag!] = row.baseValue
        
        }
        let country = parameters["Country"] as! String
        let Gender = parameters["Gender"] as! String
        let FirstName = parameters["FirstName"] as! String
        let LastName = parameters["LastName"] as! String
        
        let Country:AnyObject = ["Code":"Primary",
                               "Name":country
            ] as AnyObject
       
        let par:AnyObject = [ "Country":Country,
           "Gender": Gender,
           "FirstName": FirstName,
           "LastName": LastName
            ]as AnyObject

       
    
        AuthenticationAPI.authInstance().updateProfile(withAccessToken:accessToken, emailtemplate: "", smstemplate: "", payload: par as! [AnyHashable : Any], completionHandler: { (data, error) in
            
            if let err = error
            {
                print(err.localizedDescription)
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else
            {
                let access_token = LoginRadiusSDK.sharedInstance().session.accessToken
                self.showAlert(title: "SUCCESS", message: "User updated!")
                print("Here is the raw NSDictionary user profile:")
                let session = LRSession.init(accessToken:access_token as! String, userProfile:data!["Data"] as! [AnyHashable : Any])
                print(data as Any)
                print("end of raw NSDictionary user profile")
                self.viewDidLoad()
            }
        
        })
    }

    // End of User Profile API Demo
    
    // Access Token API Demo
    
    func validateAccessToken(showSuccess:Bool = true)
    {
        
        
        
        AuthenticationAPI.authInstance().validateAccessToken(accessToken, completionHandler: {(data, error) in
            
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else if let d = data,
                    let at = d["access_token"],
                    let expiry = d["expires_in"],
                    showSuccess
            {
                self.showAlert(title: "SUCCESS", message: "Access Token: \(at) is VALID\n expires in: \(expiry)")
            }
        })
    }
    
    func invalidateAccessToken()
    {
       
        AuthenticationAPI.authInstance().invalidateAccessToken(accessToken, completionHandler: {(data, error) in
            
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else if let _ = data
            {
                self.showAlert(title: "SUCCESS", message: "Access Token now is invalid Please Click on Logout Button And try to Login Again")
            }
        })
    }
    
    // Custom Object API Demo
    func createCustomObject()
    {
        var errors = form.rowBy(tag: "CrCO Object Name")!.validate()
        errors += form.rowBy(tag: "CrCO Data")!.validate()

        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let objectName = form.rowBy(tag: "CrCO Object Name")!.baseValue! as! String
        let dataString = form.rowBy(tag: "CrCO Data")!.baseValue! as! String
        let dataJSON = JSON(parseJSON: dataString)
        guard let dataDict = dataJSON.dictionaryObject else
        {
            showAlert(title: "ERROR", message: "Invalid JSON payload")
            return
        }
        
     
    
        CustomObjectAPI.customInstance().createCustomObject(withObjectName: objectName, accessToken: accessToken, payload: dataDict, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "")
            }
        })
    }
    
    func getCustomObject()
    {
        var errors = form.rowBy(tag: "GetCO Object Name")!.validate()

        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let objectName = form.rowBy(tag: "GetCO Object Name")!.baseValue! as! String
        

        CustomObjectAPI.customInstance().getCustomObject(withObjectName: objectName, accessToken: accessToken, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "nil data")
            }
        })
    }
    
            
    func getCustomObjectWithRecordId()
    {
        var errors = form.rowBy(tag: "GetCO Object Name with RecordId")!.validate()
        errors = form.rowBy(tag: "GetCO RecordId with RecordId")!.validate()

        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let objectName = form.rowBy(tag: "GetCO Object Name with RecordId")!.baseValue! as! String
        let recordId = form.rowBy(tag: "GetCO RecordId with RecordId")!.baseValue! as! String
        
        CustomObjectAPI.customInstance().getCustomObject(withObjectRecordId:recordId, accessToken:accessToken, objectname:objectName, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "nil data")
            }
        })
    }
    
    func putCustomObject()
    {
        var errors = form.rowBy(tag: "PutCO Object Name")!.validate()
        errors += form.rowBy(tag: "PutCO RecordId")!.validate()
        errors += form.rowBy(tag: "PutCO Data")!.validate()

        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let objectName = form.rowBy(tag: "PutCO Object Name")!.baseValue! as! String
        let recordId = form.rowBy(tag: "PutCO RecordId")!.baseValue! as! String
        let dataString = form.rowBy(tag: "PutCO Data")!.baseValue! as! String
        let dataJSON = JSON(parseJSON: dataString)
        
        guard let dataDict = dataJSON.dictionaryObject else
        {
            showAlert(title: "ERROR", message: "Invalid JSON payload")
            return
        }
        

        CustomObjectAPI.customInstance().updateCustomObject(withObjectName: objectName, accessToken: accessToken, objectRecordId:recordId, updatetype:"replace", payload: dataDict, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "You are successfully Update the specified Custom Object")
            }
        })
    }
    
    func delCustomObject()
    {
        var errors = form.rowBy(tag: "DelCO Object Name")!.validate()
        errors += form.rowBy(tag: "DelCO RecordId")!.validate()

        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        let objectName = form.rowBy(tag: "DelCO Object Name")!.baseValue! as! String
        let recordId = form.rowBy(tag: "DelCO RecordId")!.baseValue! as! String
        
        CustomObjectAPI.customInstance().deleteCustomObject(withObjectRecordId:recordId, accessToken:accessToken, objectname:objectName, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message:prettyJson.rawString() ?? "You are successfully Delete the specified Custom Object")
            }
        })
    }
    
    // end of Custom Object API
    
    // UI Functions
    
    func showFullProfileController ()
    {
        self.performSegue(withIdentifier: "full profile", sender: self);
    }
    
    func logoutPressed()
    {
        /* Google Native Sign in
        GIDSignIn.sharedInstance().signOut()
        */

        /* Twitter Native Sign in
        twitterLogout()
        */
        LoginRadiusSDK.logout()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    /* Twitter Native Sign in
    func twitterLogout(){
        if let twitterSessions = Twitter.sharedInstance().sessionStore.existingUserSessions() as? [TWTRAuthSession]{
            for session in twitterSessions{
                Twitter.sharedInstance().sessionStore.logOutUserID(session.userID)
            }
        }
    }
    */
    
    func toggleRedBorderShowErrorMessage(cell:UIView, row:BaseRow)
    {
        if !row.isValid {
            cell.layer.borderWidth = 3
            cell.layer.borderColor = UIColor.red.cgColor
        }else{
            cell.layer.borderWidth = 0
            cell.layer.borderColor = UIColor.clear.cgColor
        }
    }
}
