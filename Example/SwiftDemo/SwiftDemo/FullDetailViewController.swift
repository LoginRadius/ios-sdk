//
//  FullDetailViewController.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 2017-05-16.
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

import Foundation
import Eureka
import SwiftyJSON
import LoginRadiusSDK

class FullDetailViewController: FormViewController {
    
    var dateFormatter:DateFormatter = {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormat
    }()
    
    var accessToken:String!
    var userProfile:JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //This is do when there are 2 apps sharing 1 LoginRadius sitename login
        //If the other app logged out, this logs out too.
        NotificationCenter.default.addObserver(self, selector: #selector(self.setupForm), name:  UIApplication.willEnterForegroundNotification, object: nil)
        
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
    
    @objc func setupForm() {
        
        guard let userAccessToken = LoginRadiusSDK.sharedInstance().session.accessToken
        else
        {
            //if logged out for some reason, go back. (e.g. shared keychain, and it logged out from another app, and this app enters from background)
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        if let oldToken = self.accessToken,
            oldToken == userAccessToken
        {
            //same token, don't reload ui
            return
        }
        
        accessToken = userAccessToken
                
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

        self.form = Form()
        
        self.navigationItem.title = "Full Profile"
    
        form  +++ Section("")
        for (k,v) in userProfile
        {
            addEurekaElement(key: k , userInfo: v)
        }
    }
    
    /// Add a eureka row element from a given key dictionary and a generic type value
    func addEurekaElement( key:String, userInfo: JSON )
    {
        var lastSection:Section = form.last!
            
        if let bool = userInfo.bool
        {
            //print("\(key) is a Bool")
            lastSection <<< TextRow(key)
            {
                $0.title = $0.tag
                $0.value = (bool ? "true" : "false")
                $0.disabled = Condition(booleanLiteral: true)
            }
            
        } else if let int =  userInfo.int
        {
            //print("\(key) is an Int")
            lastSection <<< IntRow(key)
            {
                $0.title = $0.tag
                $0.value = int
                $0.disabled = Condition(booleanLiteral: true)
            }
        }else if let str = userInfo.string
        {
            //print("\(key) is a String")
            if key.lowercased().contains("date")
            {
                lastSection <<< DateRow(key)
                {
                    $0.title = $0.tag
                    $0.value = dateFormatter.date(from: str)
                    $0.disabled = Condition(booleanLiteral: true)
                }
            }else if key.lowercased().contains("url"),
                let url = URL(string:str)
            {
                lastSection <<< URLRow(key)
                {
                    $0.title = $0.tag
                    $0.value = url
                    $0.disabled = Condition(booleanLiteral: true)
                }
            }else if key.lowercased().contains("email")
            {
                lastSection <<< EmailRow(key)
                {
                    $0.title = $0.tag
                    $0.value = str
                    $0.disabled = Condition(booleanLiteral: true)
                }
            }else if key.lowercased().contains("name")
            {
                lastSection <<< NameRow(key)
                {
                    $0.title = $0.tag
                    $0.value = str
                    $0.disabled = Condition(booleanLiteral: true)
                }
            }else if key.lowercased().contains("password")
            {
                lastSection <<< PasswordRow(key)
                {
                    $0.title = $0.tag
                    $0.value = str
                    $0.disabled = Condition(booleanLiteral: true)
                }
            }else
            {
                lastSection <<< TextRow(key)
                {
                    $0.title = $0.tag
                    $0.value = str
                    $0.disabled = Condition(booleanLiteral: true)
                }
            }
            
        }else if let arr = userInfo.array
        {
            //print("\(key) is an Array")
            form  +++ Section(key)
            lastSection = form.last!
            
            //Handle email object and phone numbers manually
            if key == "Email"
            {
                for i in arr
                {
                    if let newDict = i.dictionaryObject
                    {
                        for (dictkey, dictv) in newDict
                        {
                            let k = dictkey 
                            let v = dictv as! String
                            
                            if k.contains("Value")
                            {
                                lastSection <<< EmailRow(k)
                                {
                                    $0.title = $0.tag
                                    $0.value = v
                                    $0.disabled = Condition(booleanLiteral: true)
                                    
                                }
                            }else if k.contains("Type")
                            {
                                lastSection <<< TextRow(k)
                                {
                                    $0.title = $0.tag
                                    $0.value = v
                                    $0.disabled = Condition(booleanLiteral: true)
                                }
                            }
                        }
                    }
                }
                
            }else if key == "PhoneNumbers"
            {
                for i in arr
                {
                    if let newDict = i.dictionaryObject
                    {
                        for (dictkey, dictv) in newDict
                        {
                            let k = dictkey 
                            let v = dictv as! String
                            
                            if k.contains("PhoneNumber")
                            {
                                lastSection <<< PhoneRow(k)
                                {
                                    $0.title = $0.tag
                                    $0.value = v
                                    $0.disabled = Condition(booleanLiteral: true)
                                    
                                }
                            }else if k.contains("PhoneType")
                            {
                                lastSection <<< TextRow(k)
                                {
                                    $0.title = $0.tag
                                    $0.value = v
                                    $0.disabled = Condition(booleanLiteral: true) 
                                }
                            }
                        }
                    }
                }
            }
            
            form  +++ Section("")
            
        }else if let dict = userInfo.dictionary
        {
            //print("\(key) is a Dictionary")
            form  +++ Section(key)
            
            for (k,v) in dict
            {
                addEurekaElement(key: k , userInfo: v)
            }
            form  +++ Section("")
            
        }else{
            print("\(key), unknown type")
        }
    }
    
}
