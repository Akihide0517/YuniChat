//
//  kane.swift
//  calculator
//
//  Created by 吉田成秀 on 2022/11/13.
//

import Foundation
import FirebaseDatabase
import UIKit

class kane: UIViewController {
    @IBOutlet weak var money: UITextView!
    
    
    var databaseRef: DatabaseReference!
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("calculator/\(self.delegate.nameValue!)")
        
            databaseRef.observe(.childAdded, with: { snapshot in
                dump(snapshot)
                if let obj = snapshot.value as? [String : AnyObject], let room = obj[self.delegate.nameValue!] as? String, let roomnamemessage = obj[self.delegate.nameValue! + "message"] {
                    let currentText = self.money.text
                    self.money.text = "\(roomnamemessage)"
                }
            })
    }
}
