//
//  TtableViewCell.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/12/31.
//

import UIKit
import Firebase
import Nuke
import SDWebImage

class TtableViewCell: UITableViewCell {
    
    var messagetxt: String = ""
    var uid: String = ""
    var times: String = ""
    var imagename: String = ""
    var message: Message? {
        didSet {
//            if let message = message {
//                partnerMessageTextView.text = message.message
//                let witdh = estimateFrameForTextView(text: message.message).width + 20
//                messageTextViewWidthConstraint.constant = witdh
//
//                partnerDateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
//
//
//            }
        }
    }
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var partnerhukidashi2: UIView!
    @IBOutlet weak var myhukidashi2: UIView!
    @IBOutlet weak var image22: UIImageView!
    @IBOutlet weak var userImageView2: UIImageView!
    @IBOutlet weak var partnerMessageTextView2: UITextView!
    @IBOutlet weak var myMessageTextView2: UITextView!
    @IBOutlet weak var partnerDateLabel2: UILabel!
    @IBOutlet weak var myDateLabel2: UILabel!
    
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var myMessageTextViewWidthConstraint: NSLayoutConstraint!
    
    @IBAction func userImageViewTapped(_ sender: Any) {
        enemyimage = userImageView2.image
        NotificationCenter.default.post(name: NSNotification.Name("image"), object: nil)
    }
    
    @objc func imageViewTapped(_ sender: UITapGestureRecognizer) {
        sub1  = String(self.partnerMessageTextView2.text.prefix(10))
        sub11 = String(self.partnerMessageTextView2.text.dropFirst(10))
        sub2  = String(self.myMessageTextView2.text.prefix(10))
        sub22 = String(self.myMessageTextView2.text.dropFirst(10))
        
        loadImage()
        enemyimage = image22.image
        NotificationCenter.default.post(name: NSNotification.Name("image"), object: nil)
    }
    
    func Reuserimage(){
        Firestore.firestore().collection("users").document(String(imagename)).getDocument { (snap, error) in
                if let error = error {
                    fatalError("\(error)")
                }
            
                guard let data = snap?.data() else { return }
                let ImageName = snap?.get("profileImageUrl") as! String
                let MyName = snap?.get("username") as! String
            
                //DispatchQueue.global(qos: .default).async {
                    self.showImage(imageView: self.userImageView2, url: ImageName)
                    UserDefaults.standard.set(mytruename, forKey: "myname")
                //}
            
            }
    }
    
    private func showImage(imageView: UIImageView, url: String) {
        /*
         画像を端末に保存して以前の問題点であった画像の表示間違いを修正するコードを追記しました。
         コードにコメント化が多いのは元に戻す際に目印となるサンプルがあるからです。
         新しく保存するたびカクツキや長時間ロードが発生しますが、
         一度保存してしまえば以降のロードを最小化できるのでこっちの方がいいと思います。
         <現在の問題＞
         ・本当に動作するのか？→検証可能な人数、機会が限られている
         ・画像の保存に間違いがあった場合修正できない→変更機能を実装した場合も同様の問題が発生する
         ・写真の数と容量によっては重くなる可能性がある
         */
        
        if(UserDefaults.standard.object(forKey: self.namelabel.text!) == nil){
            DispatchQueue.global(qos: .default).async {
                let url = URL(string: url)
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        imageView.image = image
                        
                        let data = image!.pngData() as NSData?
                        var saveArray: Array! = [NSData]()
                        if let imageData = data {
                            saveArray.append(imageData)
                            UserDefaults.standard.set(imageData, forKey: self.namelabel.text!)
                        }
                    }
                } catch let err {
                    print("Error: \(err.localizedDescription)")
                }
            }
        }else{
            if(UserDefaults.standard.object(forKey: self.namelabel.text!) is String == false){
                print(self.namelabel.text!)
                
                if UserDefaults.standard.object(forKey: self.namelabel.text!) != nil {
                    let objects = UserDefaults.standard.object(forKey: self.namelabel.text!) as? NSArray
                    //配列としてUserDefaultsに保存した時の値と処理後の値が変わってしまうのでremoveAll()
                    var saveArray: Array! = [NSData]()
                    saveArray.removeAll()
                    //for data in objects! {
                        //saveArray.append(data as! NSData)
                    imageView.image = UIImage(data: UserDefaults.standard.object(forKey: self.namelabel.text!) as! Data)
                    //}
                }
            }
        }
    }
    
    @IBOutlet weak var test: SDAnimatedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //loadImage()
        test?.layer.cornerRadius = 13
        image22?.layer.cornerRadius = 13
        image22?.isUserInteractionEnabled = true
        image22?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewTapped(_:))))
        
        backgroundColor = .clear
        userImageView2?.layer.cornerRadius = 20
        partnerMessageTextView2?.layer.cornerRadius = 15
        myMessageTextView2?.layer.cornerRadius = 15
        
        if(partnerMessageTextView2 != nil || myMessageTextView2 != nil){
            sub1  = String(partnerMessageTextView2.text.prefix(10))
            sub11 = String(partnerMessageTextView2.text.dropFirst(10))
            sub2  = String(myMessageTextView2.text.prefix(10))
            sub22 = String(myMessageTextView2.text.dropFirst(10))
        }
        loadImage()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkWhichUserMessage()
    }
    
    var sub1 = ""
    var sub2 = ""
    var sub11 = ""
    var sub22 = ""
    
    private func checkWhichUserMessage() {
        partnerMessageTextView2.text = ""
        myMessageTextView2.text = ""
        image22.image = UIImage(named: "")
        image22.isHidden = true
        namelabel.text = uid
        
        if(imagename != ""){
            Reuserimage()
        }
        
        sub1  = String(partnerMessageTextView2.text.prefix(10))
        sub11 = String(partnerMessageTextView2.text.dropFirst(10))
        sub2  = String(myMessageTextView2.text.prefix(10))
        sub22 = String(myMessageTextView2.text.dropFirst(10))
        loadImage()
        
        if uid == mytruename {
            namelabel.isHidden = true
            partnerMessageTextView2.isHidden = true
            partnerhukidashi2.isHidden = true
            partnerDateLabel2.isHidden = true
            userImageView2.isHidden = true
            
            myMessageTextView2.isHidden = false
            myDateLabel2.isHidden = false
            myhukidashi2.isHidden = false
            
            myMessageTextView2.text = messagetxt
            myDateLabel2.text = times
            var messages = myMessageTextView2.text!
            let witdh = estimateFrameForTextView(text: messages).width + 20
            myMessageTextViewWidthConstraint.constant = witdh
            
            
            if(myMessageTextView2.text == ""){
                namelabel.isHidden = true
                myMessageTextView2.isHidden = true
                myDateLabel2.isHidden = true
                myhukidashi2.isHidden = true
            }
        } else {
            namelabel.isHidden = false
            partnerMessageTextView2.isHidden = false
            partnerhukidashi2.isHidden = false
            partnerDateLabel2.isHidden = false
            userImageView2.isHidden = false
            
            myMessageTextView2.isHidden = true
            myDateLabel2.isHidden = true
            myhukidashi2.isHidden = true
            
            if let urlString = message?.partnerUser?.profileImageUrl, let url = URL(string: urlString) {
                DispatchQueue.global(qos: .default).async {
                    Nuke.loadImage(with: url, into: self.userImageView2)
                }
            }
            
            partnerMessageTextView2.text = messagetxt
            partnerDateLabel2.text = times
            var messages = partnerMessageTextView2.text!
            let witdh = estimateFrameForTextView(text: messages).width + 20
            messageTextViewWidthConstraint.constant = witdh
            
            if(partnerMessageTextView2.text == ""){
                partnerMessageTextView2.isHidden = true
                partnerhukidashi2.isHidden = true
                partnerDateLabel2.isHidden = true
                userImageView2.isHidden = true
            }
        }
        
        sub1  = String(partnerMessageTextView2.text.prefix(10))
        sub11 = String(partnerMessageTextView2.text.dropFirst(10))
        sub2  = String(myMessageTextView2.text.prefix(10))
        sub22 = String(myMessageTextView2.text.dropFirst(10))
        loadImage()
    }
    
    //取得したURLを基にStorageから画像を取得する
    func loadImage() {
        let date = Date()
        let df = DateFormatter()

        df.dateFormat = "yyyy-MM"
        print(df.string(from: date))
        nowload = 0
        // 2019-10
        
            if(sub1 == "yunichatM:"){
                print("sub1!")
                let storageref = Storage.storage().reference(forURL: "gs://chat-12dd0.appspot.com").child(sub11)
                partnerMessageTextView2.isHidden = true
                partnerhukidashi2.isHidden = true
                namelabel.isHidden = true
                myDateLabel2.isHidden = true
                partnerDateLabel2.isHidden = true
                image22.isHidden = false
                DispatchQueue.global(qos: .default).async {
                    self.image22.sd_setImage(with: storageref)
                }
            }else if(sub2 == "yunichatM:"){
                print("sub2!")
                let storageref = Storage.storage().reference(forURL: "gs://chat-12dd0.appspot.com").child(sub22)
                myMessageTextView2.isHidden = true
                myhukidashi2.isHidden = true
                myDateLabel2.isHidden = true
                partnerDateLabel2.isHidden = true
                image22.isHidden = false
                DispatchQueue.global(qos: .default).async {
                    self.image22.sd_setImage(with: storageref)
                }
            }
        }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M/dd/HH:mm"
        //formatter.timeStyle = .short
            //formatter.setLocalizedDateFormatFromTemplate("MMMMdjm")
        return formatter.string(from: date)
    }
}
