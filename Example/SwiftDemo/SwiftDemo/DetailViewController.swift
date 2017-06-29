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
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupForm), name:  NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        setupForm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupForm(){
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

        if errors.count > 0
        {
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
            
            if LoginRadiusField.addressFields().contains(row.tag!.lowercased())
            {
                if parameters["addresses"] == nil
                {
                    parameters["addresses"] = [[row.tag!:row.baseValue!]]
                }else if var arr = parameters["addresses"] as? [[String:Any]]
                {
                    arr[0][row.tag!] = row.baseValue!
                    parameters["addresses"] = arr
                }
                
                parameters.removeValue(forKey: row.tag!)
            }
        }
        
        //if contains address, add type at the end.
        if parameters["addresses"] != nil,
           var arr = parameters["addresses"] as? [[String:Any]]
        {
            arr[0]["type"] = "Personal"
            parameters["addresses"] = arr
        }
    
        LoginRadiusRegistrationManager.sharedInstance().authUpdateProfilebyToken(accessToken, verificationUrl: "", emailTemplate: "", userData: parameters, completionHandler: { (data, error) in
            
            if let err = error
            {
                print(err.localizedDescription)
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else
            {
                LoginRadiusRegistrationManager.sharedInstance().authProfiles(byToken: self.accessToken, completionHandler: {(data, error) in
                    
                    if let err = error
                    {
                        self.showAlert(title: "ERROR", message: err.localizedDescription)
                    }else if let userProfile = data
                    {
                        self.showAlert(title: "SUCCESS", message: "User updated!")
                        print("Here is the raw NSDictionary user profile:")
                        print(userProfile)
                        print("end of raw NSDictionary user profile")
                        self.viewDidLoad()
                    }
                })
            }
        
        })
    }

    // End of User Profile API Demo
    
    // Access Token API Demo
    
    func validateAccessToken(showSuccess:Bool = true)
    {
        LoginRadiusRegistrationManager.sharedInstance().authValidateAccessToken(accessToken, completionHandler: {(data, error) in
            
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
        LoginRadiusRegistrationManager.sharedInstance().authInvalidateAccessToken(accessToken, completionHandler: {(data, error) in
            
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else if let _ = data
            {
                self.logoutPressed()
                self.showAlert(title: "SUCCESS", message: "Token now is invalid")
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
    
        LoginRadiusCustomObjectManager.sharedInstance().createCustomObject(withName: objectName, accessToken: accessToken, data: dataDict, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "nil data")
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

        LoginRadiusCustomObjectManager.sharedInstance().getCustomObject(withName: objectName, accessToken: accessToken, completionHandler: {data, error in
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

        LoginRadiusCustomObjectManager.sharedInstance().getCustomObject(withName: objectName, accessToken: accessToken, objectRecordId: recordId, completionHandler: {data, error in
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
    
        LoginRadiusCustomObjectManager.sharedInstance().putCustomObject(withName: objectName, accessToken: accessToken, objectRecordId: recordId, data: dataDict, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "nil data")
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
    
        LoginRadiusCustomObjectManager.sharedInstance().deleteCustomObject(withName: objectName, accessToken: accessToken, objectRecordId: recordId, completionHandler: {data, error in
            if let err = error
            {
                self.showAlert(title: "ERROR", message: err.localizedDescription)
            }else{
                let prettyJson = JSON(data as Any)
                self.showAlert(title: "SUCCESS", message: prettyJson.rawString() ?? "nil data")
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
        /* Google Native SignIn
        GIDSignIn.sharedInstance().signOut()
        */
        LoginRadiusSDK.logout()
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
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
