//
//  ViewController2.swift
//  TYCardv2
//
//  Created by Andy Wei on 7/9/15.
//  Copyright (c) 2015 Andy Wei. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ViewController2: UIViewController, MFMailComposeViewControllerDelegate {
    
  
    //Initialize Outlet for overlayed image
    
    @IBOutlet var tycardView: UIImageView!
    //Action to dismiss view controller
    @IBAction func back2(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    //Receive segue data from previous view controller
    var tycard2 = UIImage()
    var emailText = String()
    var subjeText = String()
    var RecEmailText = String()
    
    //If view did load, set preview as overlayed card image
    override func viewDidLoad() {
        tycardView.image = tycard2
    }
    
    //Display mail status
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    //Send mail function
    @IBAction func sendMail(sender: AnyObject) {

        let RecEmailTxt = [RecEmailText]
        
        //let RecEmailTextArray = [Array(arrayLiteral: RecEmailTxt)]
        
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        
        mc.mailComposeDelegate = self
        
        mc.setToRecipients(RecEmailTxt)
        
        mc.setSubject(subjeText)
        
        //mc.setMessageBody(MessageBody, isHTML: false) //fonts, etc with html
        let imageData = UIImagePNGRepresentation(tycard2)
        mc.addAttachmentData(imageData!, mimeType: "image/png", fileName: "Thank You Card")
        
        presentViewController(mc, animated: true, completion: nil)
    }
    
    
    //Show mail final status
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
        switch result.rawValue {
            
        case MFMailComposeResultCancelled.rawValue:
            print("Mail Cancelled", terminator: "")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed: %@", [error!.localizedDescription], terminator: "")
        case MFMailComposeResultSaved.rawValue:
            print("Mail Saved", terminator: "")
        case MFMailComposeResultSent.rawValue:
            print("Mail Sent", terminator: "")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}