//
//  ChatRoomViewController.swift
//  ChatAppWithFirebase
//
//  Created by Uske on 2020/03/18.
//  Copyright © 2020 Uske. All rights reserved.
//
//グローバル関数でnameを指定し、変数の受け渡しを行う
import UIKit
import Firebase
import UserNotifications
import PKHUD
import FirebaseMessaging
import FirebaseDatabase

class ChatRoomViewController: UIViewController, CatchProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    //var globalVariable: Int?
    var globalVariableAns: Int = 1
    var user: User?
    var chatroom: ChatRoom?
    
    @IBOutlet weak var kage0: UIView!
    @IBOutlet weak var sview: UIView!
    @IBOutlet weak var StampView: UIView!
    private let cellId = "cellId"
    private var usertoken = ""
    private let mode = false
    private var messages = [Message]()
    private let accessoryHeight: CGFloat = 100
    private let tableViewContentInset: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
    private let tableViewIndicatorInset: UIEdgeInsets = .init(top: 60, left: 0, bottom: 0, right: 0)
    
    private var safeAreaBottom: CGFloat {
        self.view.safeAreaInsets.bottom
    } //self.titleTableViewDelegate.updateTableView()
    
    // FCMメッセージを作成します
    let message: [String: Any] = [
        "notification": [
            "title": "\(myname)",
            "body": "新しいメッセージが来ています"
        ],
        "token": yourtoken
    ]
    
    // FCMメッセージを送信します
    func sendFCMNotification(to token: String, title: String, body: String) {
        // プッシュ通知の内容を設定
        let body: [String: Any] = [
            "to": token,
            "notification": [
                "title": title,
                "body": body
            ]
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: body)

        // Firebase Cloud Messagingにリクエストを送信
        let urlString = "https://fcm.googleapis.com/fcm/send"
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "Authorization") // Firebaseコンソールから取得したサーバーキーを設定
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error sending push notification: \(error)")
            } else if let data = data, let response = response as? HTTPURLResponse {
                print("Push notification sent with status code: \(response.statusCode)")
            }
        }
        task.resume()
    }
    
    //デバック機能
    @IBAction func reset(_ sender: Any) {
        if(mode == true){
            do {
                try Auth.auth().signOut()
                pushLoginViewController()
            } catch {
                print("ログアウトに失敗しました。 \(error)")
            }
        }
        print(self.usertoken)
        print(key)
        let deviceToken = self.usertoken
        let notificationTitle = "Test Notification"
        let notificationBody = "This is a test notification"
        //sendFCMNotification(to: deviceToken, title: notificationTitle, body: notificationBody)
    }
    
    private func pushLoginViewController() {
        let storyboar = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboar.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)//MARK: here!
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    private lazy var chatInputAccessoryView: ChatInputAccessoryView = {
        let view = ChatInputAccessoryView()
        view.frame = .init(x: 0, y: 0, width: view.frame.width, height: accessoryHeight)
        view.delegate = self
        return view
    }()
    
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nowload = 1
        nowview = 1
        isChat = 1
        StampView.isHidden = true
        sview.isHidden = true
        kage0.innerShadow()
        
        navigationItem.title = testenemyname
        testenemyname = ""
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatRoomTableViewCell")
        
        DispatchQueue.main.async {
          // チャットが開かれたらバッジを全部消す
          UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        setupNotification()
        setupChatRoomTableView()
        fetchMessages()
        // 受信先の登録（"reload"という名前の通知を受け取ると、reloadCollectionView()を呼び出す）
            NotificationCenter.default.addObserver(self, selector: #selector(reloadCollectionView(notification:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadCollectionView(notification:)), name: NSNotification.Name(rawValue: "load"), object: nil)
          
        var ref: DatabaseReference!
        ref = Database.database().reference()
        
        mytruename = String(UserDefaults.standard.string(forKey: "myname")!)
        print("residence/\(mytruename)" + " sender:" + navigationItem.title!)
        ref.child("residence/\(mytruename)").setValue(yourtoken)
        
        ref.child("residence/\(navigationItem.title!)").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.usertoken = snapshot.value as? String ?? "Unknown";
            print(self.usertoken)
        });
        
        sender = navigationItem.title!
    }
    
    // コレクションビューの更新（通知された時に呼ばれるメソッド）
    @objc func reloadCollectionView(notification: NSNotification) {
        self.StampView.isHidden = false
    }
    @objc func loadCollectionView(notification: NSNotification) {
        self.StampView.isHidden = true
        sview.isHidden = true
    }
    
    func viewhide(){
        modeing = 0
        self.StampView.isHidden = true
        self.sview.isHidden = true
        tappedSendButton(text: copyurl)
    }
    
    @IBAction func photosent(_ sender: Any) {
        modeing = 0
        self.StampView.isHidden = true
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    @IBAction func stampsent(_ sender: Any) {
        sview.isHidden = false
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let date = Date()
        let df = DateFormatter()
        
        df.dateFormat = "yMdkHms"
        print(df.string(from: date))
        // 2017/1/1 12:39:22
        
        //初期格納データ
        let image = UIImage(named: "見出しを追加2")!
        var data = image.jpegData(compressionQuality: 1)! as NSData
        let storageref = Storage.storage().reference(forURL: "gs://chat-12dd0.appspot.com").child("Image" + df.string(from: date) + ".jpg")
        var iimage = UIImage(named: "見出しを追加2")!
        
        //画像
        if let image = info[.originalImage]
            as? UIImage {
            // 画像選択時の処理
            // ↓選んだ画像を取得
            data = image.jpegData(compressionQuality: 1)! as NSData
            iimage = image
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        }
        //Storageに保存
        HUD.show(.progress)
        self.dismiss(animated: true, completion: nil)
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("Image" + df.string(from: date) + ".jpg")
        let uploadImage = iimage.jpegData(compressionQuality: 1.0)! as NSData
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        ref.putData(uploadImage as Data, metadata: metadata) { _, error in
            if (error != nil) {
                print("upload error!")
            } else {
                HUD.hide()
                print("upload successful!")
                var urlname = "yunichatM:Image" + df.string(from: date) + ".jpg"
                copyurl = urlname
                self.viewhide()
            }
        }
    }
    
    func catchData(id : Int) {
        if id == 0 {
            print("dfghjk")
            let baseVC = self
            let storyboard = UIStoryboard(name: "ChatRoom", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "imageview")
            let next = vc
            DispatchQueue.main.async {
                //next.modalPresentationStyle = .fullScreen
                baseVC.present(next,animated: true)
            }
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupChatRoomTableView() {
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        chatRoomTableView.register(UINib(nibName: "ChatRoomTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        chatRoomTableView.contentInset = tableViewContentInset
        chatRoomTableView.scrollIndicatorInsets = tableViewIndicatorInset
        chatRoomTableView.keyboardDismissMode = .interactive
        chatRoomTableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        
        if (UITraitCollection.current.userInterfaceStyle == .dark) {
            StampView.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.7)
            sview.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.7)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            
            if keyboardFrame.height <= accessoryHeight { return }
            
            let top = keyboardFrame.height - safeAreaBottom
            var moveY = -(top - chatRoomTableView.contentOffset.y)
            // 最下部意外の時は少しずれるので微調整
            if chatRoomTableView.contentOffset.y != -60 { moveY += 60 }
            let contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
            
            chatRoomTableView.contentInset = contentInset
            chatRoomTableView.scrollIndicatorInsets = contentInset
            chatRoomTableView.contentOffset = CGPoint(x: 0, y: moveY)
            StampView.isHidden = true
            sview.isHidden = true
        }
    }
    
    private var users: [User] = [] {
        didSet {
            chatRoomTableView?.reloadData()
        }
    }
    
    @objc func keyboardWillHide() {
        chatRoomTableView.contentInset = tableViewContentInset
        chatRoomTableView.scrollIndicatorInsets = tableViewIndicatorInset
        modeing = 0
    }
     
    override var inputAccessoryView: UIView? {
        get {
            return chatInputAccessoryView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func fetchMessages() {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        guard let chatroomDocId = chatroom?.documentId else { return }
        
    Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").addSnapshotListener { (snapshots, err) in
            
            if let err = err {
                print("メッセージ情報の取得に失敗しました。\(err)")
                return
            }
            
        snapshots?.documentChanges.forEach({ (documentChange) in
            switch documentChange.type {
            case .added:
                let dic = documentChange.document.data()
                let message = Message(dic: dic)
                message.partnerUser = self.chatroom?.partnerUser
                
                self.messages.append(message)
                self.messages.sort { (m1, m2) -> Bool in
                    let m1Date = m1.createdAt.dateValue()
                    let m2Date = m2.createdAt.dateValue()
                    return m1Date > m2Date
                }
                
                mytruename = String(UserDefaults.standard.string(forKey: "myname")!)
                
                let firestore = Firestore.firestore()
                let checkerRef = firestore.collection("checker").document(mytruename).collection(self.navigationItem.title!)
                
                self.chatRoomTableView.reloadData()
//                self.chatRoomTableView.scrollToRow(at: IndexPath(row: self.messages.count - 1, section: 0), at: .bottom, animated: true)
                
            case .modified, .removed:
                print("nothing to do")
            }
            
        })
        }
    }
    
    @IBAction func a1(_ sender: Any) {
        copyurl = "yunichatM:icons8-ここにいます-47.png"
        viewhide()
    }
    @IBAction func b1(_ sender: Any) {
        copyurl = "yunichatM:icons8-いいね-100.png"
        viewhide()
    }
    @IBAction func c1(_ sender: Any) {
        copyurl = "yunichatM:icons8-yes.png"
        viewhide()
    }
    @IBAction func d1(_ sender: Any) {
        copyurl = "yunichatM:icons8-ok-100.png"
        viewhide()
    }
    @IBAction func e1(_ sender: Any) {
        copyurl = "yunichatM:icons8-no.png"
        viewhide()
    }
    @IBAction func f1(_ sender: Any) {
        copyurl = "yunichatM:icons8-祈る-100.png"
        viewhide()
    }
    @IBAction func g1(_ sender: Any) {
        copyurl = "yunichatM:icons8-クエッションマーク-100.png"
        viewhide()
        let recipientName = "damakatu" // 相手の名前
        let message = "新規メッセージ" // 通知の本文
    }
    @IBAction func h1(_ sender: Any) {
        copyurl = "yunichatM:icons8-loudly-crying-face-94.png"
        viewhide()
    }
    @IBAction func i1(_ sender: Any) {
        copyurl = "yunichatM:icons8-rip-66.png"
        viewhide()
    }
    @IBAction func j1(_ sender: Any) {
        copyurl = "yunichatM:icons8-ハイタッチ.png"
        viewhide()
    }
}

extension ChatRoomViewController: ChatInputAccessoryViewDelegate {
    
    func tappedSendButton(text: String) {
        addMessageToFirestore(text: text)
        sentmode = 1
        
        var ref: DatabaseReference!
        ref = Database.database().reference()
        mytruename = String(UserDefaults.standard.string(forKey: "myname")!)
        print("residence/\(mytruename)" + " sender:" + navigationItem.title!)
        ref.child("residence/\(mytruename)").setValue(yourtoken)
        
        ref.child("residence/\(navigationItem.title!)").getData(completion:  { error, snapshot in
          guard error == nil else {
            print(error!.localizedDescription)
            return;
          }
            self.usertoken = snapshot.value as? String ?? "Unknown";
            print(self.usertoken)
        });
        
        print(self.usertoken)
        print(key)
        let deviceToken = self.usertoken
        let notificationTitle = "\(mytruename)からのメッセージ"
        let notificationBody = "\(text)"
        sendFCMNotification(to: deviceToken, title: notificationTitle, body: notificationBody)
        
        //let firestore = Firestore.firestore()
        //let checkerRef2 = firestore.collection("checker").document(sender).collection(mytruename)
        
        // ここで一番古いメッセージ情報を利用する
        print("Oldest message text: \(text)")
        print("Sender name: \(mytruename)")
        UserDefaults.standard.set(text, forKey: "\(sender)message")
    }
    
    private func addMessageToFirestore(text: String) {
        guard let chatroomDocId = chatroom?.documentId else { return }
        guard let name = user?.username else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        chatInputAccessoryView.removeText()
        
        let messageId = randomString(length: 20)
        var globalValuepp = name
         
        let docData = [
            "name": name,
            "createdAt": Timestamp(),
            "uid": uid,
            "message": text
            ] as [String : Any]
        Firestore.firestore().collection("chatRooms").document(chatroomDocId).collection("messages").document(messageId).setData(docData) { (err) in
            if let err = err {
                print("メッセージ情報の保存に失敗しました。\(err)")
                return
            }
            
            let latestMessageData = [
                "latestMessageId": messageId
            ]
            
            Firestore.firestore().collection("chatRooms").document(chatroomDocId).updateData(latestMessageData) { [self] (err) in
                if let err = err {
                    print("最新メッセージの保存に失敗しました。\(err)")
                    return
                }
                print("メッセージの保存に成功しました。")
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}

extension ChatRoomViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        chatRoomTableView.estimatedRowHeight = 20
        //ChatRoomTableViewCell.partnerMessageTextView.text = ""
        //ChatRoomTableViewCell.myMessageTextView.text = ""
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatRoomTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ChatRoomTableViewCell
        cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
//        cell.messageTextView.text = messages[indexPath.row]
        cell.message = messages[indexPath.row]
        cell.delegate = self
        
        // 一番古いメッセージが表示される際に一番古いセルの情報を取得
        if indexPath.row == 0, let oldestMessage = messages.first {
            let messageText = oldestMessage.message
            let senderName = oldestMessage.name
            let createdAt = oldestMessage.createdAt
            
            // ここで一番古いメッセージ情報を利用する
            print("Oldest message text: \(messageText)")
            print("Sender name: \(senderName)")
            UserDefaults.standard.set(messageText, forKey: "\(sender)message")
        }
        
        return cell ?? ChatRoomTableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToNext" {
            let nextVC = segue.destination as! PViewController
            //nextVC.printData = name
        }
    }
    
}
