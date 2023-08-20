//
//  FeedBackLoginController.swift
//  newChat
//
//  Created by 吉田成秀 on 2023/08/09.
//

import Foundation
import UIKit
import Firebase
import PKHUD

class FeedBackLoginController: UIViewController, UITextFieldDelegate{
    
    var userDefaults = UserDefaults.standard
    
    @IBOutlet weak var HideView: UIView!
    @IBOutlet weak var Loginbutton: UIButton!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var mail: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pass.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        pass.resignFirstResponder()
        pass.text = textField.text
        
        if(pass.text?.isEmpty == false && mail.text?.isEmpty == false){
            if(mail.text! == UserDefaults.standard.object(forKey: "ki-") as! String && pass.text! == UserDefaults.standard.object(forKey: "pass") as! String){
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                mytruename = String(UserDefaults.standard.string(forKey: "myname")!)
                ref.child("residence/\(mytruename)").setValue("")
                HideView.isHidden = true
                
                Auth.auth().currentUser?.delete() { [weak self] error in
                    guard let self = self else { return }
                    if error != nil {
                        // 非ログイン時の画面へ
                    }
                    print("err")
                }
            }else{
                HideView.isHidden = false
            }
        }
        
        return true
    }
    
    @IBAction func Login(_ sender: Any) {
        
    }
}
