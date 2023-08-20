//
//  OpenChatViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/03/13.
//

import Foundation
import UIKit
import FirebaseDatabase

class OpenChatViewController: UIViewController, UITextFieldDelegate {
    
    private var users = [User]()
    private var selectedUser: User?
    
    @IBOutlet weak var numberPadTextField: UITextField!
    @IBOutlet weak var inputViewBottomMargin: UIButton!
    @IBOutlet weak var messageInputView: UITextField!
    @IBOutlet weak var nameInputView: UITextField!
    @IBOutlet weak var ComentView: UIView!
    @IBOutlet weak var textView: UITextView!
    //return時にキーボード閉じる(storyboardベース)
    @IBAction func returnButtonDidTapped(_ sender: Any) {
    }
    
    var databaseRef: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        nameInputView.delegate = self
        messageInputView.delegate = self
        
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
        nameInputView.inputAccessoryView = toolbar
        messageInputView.inputAccessoryView = toolbar

        //右上と左下を角丸にする設定
        ComentView.layer.cornerRadius = 15
        ComentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        databaseRef = Database.database().reference().child("Jouhou-kyuuka")
        databaseRef.observe(.childAdded, with: { snapshot in
            dump(snapshot)
            if let obj = snapshot.value as? [String : AnyObject], let name = obj["name"] as? String, let message = obj["message"] {
                let currentText = self.textView.text
                self.textView.text = (currentText ?? "") + "\n\(name) : \(message)"
                
            }
        })

        NotificationCenter.default.addObserver(self, selector: #selector(OpenChatViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OpenChatViewController.keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @IBAction func tappedSendButton(_ sender: Any) {
        view.endEditing(true)
        
        if let name = nameInputView.text, let message = messageInputView.text {
            let messageData = ["name": name, "message": message]
            databaseRef.childByAutoId().setValue(messageData)
            messageInputView.text = ""
        }
    }
    
    //完了ボタンを押した時の処理
     @objc func didTapDoneButton() {
         messageInputView.resignFirstResponder()
         nameInputView.resignFirstResponder()
     }

    @objc func keyboardWillShow(_ notification: NSNotification){
        if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //inputViewBottomMargin.constant = keyboardFrameInfo.cgRectValue.height
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification){
        //inputViewBottomMargin.constant = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
}
