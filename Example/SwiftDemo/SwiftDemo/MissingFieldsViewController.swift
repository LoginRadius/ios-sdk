//
//  DetailViewController.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 19/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import Foundation
import Eureka
import LoginRadiusSDK

class MissingFieldsViewController: FormViewController
{
    var accessToken = UserDefaults.standard.object(forKey: "token") as? String
    
    
    var lrFields:[LoginRadiusField]?
    let countries = NSLocale.isoCountryCodes.map { (code:String) -> String in
        let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
        return NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
       
       
        
        setupForm()
    }
    
    func setupForm()
    {
        self.navigationItem.title = "Missing Fields"
        self.showAlert(title: "WARNING", message: "User need to add these fields in order to proceed the login process")

        self.form = Form()
        let mfSection = Section("Missing Fields Section")
        {
            $0.header = nil
            $0.tag = "Missing Fields Section"
        }
        
        self.form +++ mfSection
       
    
        
        setupDynamicRequredfieldForm(lrFields: LoginRadiusSchema.sharedInstance().fields, dynamicRegSection: mfSection, loadingRow: nil, hiddenCondition: nil, sendButtonTitle: "Send", askForEmailAvailability: false, askForUsernameAvailability:false, sendHandler:
        {
            self.validateUserProfileInput()
        })
    }
    
    func validateUserProfileInput()
    {
        guard let dynamicRegSection = form.sectionBy(tag: "Missing Fields Section") else
        {
            showAlert(title: "ERROR", message: "No Missing Fields Section")
            return
        }
        
        var errors:[ValidationError] = []
        
        for row in dynamicRegSection
        {
            errors += row.validate()
        }
        
        if errors.count > 0
        {
            showAlert(title: "ERROR", message: errors[0].msg)
            return
        }
        
        updateProfile()
    }
    
    func updateProfile()
    {
        
        var parameters:[String:Any] = [:]
        var allRows = form.allRows
        
        for i in 0...allRows.count-2 //don't include the button row
        {
            let row = allRows[i]
            
            if row.tag != "emailid"
            {
                if let dateRow = row as? DateRow
                {
                    //let mm-dd-yyyy
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    parameters[row.tag!] = dateFormatter.string(from: dateRow.value!)
                }else
                {
                
                    parameters[row.tag!] = row.baseValue
                }
            }else{
                parameters["email"] = [["type":"Primary","value":row.baseValue!]]
            }
            
            if row.tag!.hasPrefix("cf_")
            {
                
                let range =  row.tag!.index(row.tag!.startIndex, offsetBy: 3)..<row.tag!.endIndex
                let modifiedTag = String(row.tag![range])
                
                if var dict = parameters["CustomFields"] as? [String:Any]
                {
                    dict[modifiedTag] = parameters[row.tag!]!
                    parameters["CustomFields"] = dict
                }else
                {
                    parameters["CustomFields"] = [modifiedTag:parameters[row.tag!]!]
                }
                
                parameters.removeValue(forKey: row.tag!)
            }
            
            if LoginRadiusField.addressFields().contains(row.tag!)
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
AuthenticationAPI.authInstance().updateProfile(withAccessToken:accessToken!, emailtemplate:nil, smstemplate:nil, payload:parameters, completionHandler: { (data, error) in
            
            if let err = error
            {
                let e = err as NSError
                self.showAlert(title: "ERROR", message: (e.localizedDescription == ".") ? e.localizedFailureReason! : e.localizedDescription)
            }else
            {
                DispatchQueue.main.async
                    {
                    self.navigationController?.popViewController(animated: false, completion: { navVC in
                        if let vc = navVC.viewControllers.first as? ViewController
                        {
                            if let err = error
                            {
                                vc.showAlert(title: "ERROR", message: err.localizedDescription)
                            }else
                            {
                                LRSession.init(accessToken:self.accessToken!, userProfile:data!["Data"] as! [AnyHashable : Any])
                                vc.showProfileController()
                            }
                        }
                    })
                }
            }
        
        })
    }
}
