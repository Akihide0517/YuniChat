//
//  SumController.swift
//  calculator
//
//  Created by 吉田成秀 on 2022/11/13.
//

import UIKit
import FirebaseDatabase

class SumController: UIViewController {
    @IBOutlet weak var yentext: UITextView!
    @IBOutlet weak var becose: UITextView!
    @IBOutlet weak var mainus: UIButton!
    @IBOutlet weak var pulus: UIButton!
    
    @IBOutlet weak var nowmoney: UITextView!
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    var mode = 0
    var yen = 100
    var Sresoult = ""
    var now = ""
    var testmode = 0
    var resoult: Int? = 0
    
    var databaseRef: DatabaseReference!
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("calculator/\(self.delegate.nameValue!)")
        
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
        yentext.inputAccessoryView = toolbar
        becose.inputAccessoryView = toolbar
        becose.layer.cornerRadius = 10
        //キーボードタイプを番号のみに指定
        yentext.keyboardType = .numberPad
        
            databaseRef.observe(.childAdded, with: { snapshot in
                dump(snapshot)
                if let obj = snapshot.value as? [String : AnyObject], let room = obj[self.delegate.nameValue!] as? String, let roomnamemessage = obj[self.delegate.nameValue! + "message"] {
                    let currentText = self.nowmoney.text
                    self.nowmoney.text = "\(roomnamemessage)"
                }
            })
    }

@IBAction func tappedSendButton(_ sender: Any) {

}

    //完了ボタンを押した時の処理
    @objc func didTapDoneButton() {
        yentext.resignFirstResponder()
        becose.resignFirstResponder()
    }
        
    @IBAction func null(_ sender: Any) {
        testmode = 1
        becose.text = "testmode!"
    }
    @IBAction func pulus(_ sender: Any) {
        mode = 0
        becose.text = String(UserDefaults.standard.string(forKey: "myname")!)+"が（目的）のために予算を増額。"
    }
    @IBAction func mainus(_ sender: Any) {
        mode = 1
        becose.text = String(UserDefaults.standard.string(forKey: "myname")!)+"が（目的）のために予算を減額。"
    }
    @IBAction func succes(_ sender: Any) {
        let Key = "calculator"+String(delegate.nameValue!)
        now = String(nowmoney.text)
        var Lnow: Int? = Int(now)
        
        if(UserDefaults.standard.string(forKey: Key)==nil){
            UserDefaults.standard.set("1", forKey: Key)
            
            Sresoult = String(yentext.text)
            var Nresoult: Int? = Int(Sresoult)
            resoult = Int(Nresoult!)
            print(resoult)
            print("calculator\(self.delegate.nameValue!)reset")
            
            if let room = becose.text, let roomnamemessage: String? = String(resoult!) {
                let messageData = [self.delegate.nameValue!: room, self.delegate.nameValue! + "message": roomnamemessage]
                databaseRef.childByAutoId().setValue(messageData)
            }
        }
        
        if(Lnow==nil){
            Lnow = 0
        }
        if(mode == 0){
            Sresoult = String(yentext.text)
            var Nresoult: Int? = Int(Sresoult)
            resoult = Int(Lnow!) + Int(Nresoult!)
            print(resoult)
        }else{
            Sresoult = String(yentext.text)
            now = String(nowmoney.text)
            var Nresoult: Int? = Int(Sresoult)
            resoult = Int(Lnow!) - Int(Nresoult!)
            print(resoult)
        }
        
        view.endEditing(true)
            if let room = becose.text, let roomnamemessage: String? = String(resoult!) {
                let messageData = [self.delegate.nameValue!: room, self.delegate.nameValue! + "message": roomnamemessage]
                databaseRef.childByAutoId().setValue(messageData)
                
                yentext.text = ""
            }
    }
}
