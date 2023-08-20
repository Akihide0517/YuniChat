//
//  teamcontroller.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/24.
/*これに関するファイルはcahtroomview関連におけるfirebaseを使ったfirestorによるデータ取得法に対してrealtimedatabaseによる,
chatroomview関連のチャットプログラムを再現したものになります。
その目的はfirestorよりも簡単に実装可能なrealtimedatabaseを使った方がチャットアプリの基本的な機構は素早く実装可能なのではないか？
という疑問から実装しました。
事実、実際にfirestorを利用しているのはchatroomview関連のみで、このアプリのほとんどはrealtimedatabaseを使ったものになります。

しかし、今回の実装において、realtimedatabaseは海外にサーバーがあることもあり、特に受信速度が壊滅的に遅い傾向にあることから、
セルの表示の際に、大きくかくついてしまっています。
よって次回より、この実装方法はお勧め致しません。 
*/

import UIKit
import FirebaseDatabase
import FirebaseAuth
import Firebase
import PKHUD

class teamcontroller: UIViewController, UITextFieldDelegate, UITableViewDelegate, UIImagePickerControllerDelegate,  UITableViewDataSource, UITextViewDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var stampview: UIView!
    @IBOutlet weak var photoview: UIView!
    @IBOutlet weak var TtableView: UITableView!
    @IBOutlet weak var Mview: UIView!
    @IBOutlet weak var teamlabel: UILabel!
    @IBOutlet weak var messageInputView: UITextView!//
    @IBOutlet weak var inputViewBottomMargin: NSLayoutConstraint!
    
    @IBOutlet weak var kage: UIView!
    
    @IBOutlet weak var messageheight: NSLayoutConstraint!//
    @IBOutlet weak var Mviewheight: NSLayoutConstraint!//
    fileprivate var currentTextViewHeight: CGFloat = 40 //HiraginoSans Fontサイズ15の初期高さ
    
    var databaseRef: DatabaseReference!
    var messageArray = [Any]()
    var scrollBeginningPoint: CGPoint!
    var touchMode = false
 
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollBeginningPoint = scrollView.contentOffset
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPoint = scrollView.contentOffset
        if scrollBeginningPoint.y < currentPoint.y {
            print("下へスクロール")
            if touchMode {
                NotificationCenter.default.post(name: UIResponder.keyboardWillHideNotification, object: nil)
                self.messageInputView.endEditing(true)
                touchMode = false
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: TtableView)
        let isTouchingTableView = TtableView.bounds.contains(touchPoint)
        touchMode = isTouchingTableView // タッチされた状態を記録
        return isTouchingTableView
    }

    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: TtableView)

        if let indexPath = TtableView.indexPathForRow(at: touchPoint) {
            // タッチした位置に対応するセルが存在する場合の処理
            // indexPathを使用して、セルに対する特定のアクションを実行するなど
            touchMode = true
        } else {
            touchMode = false
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = roomname
        self.stampview.isHidden = true
        self.photoview.isHidden = true
        messageInputView.layer.cornerRadius = 15
        messageInputView.layer.borderColor = UIColor.rgb(red: 230, green: 230, blue: 230).cgColor
        messageInputView.layer.borderWidth = 1
        modeing = 0
        isChat = 1
        kage.innerShadow()
        print("A")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tapGesture.delegate = self
            TtableView.addGestureRecognizer(tapGesture)
        
        TtableView.register(UINib(nibName: "TtableViewCell", bundle: nil), forCellReuseIdentifier: "customCell")
        TtableView.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        //self.navigationController?.navigationBar.topItem!.title = ""
        
        //messageInputView.layer.cornerRadius = messageInputView.frame.height * 0.2
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.messageInputView.delegate = self
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.messageInputView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        //self.view.addGestureRecognizer(tapGesture)

        
        //Mview.layer.borderWidth = 0.5
        //Mview.layer.borderColor = UIColor.black.cgColor
        //goButton.layer.borderWidth = 1
        //goButton.layer.borderColor = UIColor.black.cgColor
        

        TtableView.delegate = self
        TtableView.dataSource = self
        TtableView.dequeueReusableCell(withIdentifier: "TeamCell")
        
        //SVProgressHUD.show()
        
        if Auth.auth().currentUser != nil {
            let postsRef = Database.database().reference().child("RoomList").child(roomname)
            postsRef.observe(.childAdded, with: { snapshot in
                //SVProgressHUD.dismiss()
                if let _ = Auth.auth().currentUser?.uid {
                    let dictionary = snapshot.value as! [String: AnyObject]
                    self.messageArray.insert(dictionary, at: 0)
                    self.TtableView.reloadData()
                }
            })
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadimageView(notification:)), name: NSNotification.Name(rawValue: "image"), object: nil)
        
        if (UITraitCollection.current.userInterfaceStyle == .dark) {
            stampview.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.7)
            photoview.backgroundColor = UIColor(red: 40/255, green: 40/255, blue: 40/255, alpha: 0.7)
            messageInputView.backgroundColor = UIColor.white
        }
        
        
        let databaseRef = Database.database().reference()
        var strArray = ["null"]

        // 配列を取得
        databaseRef.child("RoomListMenber").child(roomname).child("RoomListMenberList").observeSingleEvent(of: .value, with: { snapshot in
            if var array = snapshot.value as? [String] {
                if (array.contains(yourtoken)==false) {
                    strArray = array
                    strArray.append(yourtoken)
                    // データベースに配列を保存
                    databaseRef.child("RoomListMenber").child(roomname).child("RoomListMenberList").setValue(strArray) { error, _ in
                        if let error = error {
                            print("データの保存に失敗しました: \(error.localizedDescription)")
                        } else {
                            print("データの保存に成功しました")
                        }
                    }
                }
            } else {
                print("配列の取得に失敗しました")
                databaseRef.child("RoomListMenber").child(roomname).child("RoomListMenberList").setValue(strArray) { error, _ in
                    if let error = error {
                        print("データの保存に失敗しました: \(error.localizedDescription)")
                    } else {
                        print("データの保存に成功しました")
                       // self.viewDidLoad() -> なんでここにあるのか不明なのでデバッグ時には十分注意すること
                    }
                }
            }
        }) { error in
            print("データの取得に失敗しました: \(error.localizedDescription)")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! TtableViewCell
        
        let dictionary = messageArray[indexPath.row] as! [String: AnyObject]

        let time = dictionary["time"] as? String
        let username = dictionary["username"] as! String
        let messages = dictionary["message"] as? String
        let userimage = dictionary["userimage"] as? String
        
        if(userimage != nil){
            cell.imagename = userimage!
        }
        
        cell.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
//        cell.messageTextView.text = messages[indexPath.row]
        cell.messagetxt = (messages!)
        cell.uid = (username)
        cell.times = (time ?? "")
        return cell ?? ChatRoomTableViewCell()
    }
    
    func makespase(){//消してもいいけど何かに使うかもよ
        if Auth.auth().currentUser != nil {
            
            if let message = messageInputView.text {
                let time = NSDate.timeIntervalSinceReferenceDate
                
                let ref = Database.database().reference().child("RoomList").child(roomname)
                let data = [
                    "message": "",
                    "time": String(time),
                    "username": "",
                    "userimage": "",]
                
                ref.childByAutoId().setValue(data)
            }
        }
    }
    
    @objc func reloadimageView(notification: NSNotification) {
            let baseVC = self
            let storyboard = UIStoryboard(name: "ChatRoom", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "imageview")
            let next = vc
            DispatchQueue.main.async {
                //next.modalPresentationStyle = .fullScreen
                baseVC.present(next,animated: true)
            }
    }
    
    @IBAction func cleanbutton(_ sender: Any) {
        let alert2 = UIAlertController(title: "削除", message: "メッセージが全て消えます", preferredStyle: .alert)//←ここを変更
        
        let ok2 = UIAlertAction(title: "いいよ", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
            Database.database().reference().child("RoomList").child(roomname).child("hoge/foo/update").removeValue()
            self.TtableView.reloadData()
        }
        let cancel2 = UIAlertAction(title: "だめ", style: .cancel) { (acrion) in
            self.dismiss(animated: true, completion: nil)
        }
        
        alert2.addAction(cancel2)
        alert2.addAction(ok2)
        present(alert2, animated: true, completion: nil)
    }
     
    @IBAction func picbutton(_ sender: Any) {
        self.stampview.isHidden = true
        self.photoview.isHidden = true
        modeing = 0
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    @IBAction func stampbutton(_ sender: Any) {
        self.stampview.isHidden = false
    }
    @IBAction func imagebutton(_ sender: Any) {
        if(modeing == 0){
            self.stampview.isHidden = true
            self.photoview.isHidden = false
            modeing = 1
        }else{
            self.stampview.isHidden = true
            self.photoview.isHidden = true
            modeing = 0
        }
    }
    
    @IBAction func pushGoButton(_ sender: Any) {
        let message = String(self.messageInputView.text)
        
        if let myname = UserDefaults.standard.string(forKey: "myname") {
            mytruename = myname
        } else {
            // ユーザー名がUserDefaultsに保存されていない場合の処理
            print("ユーザー名が保存されていません")
            return
        }
        
        var databaseRef: DatabaseReference? // Optional型にする
        databaseRef = Database.database().reference()
        databaseRef!.child("RoomListMenber").child(roomname).child("RoomListMenberList").observeSingleEvent(of: .value, with: { snapshot in
            guard let dataArray = snapshot.value as? [String] else {
                print("データが存在しません")
                return
            }

            // 配列の要素を順番に処理
            for deviceToken in dataArray {
                let notificationTitle = "\(roomname)の\(mytruename)からのメッセージ"
                let notificationBody = "\(message)"
                print(deviceToken)
                self.sendFCMNotification(to: deviceToken, title: notificationTitle, body: notificationBody)
            }
        }) { error in
            print("データの取得に失敗しました: \(error.localizedDescription)")
        }
        
        if !messageInputView.text.isEmpty {
            GO()
            self.messageInputView.frame = CGRect(x: self.messageInputView.frame.minX, y: self.messageInputView.frame.minY, width: self.view.frame.width - 100, height: 40)
            self.Mviewheight.constant = 60
            currentTextViewHeight = 40
        }
    }
    
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
    
    func GO(){
        if Auth.auth().currentUser != nil {
        //makespase()
            if let message = messageInputView.text {
                var date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.dateStyle = .medium
                dateFormatter.dateFormat = "MM/dd/H:m"

                let time = dateFormatter.string(from: date)
                var imageurl = UserDefaults.standard.object(forKey: "myimage") as! String
            
                let ref = Database.database().reference().child("RoomList").child(roomname)
                let data = [
                    "message": message,
                    "time": time,
                    "username": mytruename,
                    "userimage": imageurl,]
            
                ref.childByAutoId().setValue(data)
            
                //SVProgressHUD.showSuccess(withStatus: "Success!")
                messageInputView.text = ""
            }
        }
    }
    
    func viewhide(){
        modeing = 0
        self.stampview.isHidden = true
        self.photoview.isHidden = true
        messageInputView.text = copyurl
        GO()
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
    
    func imagePickerController(_ imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let date = Date()
        let df = DateFormatter()
        
        df.dateFormat = "yMdkHms"
        print(df.string(from: date))
        // 2017/1/1 12:39:22
        
        //初期格納データ
        let image = UIImage(named: "見出しを追加")!
        var data = image.jpegData(compressionQuality: 1)! as NSData
        let storageref = Storage.storage().reference(forURL: "gs://chat-12dd0.appspot.com").child("Image" + df.string(from: date) + ".jpg")
        var iimage = UIImage(named: "見出しを追加")!
        
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
    
    @objc func didTapDoneButton() {
        messageInputView.resignFirstResponder()
    } 
    
    
    @IBOutlet weak var Pbutton: UIButton!
    @objc func keyboardWillShow(notification: NSNotification) {
        Pbutton.isEnabled = false
        self.stampview.isHidden = true
        self.photoview.isHidden = true
        modeing = 0
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                let suggestionHeight = self.view.frame.origin.y + keyboardSize.height
                if suggestionHeight < 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }

    
    var keyboardHeight: CGFloat = 0.0
    var isKeyboardAnimating = false

    @objc func keyboardWillHide(notification: NSNotification) {
        Pbutton.isEnabled = true
        keyboardHeight = 0.0
        adjustViewPosition()
    }

    func adjustViewPosition() {
        if keyboardHeight > 0.0 {
            let safeAreaBottom = view.safeAreaInsets.bottom
            let targetY = keyboardHeight - safeAreaBottom
            
            if view.frame.origin.y > -targetY && !isKeyboardAnimating {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    self.view.frame.origin.y = -targetY
                }, completion: nil)
            }
        } else {
            if view.frame.origin.y != 0 && !isKeyboardAnimating {
                UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
                    self.view.frame.origin.y = 0
                }, completion: nil)
            }
        }
    }

    func keyboardWillChangeFrame(notification: NSNotification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            isKeyboardAnimating = true
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.isKeyboardAnimating = false
                self.adjustViewPosition()
            }
        }
    }

    
    @objc func dismissKeyboard() {
            self.view.endEditing(true)
        }
}

extension teamcontroller{
    
    func textViewDidChange(_ textView: UITextView) {
        self.messageInputView.translatesAutoresizingMaskIntoConstraints = true
        self.messageInputView.sizeToFit()
        self.messageInputView.isScrollEnabled = false//改行制限の際にはコメント化してください。
        let resizedHeight = self.messageInputView.frame.size.height
        self.messageheight.constant = resizedHeight
 
        /*if(resizedHeight < 40*4){*///改行制限
            self.messageInputView.frame = CGRect(x: self.messageInputView.frame.minX, y: self.messageInputView.frame.minY, width: self.view.frame.width - 100, height: resizedHeight)
            
            if resizedHeight > currentTextViewHeight {
                let addingHeight = resizedHeight - currentTextViewHeight
                self.Mviewheight.constant += addingHeight
                currentTextViewHeight = resizedHeight
            }
            
            if resizedHeight > currentTextViewHeight {
                let addingHeight = resizedHeight - currentTextViewHeight
                self.Mviewheight.constant += addingHeight
                currentTextViewHeight = resizedHeight
            } else if resizedHeight < currentTextViewHeight {
                let subtractingHeight = currentTextViewHeight - resizedHeight
                self.Mviewheight.constant -= subtractingHeight
                currentTextViewHeight = resizedHeight
            }
        /*}else{
            self.messageInputView.frame = CGRect(x: self.messageInputView.frame.minX, y: self.messageInputView.frame.minY, width: self.view.frame.width - 100, height: 40*4-10)
        }*/
    }
}
