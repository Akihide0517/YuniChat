//
//  profileview.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/23.
//
import UIKit
import Firebase
import FirebaseFirestore

class profileview: UIViewController {
    
    @IBOutlet weak var filterview: UIView!
    @IBOutlet weak var newtesttext: UITextView!
    @IBOutlet weak var newimage: UIImageView!
    @IBOutlet weak var newnamelabel: UILabel!
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newnamelabel.text = enemyname
        newimage.image = enemyimage
        newimage.layer.cornerRadius = 80
        if (UITraitCollection.current.userInterfaceStyle == .dark) {
            filterview.isHidden = false
        } else {
            filterview.isHidden = true
        }
        
        databaseRef = Database.database().reference().child("profile").child(enemyname)
        databaseRef.observe(.childAdded, with: { snapshot in
            if let obj = snapshot.value as? [String : AnyObject], let message = obj["message"] {
                let currentText = self.newtesttext.text
                self.newtesttext.text = "\(message)"
            }
        })
        
        UserDefaults.standard.set(newimage.image!.pngData(), forKey: newnamelabel.text!)
    }
}
