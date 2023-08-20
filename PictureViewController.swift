//
//  PictureViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/11.
//

import FirebaseAuthUI
import FirebaseAnonymousAuthUI
import FirebasePhoneAuthUI
import FirebaseOAuthUI
import FirebaseGoogleAuthUI
import FirebaseStorageUI
import SDWebImage
import PKHUD

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var stampbackgroundviewtop: UIView!
    @IBOutlet weak var stampbackgroundview: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var OnImageView: UIView!
    @IBOutlet weak var textview: UITextView!
    @IBAction func Pbutton(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textview.layer.cornerRadius = 12
        stampbackgroundviewtop.layer.cornerRadius = 12
        stampbackgroundviewtop.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        OnImageView.layer.cornerRadius = 18
        OnImageView.layer.shadowColor = UIColor.black.cgColor
        OnImageView.layer.shadowOpacity = 1
        OnImageView.layer.shadowRadius = 8
        OnImageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        stampbackgroundview.layer.cornerRadius = 12
        stampbackgroundview.layer.shadowColor = UIColor.black.cgColor
        stampbackgroundview.layer.shadowOpacity = 1
        stampbackgroundview.layer.shadowRadius = 8
        stampbackgroundview.layer.shadowOffset = CGSize(width: 4, height: 4)
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
            // キャンセルボタンを押下時の処理
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
                self.textview.text = "yunichatM:Image" + df.string(from: date) + ".jpg"
                UIPasteboard.general.string = self.textview.text
            }
        }
    }
    
    @IBAction func a(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-ここにいます-47.png"
    }
    @IBAction func b(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-いいね-80.png"
    }
    @IBAction func c(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-yes-64.png"
    }
    @IBAction func d(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-ok-hand-100.png"
    }
    @IBAction func e(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-no-64.png"
    }
    @IBAction func f(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-avatar-91.png"
    }
    @IBAction func g(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-answer-91.png"
    }
    @IBAction func h(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-angry-91.png"
    }
    @IBAction func i(_ sender: Any) {
        UIPasteboard.general.string = "yunichatM:icons8-angel-64.png"
    }
}
