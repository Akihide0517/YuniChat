//
//  ClubMoneyViewcotroller.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/03/25.
//

import Foundation
import UIKit
import Firebase

class ClubMoneyViewcotroller: UIViewController {

    @IBOutlet weak var moneyView: UITextField!
    @IBOutlet weak var textView2: UITextView!
    @IBOutlet weak var nameTextField2: UITextField!
    @IBOutlet weak var messageTextField2: UITextField!

    var nums: [Int] = []
    enum textFieldKind:Int {
        case name = 1
        case message = 2
    }

    var defaultstore:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        moneyView.text = ""
        self.loadView()
        
        //MARK: pass
                var uiTextField = UITextField()
                let ac = UIAlertController(title: "開始するには合言葉が必要です", message: "", preferredStyle: .alert)
                let aa = UIAlertAction(title: "OK", style: .default) { (action) in
                    print(uiTextField.text!)
                    if uiTextField.text != "empire"{
                        print("return")
                        //self.loadView()
                        self.viewDidLoad()
                        return
                    }else{return}
            }
                ac.addTextField { (textField) in
                        textField.placeholder = "パスワード"
                        uiTextField = textField
                    }
                    ac.addAction(aa)
                    present(ac, animated: true, completion: nil)
        //MARK: passEnd
    
        messageTextField2.delegate = self
        nameTextField2.delegate = self
        //Firestoreへのコネクションを張る
        defaultstore = Firestore.firestore()


        //Firestoreからデータを取得し、TextViewに表示する
        defaultstore.collection("clubchatM").addSnapshotListener { (snapShot, error) in
            guard let value = snapShot else {
                print("snapShot is nil")
                return
            }

            value.documentChanges.forEach{diff in
            //更新内容が追加だったときの処理
                if diff.type == .added {
                    //追加データを変数に入れる
                    let chatDataOp = diff.document.data() as? Dictionary<String, String>
                    print(diff.document.data())
                    guard let chatData = chatDataOp else {
                        return
                    }
                    guard let message = chatData["message"] else {
                        return
                    }
                    guard let name = chatData["name"] else {
                        return
                    }
                    guard let posts = chatData["message"] as? Dictionary<String, Dictionary<String, AnyObject>> else {
                                    return
                                }
                    let nums = chatData["message"].flatMap { Int($0) }
                        print(nums as Any)//optional(1)
                    
                    let ChatData = chatData.sorted { $0.0 < $1.0 } .map { $0 }
                    for (nums) in chatData {
                        self.textView2.text =  "\(self.textView2.text!)\n\(name) : \(nums)"
                        print("key:\(nums)\n ")
                    }
                    
                    // keyとdateが入ったタプルを作る
                    var keyValueArray: [(String, Int)] = []
                    for (key, value) in posts {
                        keyValueArray.append((key: key, date: value["date"] as! Int))
                    }
                    keyValueArray.sort{$0.1 < $1.1}             // タプルの中のdate でソートしてタプルの順番を揃える(配列で) これでkeyが順番通りになる
                    self.textView2.text =  "\(self.textView2.text!)\n\(name) : \(message)"
                    // messagesを再構成
                    //var preMessages = [JSQMessage]()
                    for sortedTuple in keyValueArray {
                        for (key, value) in posts {
                            if key == sortedTuple.0 {           // 揃えた順番通りにメッセージを作成
                                self.textView2.text =  "\(self.textView2.text!)\n\(name) : \(message)"
                                //let senderId = value["senderId"] as! String!
                                //let text = value["text"] as! String!
                                //let displayName = value["displayName"] as! String!
                                //preMessages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                            }
                        }
                    }
                    
                    
                        self.textView2.text =  "\(self.textView2.text!)\n\(name) : \(message)"
                        
                        self.moneyView.text = "\(name)yen "
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    @IBAction func sent(_ sender: Any) {
        //未実装
        moneyView.text = ""
        self.loadView()
        
    }
}

extension ClubMoneyViewcotroller:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("returnが押されたよ")

        //キーボードを閉じる
        textField.resignFirstResponder()

        //nameTextFieldの場合は　returnを押してもFirestoreへ行く処理をしない
        if textField.tag == textFieldKind.name.rawValue {
            return true
        }
        //nameに入力されたテキストを変数に入れる。nilの場合はFirestoreへ行く処理をしない
        guard let name = nameTextField2.text else {
            return true
        }

        //nameが空欄の場合はFirestoreへ行く処理をしない
        if nameTextField2.text == "" {
            return true
        }

        //messageに入力されたテキストを変数に入れる。nilの場合はFirestoreへ行く処理をしない
        guard let message = messageTextField2.text else {
            return true
        }

        //messageが空欄の場合はFirestoreへ行く処理をしない
        if messageTextField2.text == "" {
            return true
        }

        //入力された値を配列に入れる
        let messageData: [String: String] = [ "name":name, "message":message]

        //Firestoreに送信する
        defaultstore.collection("clubchatM").addDocument(data: messageData)

        //メッセージの中身を空にする
        messageTextField2.text = ""
        moneyView.text = ""

        return true
    }
}
