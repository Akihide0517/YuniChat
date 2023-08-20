//
//  CEOController.swift
//  calculator
//
//  Created by 吉田成秀 on 2022/11/13.
//

import UIKit
import FirebaseDatabase

class CEOController: UIViewController {
    @IBOutlet weak var change: UITextView!
    @IBOutlet weak var key: UITextView!
    @IBOutlet weak var cose: UITextView!
    
    var yen = 100
    var Sresoult = ""
    var now = ""
    var mode = 0
    var resoult: Int? = 0
    
    var databaseRef: DatabaseReference!
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("calculator")
        
        //inputAccesoryViewに入れるtoolbar
        let toolbar = UIToolbar()
        //完了ボタンを右寄せにする為に、左側を埋めるスペース作成
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        //完了ボタンを作成
        let done = UIBarButtonItem(title: "完了",
                                   style: .done,
                                   target: self,
                                   action: #selector(didTapDoneButton))
        //toolbarのitemsに作成したスペースと完了ボタンを入れる。実際にも左から順に表示されます。
        toolbar.items = [space, done]
        toolbar.sizeToFit()
        //作成したtoolbarをtextFieldのinputAccessoryViewに入れる
        change.inputAccessoryView = toolbar
        cose.inputAccessoryView = toolbar
        key.inputAccessoryView = toolbar
        //キーボードタイプを番号のみに指定
        change.keyboardType = .numberPad
        key.keyboardType = .numberPad
        
        if(delegate.nameValue == "1234"){
            databaseRef.observe(.childAdded, with: { snapshot in
                dump(snapshot)
                if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message1 = obj["message1"] {
                }
            })
        }
        if(delegate.nameValue == "5678"){
            databaseRef.observe(.childAdded, with: { snapshot in
                dump(snapshot)
                if let obj = snapshot.value as? [String : AnyObject], let name1 = obj["name1"] as? String, let message = obj["message"] {
                }
            })
        }
    }

@IBAction func sent(_ sender: Any) {
    view.endEditing(true)

    if(key.text == "1234"){
        if let name = cose.text, let message1 = change.text {
            let messageData = ["name": name, "message1": message1]
            databaseRef.childByAutoId().setValue(messageData)

        }
    }
    if(key.text == "5678"){
        if let name1 = cose.text, let message = change.text {
            let messageData = ["name1": name1, "message": message]
            databaseRef.childByAutoId().setValue(messageData)

        }
    }
}
    //完了ボタンを押した時の処理
    @objc func didTapDoneButton() {
        change.resignFirstResponder()
        cose.resignFirstResponder()
        key.resignFirstResponder()
    }
}
