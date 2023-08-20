//
//  MessageViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
//import SVProgressHUD

class Const2 {
    static let MessagePath = "AbsenceMessage"
}

class AbsenceMessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formWrapperVIew: UIView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    
    var messageArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.messageTextField.delegate = self
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.messageTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)


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
        messageTextField.inputAccessoryView = toolbar
        
        //formWrapperVIew.layer.borderWidth = 0.5
        //formWrapperVIew.layer.borderColor = UIColor.black.cgColor
        //goButton.layer.borderWidth = 1
        //goButton.layer.borderColor = UIColor.black.cgColor
        

        tableView.delegate = self
        tableView.dataSource = self
        tableView.dequeueReusableCell(withIdentifier: "Cell2")
        
        //SVProgressHUD.show()
        
        if Auth.auth().currentUser != nil {
            let postsRef = Database.database().reference().child(Const2.MessagePath).child(roomname)
            postsRef.observe(.childAdded, with: { snapshot in
                //SVProgressHUD.dismiss()
                if let _ = Auth.auth().currentUser?.uid {
                    let dictionary = snapshot.value as! [String: AnyObject]
                    self.messageArray.insert(dictionary, at: 0)
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell (
            withIdentifier: "Cell2",
            for: indexPath as IndexPath)
        cell.textLabel?.numberOfLines=0
        let dictionary = messageArray[indexPath.row] as! [String: AnyObject]

        let time = dictionary["time"] as? String
        let username = dictionary["username"] as! String
        let messages = dictionary["message"] as? String
        
        cell.textLabel?.text = (username ?? "") + "  " + (time ?? "") + "\n" + (messages ?? "") + "\n"
        cell.detailTextLabel?.text = (time ?? "") + " : " + (username ?? "")
        
        return cell
    }
    
    @IBAction func pushGoButton(_ sender: Any) {
        if let currentUser = Auth.auth().currentUser {
            
            if let message = messageTextField.text {
                let time = NSDate.timeIntervalSinceReferenceDate
                
                let ref = Database.database().reference().child(Const2.MessagePath).child(roomname)
                let data = [
                    "message": message,
                    "time": String(time),
                    "username": UserDefaults.standard.object(forKey: "sei") as! String,]
                
                ref.childByAutoId().setValue(data)
                
                //SVProgressHUD.showSuccess(withStatus: "Success!")
                messageTextField.text = ""
            }
        }
    }
    
    @objc func didTapDoneButton() {
        messageTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                } else {
                    let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                    self.view.frame.origin.y -= suggestionHeight
                }
            }
        }
    
    @objc func keyboardWillHide() {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
}
