//
//  ViewControllerExtension.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 18/05/16.
//  Copyright © 2016 LoginRadius Inc. All rights reserved.
//

import Foundation
import Eureka
import LoginRadiusSDK

//Extension to handle dynamic registration generation
//Converts LoginRadius Fields to Eureka Rows
extension FormViewController
{
    func setupDynamicRegistrationForm(lrFields:[LoginRadiusField]?,dynamicRegSection:Section, loadingRow:LabelRow?, hiddenCondition:Condition?, sendButtonTitle:String? = "Register",askForEmailAvailability:Bool = true, askForUsernameAvailability:Bool = true, sendHandler:(()->Void)?)
    {
        if let fields = lrFields
        {
            
            for field in fields
            {
                //will crash if there exist 2 fields with the same name
                switch field.type
                {
                    case .STRING:
                    
                        if (field.name != "username")
                        {
                            dynamicRegSection <<< AccountRow(field.name)
                            {
                                $0.title = field.display
                                $0.hidden = hiddenCondition
                                self.setRegistrationRowRules(field: field, row: $0)
                            }
                        }else{
                            dynamicRegSection <<< AccountRow(field.name)
                            {
                                $0.title = field.display
                                $0.hidden = hiddenCondition
                                self.setRegistrationRowRules(field: field, row: $0)
                            }.onChange{ row in
                                if (askForUsernameAvailability){
                                    self.toggleRegisterAvailability(rowTag:row.tag!, msgName: field.name, available:nil)
                                }
                            }.onCellHighlightChanged{ cell, row in
                                //if the user resign other email input field and press something else
                                if (!row.isHighlighted && askForUsernameAvailability)
                                {
                                    //check for email availability
                                    self.checkUsernameAvailability(usernameStr: row.value ?? "", usernameRowTag: row.tag!)
                                }
                        }
                        
                        
                        }
                    case .OPTION:
                
                        dynamicRegSection <<< ActionSheetRow<String>(field.name)
                        {
                            $0.title = field.display
                            $0.selectorTitle = field.display
                            $0.options = (field.option?.keys != nil) ? Array(field.option!.keys) : []
                            $0.displayValueFor = { value in
                                guard let val = value else {
                                    return nil
                                }
                                return field.option?[val] ?? ""
                            }
                            $0.hidden = hiddenCondition
                            $0.value = nil
                            self.setRegistrationRowRules(field: field, row: $0 )
                        }
                    case .MULTI:
                        dynamicRegSection <<< CheckRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = hiddenCondition
                            $0.value = nil
                            self.setRegistrationRowRules(field: field, row: $0 )

                        }
                    case .PASSWORD:
                        dynamicRegSection <<< PasswordRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = hiddenCondition
                            self.setRegistrationRowRules(field: field, row: $0 )

                        }
                    case .HIDDEN:
                        dynamicRegSection <<< AccountRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = Condition(booleanLiteral: true)
                            self.setRegistrationRowRules(field: field, row: $0 )
                        }
                    case .EMAILID:
                        dynamicRegSection <<< EmailRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = hiddenCondition
                            $0.add(rule: RuleEmail(msg: "Invalid Email Format"))
                            self.setRegistrationRowRules(field: field, row: $0 )
                        }.onChange{ row in
                            if (askForEmailAvailability){
                                self.toggleRegisterAvailability(rowTag:row.tag!, msgName: field.name, available:nil)
                            }
                        }.onCellHighlightChanged{ cell, row in
                            //if the user resign other email input field and press something else
                            if (!row.isHighlighted && askForEmailAvailability)
                            {
                                //check for email availability
                                self.checkEmailAvailability(emailStr: row.value ?? "", emailRowTag: row.tag!)
                            }
                        }
                    case .TEXT:
                        dynamicRegSection <<< TextAreaRow(field.name)
                        {
                            $0.title = field.display
                            $0.placeholder = field.display
                            $0.hidden = hiddenCondition
                            self.setRegistrationRowRules(field: field, row: $0 )
                        }
                    case .DATE:
                        dynamicRegSection <<< DateRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = hiddenCondition
                            self.setRegistrationRowRules(field: field, row: $0 )
                        }
                }
            }
            
            dynamicRegSection <<< ButtonRow("Dynamic Registration Send")
            {
                $0.title = sendButtonTitle
                $0.hidden = hiddenCondition
                }.onCellSelection{ cell, row in
                    sendHandler?()
                    //self.requestSOTT(completion: self.dynamicRegistration)
            }
            
            loadingRow?.hidden = Condition(booleanLiteral: true);
            loadingRow?.evaluateHidden()
        }else
        {
            loadingRow?.title = "No Registration Fields"
        }
    }
    
    
    func setupDynamicRequredfieldForm(lrFields:[LoginRadiusField]?,dynamicRegSection:Section, loadingRow:LabelRow?, hiddenCondition:Condition?, sendButtonTitle:String? = "Register",askForEmailAvailability:Bool = true, askForUsernameAvailability:Bool = true, sendHandler:(()->Void)?)
    {
      
        
        if let fields = lrFields
        {
           
            for field in fields
            {
                //will crash if there exist 2 fields with the same name
                switch field.type
                {
                case .STRING:
                    
                    
                    if (field.name != "username")
                    {
                        dynamicRegSection <<< AccountRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = hiddenCondition
                            self.setRegistrationRowRules(field: field, row: $0)
                        }
                    }else{
                        dynamicRegSection <<< AccountRow(field.name)
                        {
                            $0.title = field.display
                            $0.hidden = hiddenCondition
                            self.setRegistrationRowRules(field: field, row: $0)
                            }.onChange{ row in
                                if (askForUsernameAvailability){
                                    self.toggleRegisterAvailability(rowTag:row.tag!, msgName: field.name, available:nil)
                                }
                            }.onCellHighlightChanged{ cell, row in
                                //if the user resign other email input field and press something else
                                if (!row.isHighlighted && askForUsernameAvailability)
                                {
                                    //check for email availability
                                    self.checkUsernameAvailability(usernameStr: row.value ?? "", usernameRowTag: row.tag!)
                                }
                        }
                        
                        
                  }
                case .OPTION:
                    dynamicRegSection <<< AlertRow<String>(field.name)
                    {
                        $0.title = field.display
                        $0.selectorTitle = field.display
                        $0.options = (field.option?.keys != nil) ? Array(field.option!.keys) : []
                        $0.displayValueFor = { value in
                            guard let val = value else {
                                return nil
                            }
                            return field.option?[val] ?? ""
                        }
                        $0.hidden = hiddenCondition
                        $0.value = nil
                        self.setRegistrationRowRules(field: field, row: $0 )
                    }
               
                case .MULTI:
                    
                    dynamicRegSection <<< CheckRow(field.name)
                    {
                        $0.title = field.display
                        $0.hidden = hiddenCondition
                        $0.value = nil
                        self.setRegistrationRowRules(field: field, row: $0 )
                        
                    }

                case .PASSWORD:
                    
             
                    dynamicRegSection <<< PasswordRow(field.name)
                    {
                        $0.title = field.display
                        $0.hidden = hiddenCondition
                        self.setRegistrationRowRules(field: field, row: $0 )
                        
                    }
              
                case .HIDDEN:
              
                    dynamicRegSection <<< AccountRow(field.name)
                    {
                        $0.title = field.display
                        $0.hidden = Condition(booleanLiteral: true)
                        self.setRegistrationRowRules(field: field, row: $0 )
                    }
             
                case .EMAILID:
             

                    dynamicRegSection <<< EmailRow(field.name)
                    {
                        $0.title = field.display
                        $0.hidden = hiddenCondition
                        $0.add(rule: RuleEmail(msg: "Invalid Email Format"))
                        self.setRegistrationRowRules(field: field, row: $0 )
                        }.onChange{ row in
                            if (askForEmailAvailability){
                                self.toggleRegisterAvailability(rowTag:row.tag!, msgName: field.name, available:nil)
                            }
                        }.onCellHighlightChanged{ cell, row in
                            //if the user resign other email input field and press something else
                            if (!row.isHighlighted && askForEmailAvailability)
                            {
                                //check for email availability
                                self.checkEmailAvailability(emailStr: row.value ?? "", emailRowTag: row.tag!)
                            }
                    }
                  
                case .TEXT:
                
                    dynamicRegSection <<< TextAreaRow(field.name)
                    {
                        $0.title = field.display
                        $0.placeholder = field.display
                        $0.hidden = hiddenCondition
                        self.setRegistrationRowRules(field: field, row: $0 )
                    }
                  
                 case .DATE:
                
                    dynamicRegSection <<< DateRow(field.name)
                    {
                        $0.title = field.display
                        $0.hidden = hiddenCondition
                        self.setRegistrationRowRules(field: field, row: $0 )
                    }
                 
                }
            }
            
            dynamicRegSection <<< ButtonRow("Dynamic Registration Send")
            {
                $0.title = sendButtonTitle
                $0.hidden = hiddenCondition
                }.onCellSelection{ cell, row in
                    sendHandler?()
                    //self.requestSOTT(completion: self.dynamicRegistration)
            }
            
            loadingRow?.hidden = Condition(booleanLiteral: true);
            loadingRow?.evaluateHidden()
        }else
        {
            loadingRow?.title = "No Registration Fields"
        }
    }

    //Converts LoginRadiusFieldRules to EurekaRules
    func setRegistrationRowRules(field:LoginRadiusField, row:BaseRow) -> Void
    {
        guard let fieldRules = field.rules else
        {
            return
        }
        
        let rowString = row as? RowOf<String> //generic for fieldRow
        let rowBool  = row as? CheckRow

        for fRule in fieldRules
        {
            var errMsg = "\(field.display) do not have "

            switch fRule.type {
                case .unknown:
                    self.showAlert(title: "Unknown Rule", message: "Unknown Rule type added on registration")
                case .numeric: fallthrough
                case .alpha_dash:
                    errMsg = errMsg + "valid "
                    fallthrough
                case .valid_url: fallthrough
                case .valid_ip: fallthrough
                case .valid_email: fallthrough
                case .valid_ca_zip: 
                    errMsg = errMsg + "\(fRule.typeToString()) format"
                    rowString?.add(rule: RuleRegExp(regExpr: fRule.regex!, allowsEmpty: true, msg: errMsg))
                case .custom_validation:
                    rowString?.add(rule: RuleRegExp(regExpr: fRule.regex!, allowsEmpty: true, msg: fRule.stringValue!))
                case .exact_length:
                    errMsg = errMsg + "\(fRule.typeToString()) of \(fRule.intValue!)"
                    rowString?.add(rule:RuleMaxLength(maxLength: UInt(truncating: fRule.intValue!), msg: errMsg))
                    rowString?.add(rule:RuleMinLength(minLength: UInt(truncating: fRule.intValue!), msg: errMsg))
                case .matches:
                    errMsg = "\(field.display) needs to match with \(self.form.rowBy(tag: fRule.stringValue!)?.title ?? "Unknown Field" )"
                    rowString?.add(rule: RuleEqualsToRow(form: self.form, tag: fRule.stringValue!, msg: errMsg))
                    rowBool?.add(rule: RuleEqualsToRow(form: self.form, tag: fRule.stringValue!, msg: errMsg))
                case .max_length:
                    errMsg = "\(field.display) exceeds \(fRule.typeToString()) of \(fRule.intValue!)"
                    rowString?.add(rule:RuleMaxLength(maxLength: UInt(truncating: fRule.intValue!), msg: errMsg))
                case .min_length:
                    errMsg = "\(field.display) needs \(fRule.typeToString()) of \(fRule.intValue!)"
                    rowString?.add(rule:RuleMinLength(minLength: UInt(truncating: fRule.intValue!), msg: errMsg))
                case .required:
                    rowString?.add(rule:RuleRequired(msg: "\(field.display) is required!"))
                    rowBool?.onChange
                    { cRow in
                        cRow.value = (cRow.value ?? false) ? true : nil
                    }
                    rowBool?.add(rule: RuleRequired(msg: "\(field.display) is required!"))
                case .valid_date:
                    //no need regex validation for date since iOS picker always handles it
                    break
            }
        }
    }
    
    func toggleRegisterAvailability(rowTag:String, msgName:String,available:Bool?)
    {
        DispatchQueue.main.async {
            if let idRow = self.form.rowBy(tag:rowTag),
               let cell = idRow.baseCell
            {
                if let isValid = available,
                    idRow.validate().count == 0
                {
                    if isValid
                    {
                        print("\(msgName) is available")
                        cell.layer.borderWidth = 3
                        cell.layer.borderColor = UIColor.green.cgColor
                    }else
                    {
                        print("\(msgName) is not available")
                        cell.layer.borderWidth = 3
                        cell.layer.borderColor = UIColor.red.cgColor
                        self.showAlert(title: "ERROR", message: "\(msgName) is not available")
                    }
                }else
                {
                    cell.layer.borderWidth = 0
                    cell.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
    }

    func showAlert(title:String, message:String)
    {
        DispatchQueue.main.async
        {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:nil))
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    func checkEmailAvailability(emailStr:String, emailRowTag:String)
    {
        guard let emailRow = self.form.rowBy(tag:emailRowTag),
            emailRow.validate().count == 0
        else
        {
            return
        }
    
        AuthenticationAPI.authInstance().checkEmailAvailability(emailStr, completionHandler: {
            (response, error) in
            if let data = response,
               let isExist = data["IsExist"] as? Bool
            {
                self.toggleRegisterAvailability(rowTag: emailRowTag, msgName:"email" ,available: !isExist)
            } else {
                print(error?.localizedDescription ?? "unknown error")
            }
        })
    }
    
    func checkUsernameAvailability(usernameStr:String, usernameRowTag:String){
        guard let usernameRow = self.form.rowBy(tag:usernameRowTag),
            usernameRow.validate().count == 0
        else
        {
            return
        }
        
        AuthenticationAPI.authInstance().checkUserNameAvailability(usernameStr,completionHandler: {
            (response, error) in
            if let data = response,
               let isExist = data["IsExist"] as? Bool
            {
                self.toggleRegisterAvailability(rowTag: usernameRowTag,msgName: "username", available: !isExist)
            } else {
                print(error?.localizedDescription ?? "unknown error")
            }
        })
    }
}

extension UINavigationController {    
    func pushViewController(viewController: UIViewController, animated: Bool, completion: @escaping (UINavigationController) -> ()) {
        pushViewController(viewController, animated: animated)

        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion(self)
            }
        } else {
            completion(self)
        }
    }

    func popViewController(animated: Bool, completion: @escaping (UINavigationController) -> ()) {
        popViewController(animated: animated)

        if let coordinator = transitionCoordinator, animated {
            coordinator.animate(alongsideTransition: nil) { _ in
                completion(self)
            }
        } else {
            completion(self)
        }
    }
}
