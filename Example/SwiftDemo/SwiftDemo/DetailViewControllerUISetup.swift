//
//  DetailViewControllerUISetup.swift
//  SwiftDemo
//
//  Created by LoginRadius Development Team on 2017-05-19.
//  Copyright © 2017 LoginRadius Inc. All rights reserved.
//

import Foundation
import Eureka
import SwiftyJSON

extension DetailViewController
{
    func smallUserProfileUISetup()
    {
        var userEmail="";
        if ((userProfile["Email"].array)) != nil && (userProfile["Email"].array)?.isEmpty == false{
            userEmail = (((userProfile["Email"].array)?[0]["Value"] )?.string)!
        }
       
        
        var userCountry:String? = nil
        if let addrArr = userProfile["Country"].dictionary,
            let countryStr = addrArr["Name"]?.string
        {
            userCountry = countryStr
        }

        let gender = userProfile["Gender"].string ?? "?"
    
        let profileCondition = Condition.function(["User Profile"], { form in
            return !((form.rowBy(tag: "User Profile") as? SwitchRow)?.value ?? false)
        })
        
        form  +++ Section("User Profile API Demo")
        <<< SwitchRow("User Profile")
        {
            $0.title = $0.tag
            $0.value = true
        }
        <<< NameRow("FirstName")
        {
            $0.title = "First Name"
            $0.hidden = profileCondition
            $0.value = userProfile[$0.tag!].stringValue
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        <<< NameRow("LastName")
        {
            $0.title = "Last Name"
            $0.hidden = profileCondition
            $0.value = userProfile[$0.tag!].stringValue
            $0.add(rule: RuleRequired())
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)

        }
        <<< EmailRow("Email")
        {
            $0.title = $0.tag
            $0.hidden = profileCondition
            $0.value = userEmail ?? nil
            $0.disabled = Condition(booleanLiteral: true)
        }
        <<< SegmentedRow<String>("Gender"){
            $0.title = $0.tag
            $0.hidden = profileCondition
            $0.options = ["M","F","?"]
            $0.add(rule: RuleRequired())
            $0.value = gender
        }
        <<< PushRow<String>("Country") {
            $0.title = $0.tag
            $0.hidden = profileCondition
            $0.options = countries
            $0.value = userCountry
            $0.selectorTitle = "Country"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        } 
        <<< TextRow("IsSecurePassword"){
            $0.title = $0.tag
            $0.hidden = profileCondition
            $0.value = (userProfile[$0.tag!].boolValue ? "true" : "false")
            $0.disabled = Condition(booleanLiteral: true)
        }
        <<< ButtonRow("Update Profile")
        {
            $0.title = $0.tag
            $0.hidden = profileCondition
            }.onCellSelection{ cell, row in
                self.validateUserProfileInput()
        }
        +++ Section("up<->vfp")
        {
            $0.header = nil
            $0.hidden = profileCondition
        }
        <<< ButtonRow("View Full Profile")
        {
            $0.title = $0.tag
            $0.hidden = profileCondition
            }.onCellSelection{ cell, row in
                self.showFullProfileController()
        }
    }
    
    func accessTokenUISetup()
    {
        let accessCondition = Condition.function(["Access Token"], { form in
            return !((form.rowBy(tag: "Access Token") as? SwitchRow)?.value ?? false)
        })

        form  +++ Section("Access Token API Demo")
        <<< SwitchRow("Access Token")
        {
            $0.title = $0.tag
            $0.value = false
        }
        <<< AccountRow("Access Token Text")
        {
            $0.title = "Access Token"
            $0.disabled = Condition(booleanLiteral: true)
            $0.hidden = accessCondition
            $0.value = self.accessToken
        }
        <<< ButtonRow("Validate Access Token")
        {
            $0.title = "Validate"
            $0.hidden = accessCondition
            }.onCellSelection{ cell, row in
                self.validateAccessToken()
        }
        <<< ButtonRow("Invalidate Access Token")
        {
            $0.title = "Invalidate"
            $0.hidden = accessCondition
            }.onCellSelection{ cell, row in
                self.invalidateAccessToken()
        }
    }
    
    func customObjectUISetup()
    {
        let objectCondition = Condition.function(["Custom Object"], { form in
            return !((form.rowBy(tag: "Custom Object") as? SwitchRow)?.value ?? false)
        })
    
        let objectCreateCondition = Condition.function(["Custom Object", "Create Custom Obj"], { form in
            let cusObj = (form.rowBy(tag: "Custom Object") as? SwitchRow)?.value ?? false
            let cusObjCr = (form.rowBy(tag: "Create Custom Obj") as? SwitchRow)?.value ?? false
            return !(cusObj && cusObjCr)
        })
        let objectGetCondition = Condition.function(["Custom Object","Get Custom Obj"], { form in
            let cusObj = (form.rowBy(tag: "Custom Object") as? SwitchRow)?.value ?? false
            let cusObjGetUID = (form.rowBy(tag: "Get Custom Obj") as? SwitchRow)?.value ?? false
            return !(cusObj && cusObjGetUID)
        })
        let objectGetWithRecordIdCondition = Condition.function(["Custom Object","Get Custom Obj with RecordId"], { form in
            let cusObj = (form.rowBy(tag: "Custom Object") as? SwitchRow)?.value ?? false
            let cusObjGetR = (form.rowBy(tag: "Get Custom Obj with RecordId") as? SwitchRow)?.value ?? false
            return !(cusObj && cusObjGetR)
        })
        let objectPutCondition = Condition.function(["Custom Object","Put Custom Obj"], { form in
            let cusObj = (form.rowBy(tag: "Custom Object") as? SwitchRow)?.value ?? false
            let cusObjPut = (form.rowBy(tag: "Put Custom Obj") as? SwitchRow)?.value ?? false
            return !(cusObj && cusObjPut)
        })
        let objectDelCondition = Condition.function(["Custom Object","Delete Custom Obj"], { form in
            let cusObj = (form.rowBy(tag: "Custom Object") as? SwitchRow)?.value ?? false
            let cusObjDel = (form.rowBy(tag: "Delete Custom Obj") as? SwitchRow)?.value ?? false
            return !(cusObj && cusObjDel)
        })
        
        form  +++ Section("Custom Object API Demo")
        <<< SwitchRow("Custom Object")
        {
            $0.title = $0.tag
            $0.value = false
        }
        <<< SwitchRow("Create Custom Obj")
        {
            $0.title = $0.tag
            $0.hidden = objectCondition
        }
        <<< AccountRow("CrCO Object Name")
        {
            $0.title = "Object Name"
            $0.hidden = objectCreateCondition
            $0.placeholder = "See LR dashboard for obj name"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        <<< LabelRow("CrCO DataLabel")
        {
            $0.title = "Payload Data"
            $0.hidden = objectCreateCondition
        }
        <<< AccountRow("CrCO Data")
        {
            $0.title = "Data"
            $0.placeholder = "{\"customdata1\": \"my customdata1\"}"
            $0.hidden = objectCreateCondition
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        <<< ButtonRow("CrCO Send")
        {
            $0.title = "Create Custom Object"
            $0.hidden = objectCreateCondition
        }.onCellSelection{cell, row in
            self.createCustomObject()
        }
        
        <<< SwitchRow("Get Custom Obj")
        {
            $0.title = $0.tag
            $0.hidden = objectCondition
        }
        
        <<< AccountRow("GetCO Object Name")
        {
            $0.title = "Object Name"
            $0.hidden = objectGetCondition
            $0.placeholder = "See LR dashboard for obj name"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        
        <<< ButtonRow("GetCO Send")
        {
            $0.title = "Get Custom Object"
            $0.hidden = objectGetCondition
        }.onCellSelection{cell, row in
            self.getCustomObject()
        }
        
        <<< SwitchRow("Get Custom Obj with RecordId")
        {
            $0.title = $0.tag
            $0.hidden = objectCondition
        }
        
        <<< AccountRow("GetCO RecordId with RecordId")
        {
            $0.title = "Record Id"
            $0.hidden = objectGetWithRecordIdCondition
            $0.placeholder = "Record Id"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        
        <<< AccountRow("GetCO Object Name with RecordId")
        {
            $0.title = "Object Name"
            $0.hidden = objectGetWithRecordIdCondition
            $0.placeholder = "See LR dashboard for obj name"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        
        <<< ButtonRow("GetCO Send with RecordId")
        {
            $0.title = "Get Custom Object with RecordId"
            $0.hidden = objectGetWithRecordIdCondition
        }.onCellSelection{cell, row in
            self.getCustomObjectWithRecordId()
        }

        <<< SwitchRow("Put Custom Obj")
        {
            $0.title = $0.tag
            $0.hidden = objectCondition
        }.onCellSelection{cell, row in
            self.getCustomObjectWithRecordId()
        }
        <<< AccountRow("PutCO RecordId")
        {
            $0.title = "Record Id"
            $0.hidden = objectPutCondition
            $0.placeholder = "Record Id"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        
        <<< AccountRow("PutCO Object Name")
        {
            $0.title = "Object Name"
            $0.hidden = objectPutCondition
            $0.placeholder = "See LR dashboard for obj name"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        <<< LabelRow("PutCO DataLabel")
        {
            $0.title = "Payload Data"
            $0.hidden = objectPutCondition
        }
        <<< AccountRow("PutCO Data")
        {
            $0.title = "Data"
            $0.placeholder = "{\"customdata1\": \"my customdata1\"}"
            $0.hidden = objectPutCondition
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        <<< ButtonRow("PutCO Send")
        {
            $0.title = "Put Custom Object"
            $0.hidden = objectPutCondition
        }.onCellSelection{cell, row in
            self.putCustomObject()
        }
        
        <<< SwitchRow("Delete Custom Obj")
        {
            $0.title = $0.tag
            $0.hidden = objectCondition
        }
        <<< AccountRow("DelCO RecordId")
        {
            $0.title = "Record Id"
            $0.hidden = objectDelCondition
            $0.placeholder = "Record Id"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        
        <<< AccountRow("DelCO Object Name")
        {
            $0.title = "Object Name"
            $0.hidden = objectDelCondition
            $0.placeholder = "See LR dashboard for obj name"
            $0.add(rule: RuleRequired())
            $0.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                self.toggleRedBorderShowErrorMessage(cell: cell, row: row)
        }
        <<< ButtonRow("DelCO Send")
        {
            $0.title = "Delete Custom Object"
            $0.hidden = objectDelCondition
        }.onCellSelection{cell, row in
            self.delCustomObject()
        }
    }
    
    
    
}
