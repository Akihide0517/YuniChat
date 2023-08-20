//
//  comentview.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class comentview: UIViewController {
    
    @IBOutlet weak var successbutton: UIButton!
    @IBOutlet weak var myeditcomment: UITextView!
    @IBOutlet weak var mycomment: UITextView!
    
    var databaseRef: DatabaseReference!
    
    @IBAction func successbutton(_ sender: Any) {
        if let message = myeditcomment.text {
            let messageData = ["message": message]
            databaseRef.childByAutoId().setValue(messageData)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myeditcomment.layer.cornerRadius = 10
        mycomment.layer.cornerRadius = 10
        
        databaseRef = Database.database().reference().child("profile").child(mytruename)
        databaseRef.observe(.childAdded, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject], let message = obj["message"] {
                let currentText = self.mycomment.text
                self.mycomment.text = "\(message)"
            }
        })
    }
}
