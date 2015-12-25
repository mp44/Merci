//
//  ViewController.swift
//  TYCardv2
//
//  Created by Andy Wei on 6/30/15.
//  Copyright (c) 2015 Andy Wei. All rights reserved.
//

import UIKit
import MessageUI
import AddressBook

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //Initialize Outlets for Subject, Recipient Email, Message Body, and Autocomplete for Recipient Email

    @IBOutlet weak var RecEmail: UITextField!

    @IBOutlet weak var RecSub: UITextField!

    @IBOutlet weak var autocompleteTableView: UITableView!

    @IBOutlet weak var Body: UITextView!
    
    //Unwind segue to preserve user inputs when returning to first view
    @IBAction func back1(segue: UIStoryboardSegue) {
        //println("unwind")
        if let mcv = segue.sourceViewController as? MyCollectionViewController
        {
            self.Body.text = mcv.emailText1
            self.RecSub.text = mcv.subjeText1
            self.RecEmail.text = mcv.RecEmailText1
        }
    }
    //Initialize array of emails received from contact list
    var emailArray = ""
    var emailNSArray = [""]
    var autocomplete = [String]()
    var addressBook: ABAddressBookRef?

    //If View Controller did load, set up autocomplete and message body text view
    override func viewDidLoad() {
        super.viewDidLoad()
        //email
        RecEmail.delegate = self
        //autocomplete
        autocompleteTableView!.delegate = self
        autocompleteTableView!.dataSource = self
        autocompleteTableView!.scrollEnabled = true
        autocompleteTableView!.hidden = true
        //message body
        Body.delegate = self
        self.Body.layer.borderColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0).CGColor
        Body.layer.borderWidth = 0.6
        Body.layer.cornerRadius = 6
        Body.text = "Write Something!"
        Body.font = UIFont(name: "Helvetica", size: 14)
        Body.textColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        
        /*let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissTableView")
        view.addGestureRecognizer(tap)*/
    }
    
    //Calls this function when the tap is recognized.
    /*func dismissTableView() {
        autocompleteTableView!.hidden = true
    }*/
    
    //If began editing message body, change text color to black and hide placeholer
    func textViewDidBeginEditing(Body: UITextView) {
        if Body.textColor == UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0) {
            Body.text = ""
            Body.textColor = UIColor.blackColor()
        }
    }
    
    //If started over, set text color back to default grey and show placeholder
    func textViewDidEndEditing(Body: UITextView) {
        if Body.text.isEmpty {
            Body.text = "Write Something!"
            Body.textColor = UIColor(red: 215.0/255.0, green: 215.0/255.0, blue: 215.0/255.0, alpha: 1.0)
        }
    }
    
    //Receive data from Address Book
    func createAddressBook(){
        var error: Unmanaged<CFError>?
        addressBook = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
    }
    
    //Set up autocomplete for Recipient Email
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
    {
        autocompleteTableView!.hidden = false
        let substring = (self.RecEmail.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        searchAutocompleteEntriesWithSubstring(substring)
        self.dismissViewControllerAnimated(true, completion: {})
        return true
    }
    
    //Set up autocomplete for Recipient Email
    func searchAutocompleteEntriesWithSubstring(substring: String)
    {
        autocomplete.removeAll(keepCapacity: false)
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let emailArray = delegate.emailArray
        let emailNSArray = emailArray.componentsSeparatedByString(",")
        
        print(emailNSArray)
        
        //var emailNSArray = ["ajwei@scu.edu", "ajwei@gmail.com", "ajwei@yahoo.com"]
        for curString in emailNSArray
        {
            //println(curString)
            let myString: NSString! = curString as NSString
            let substringRange: NSRange! = myString.rangeOfString(substring)
            if (substringRange.location == 0)
            {
                autocomplete.append(curString)
            }
        }
        
        autocompleteTableView!.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //Set number of sections in autocomplete
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autocomplete.count
    }
    
    
    //Set each cell in autocomplete table
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let autoCompleteRowIdentifier = "AutoCompleteRowIdentifier"
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(autoCompleteRowIdentifier, forIndexPath: indexPath) as UITableViewCell
        let index = indexPath.row as Int
        cell.textLabel!.text = autocomplete[index]
        return cell
    }
    
    //Hide autocomplete after selection
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell : UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        self.dismissViewControllerAnimated(true, completion: nil)
        autocompleteTableView!.hidden = true
        RecEmail.text = selectedCell.textLabel!.text
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        autocompleteTableView!.hidden = true
        return false
    }

    //Segue Recipient Email, Subject, and Message Body to next View Controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestV2 : MyCollectionViewController = segue.destinationViewController as! MyCollectionViewController
        DestV2.emailText1 = Body.text
        DestV2.subjeText1 = RecSub.text!
        DestV2.RecEmailText1 = RecEmail.text!
    }
}

    



