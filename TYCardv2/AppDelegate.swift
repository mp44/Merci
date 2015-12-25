//
//  AppDelegate.swift
//  TYCardv2
//
//  Created by Andy Wei on 6/30/15.
//  Copyright (c) 2015 Andy Wei. All rights reserved.
//

import UIKit
import AddressBook
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var emailArray = ""
    var window: UIWindow?
    lazy var addressBook: ABAddressBookRef = {
        var error: Unmanaged<CFError>?
        return ABAddressBookCreateWithOptions(nil,
            &error).takeRetainedValue() as ABAddressBookRef
        }()
    func application(application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
            switch ABAddressBookGetAuthorizationStatus(){
            case .Authorized:
                print("Already authorized", terminator: "")
                readAllPeopleInAddressBook(addressBook)
            case .Denied:
                print("You are denied access to address book", terminator: "")
            case .NotDetermined:
                ABAddressBookRequestAccessWithCompletion(addressBook,
                    {[weak self] (granted: Bool, error: CFError!) in
                        if granted{
                            let strongSelf = self!
                            print("Access is granted", terminator: "")
                            strongSelf.readAllPeopleInAddressBook(strongSelf.addressBook)
                        } else {
                            print("Access is not granted", terminator: "")
                        }
                    })
            case .Restricted:
                print("Access is restricted", terminator: "")
            }
            return true
    }
    func readEmailsForPerson(person: ABRecordRef){
    
        let emails: ABMultiValueRef = ABRecordCopyValue(person,
            kABPersonEmailProperty).takeRetainedValue()
        for counter in 0..<ABMultiValueGetCount(emails){
            let email = ABMultiValueCopyValueAtIndex(emails,
                counter).takeRetainedValue() as! String
            //print(email)
            emailArray = emailArray + email + ","
            //print(emailArray)
        }
        
       
    }
    func readAllPeopleInAddressBook(addressBook: ABAddressBookRef){
        /* Get all the people in the address book */
        let allPeople = ABAddressBookCopyArrayOfAllPeople(
            addressBook).takeRetainedValue() as NSArray
        for person: ABRecordRef in allPeople{
           readEmailsForPerson(person)
        }
    }
}