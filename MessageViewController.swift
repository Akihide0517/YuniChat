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
import WebKit
//import SVProgressHUD

class Const {
    static let MessagePath = "messages"
}

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var formWrapperVIew: UIView!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var MTextField: UITextView!
    @IBOutlet weak var kage1: UIView!
    @IBOutlet weak var bulletinwebview: WKWebView!
    
    var messageArray = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // リクエストを生成
        let request = URLRequest(url: URL(string: "http://yoshida0517.html.xdomain.jp/ABC.html")!)
        // リクエストをロードする
        bulletinwebview.load(request)
        
        roomname = "本部"
        kage1.innerShadow()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController!.navigationBar.topItem!.title = ""
        
        //MTextField.layer.cornerRadius = MTextField.frame.height * 0.2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        //self.MTextField.delegate = self
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //self.MTextField.delegate = self
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
        //MTextField.inputAccessoryView = toolbar
        
        //formWrapperVIew.layer.borderWidth = 0.5
        //formWrapperVIew.layer.borderColor = UIColor.black.cgColor
        //goButton.layer.borderWidth = 1
        //goButton.layer.borderColor = UIColor.black.cgColor
        

        //tableView.delegate = self
        //tableView.dataSource = self
        //tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        //SVProgressHUD.show()
        
        if Auth.auth().currentUser != nil {
            let postsRef = Database.database().reference().child(Const.MessagePath)
            postsRef.observe(.childAdded, with: { snapshot in
                //SVProgressHUD.dismiss()
                if let _ = Auth.auth().currentUser?.uid {
                    let dictionary = snapshot.value as! [String: AnyObject]
                    //self.messageArray.insert(dictionary, at: 0)
                    //self.tableView.reloadData()
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
            withIdentifier: "cell",
            for: indexPath as IndexPath)
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.layer.borderColor = UIColor.systemGray2.cgColor
        //cell.textLabel?.layer.borderWidth = 1
        cell.textLabel?.numberOfLines=0
        cell.textLabel?.layer.masksToBounds = true
        //cell.textLabel?.layer.cornerRadius = 10
        //cell.textLabel?.backgroundColor = UIColor.white
        //cell.textLabel?.textColor = UIColor.black
        
        let dictionary = messageArray[indexPath.row] as! [String: AnyObject]

        let time = dictionary["time"] as? String
        let username = dictionary["username"] as! String
        let messages = dictionary["message"] as? String
        
        if(username == ""){
            cell.textLabel?.backgroundColor = UIColor.clear
            cell.textLabel?.text = (username )
            cell.detailTextLabel?.text = (time ?? "") + " : " + (username )
        }else{
            cell.textLabel?.text = "投稿者: " + (username ) + "\n" + (messages ?? "")
            cell.detailTextLabel?.text = (time ?? "") + " : " + (username )
        }
        
        cell.textLabel?.backgroundColor = UIColor.white
        cell.textLabel?.textColor = UIColor.black
        
        if (UITraitCollection.current.userInterfaceStyle != .dark) {
            cell.backgroundColor = .rgb(red: 233, green: 233, blue: 233)
            self.tableView.backgroundColor = .rgb(red: 233, green: 233, blue: 233)
        }
        
        return cell
    }
    
    func makespase(){
        if Auth.auth().currentUser != nil {
            
            if let message = MTextField.text {
                let time = NSDate.timeIntervalSinceReferenceDate
                
                let ref = Database.database().reference().child(Const.MessagePath)
                let data = [
                    "message": "",
                    "time": String(time),
                    "username": "",]
                
                ref.childByAutoId().setValue(data)
            }
        }
    }
    
    @IBAction func pushGoButton(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            
            if let message = MTextField.text {
                let time = NSDate.timeIntervalSinceReferenceDate
                
                let ref = Database.database().reference().child(Const.MessagePath)
                let data = [
                    "message": message,
                    "time": String(time),
                    "username": UserDefaults.standard.object(forKey: "sei") as! String,]
                
                ref.childByAutoId().setValue(data)
                
                //SVProgressHUD.showSuccess(withStatus: "Success!")
                MTextField.text = ""
            }
        }
        
        makespase()
    }
    
    @objc func didTapDoneButton() {
        MTextField.resignFirstResponder()
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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
