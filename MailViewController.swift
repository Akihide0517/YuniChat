//
//  MailViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2023/08/09.
//

import Foundation
import UIKit
import MessageUI
import Firebase

class MailViewController: UIViewController, MFMailComposeViewControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        mytruename = String(UserDefaults.standard.string(forKey: "myname")!)
        ref.child("residence/\(mytruename)").setValue("")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
