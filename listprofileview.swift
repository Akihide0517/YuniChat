//
//  listprofileview.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/23.
//

import UIKit
import Firebase
import FirebaseFirestore

class listprofileview: UIViewController {
    
    @IBOutlet weak var darkfilterview: UIView!
    @IBOutlet weak var listtesttext: UITextView!
    @IBOutlet weak var listimage: UIImageView!
    @IBOutlet weak var listnamelabel: UILabel!
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listnamelabel.text = enemyname
        listimage.image = enemyimage
        listimage.layer.cornerRadius = 80
        if (UITraitCollection.current.userInterfaceStyle == .dark) {
            darkfilterview.isHidden = false
        } else {
            darkfilterview.isHidden = true
        }
        
        databaseRef = Database.database().reference().child("profile").child(enemyname)
        databaseRef.observe(.childAdded, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject], let message = obj["message"] {
                let currentText = self.listtesttext.text
                self.listtesttext.text = "\(message)"
            }
        })
    }
}
