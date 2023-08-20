//
//  kannrisaretakane.swift
//  calculator
//
//  Created by 吉田成秀 on 2022/11/13.
//

import Foundation
import FirebaseDatabase
import UIKit

class kannrisaretakane: UIViewController {
    @IBOutlet weak var A: UITextView!
    @IBOutlet weak var B: UITextView!
    
    var databaseRef: DatabaseReference!
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("calculator")
        
            databaseRef.observe(.childAdded, with: { snapshot in
                dump(snapshot)
                if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message1 = obj["message1"] {
                    let currentText = self.A.text
                    self.A.text = "\(message1)"
                }
            })

            databaseRef.observe(.childAdded, with: { snapshot in
                dump(snapshot)
                if let obj = snapshot.value as? [String : AnyObject], let name1 = obj["name1"] as? String, let message = obj["message"] {
                    let currentText = self.B.text
                    self.B.text = "\(message)"
                }
            })
    }
}

