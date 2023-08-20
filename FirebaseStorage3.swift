//
//  FirebaseStorage3.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/04.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseAnonymousAuthUI
import FirebasePhoneAuthUI
import FirebaseOAuthUI
import FirebaseGoogleAuthUI
import FirebaseStorageUI
import SDWebImage
import PKHUD

class FirebaseStorage3: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView1: UIImageView!
    @IBAction func uploadImage1(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
        
    @IBAction func loadImage1(_ sender: Any) {
        HUD.show(.progress)
        loadImage()
        HUD.hide()
    }
    
    func imagePickerController(_ imagePicker: UIImagePickerController,didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        let date1 = Date()
        let df1 = DateFormatter()

        df1.dateFormat = "EEE"
        print(df1.string(from: date1))
        // 2019-10
        
        //初期格納データ
        var image1 = UIImage(named: "見出しを追加")!
        var data1 = image1.jpegData(compressionQuality: 1)! as NSData
        let storageref = Storage.storage().reference(forURL: "gs://chat-12dd0.appspot.com").child("PTimage.jpg")
        
        //画像
        if let image1 = info[.originalImage]
          as? UIImage {
            // 画像選択時の処理
              // ↓選んだ画像を取得
            data1 = image1.jpegData(compressionQuality: 1)! as NSData
            imageView1.image = image1
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // キャンセルボタンを押下時の処理
        }
        //Storageに保存
        HUD.show(.progress)
        self.dismiss(animated: true, completion: nil)
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child("PTimage" + df1.string(from: date1) + ".jpg")
        let uploadImage = imageView1.image!.jpegData(compressionQuality: 1.0)! as NSData

        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        ref.putData(uploadImage as Data, metadata: metadata) { _, error in
            if (error != nil) {
                print("upload error!")
            } else {
                HUD.hide()
                print("upload successful!")
            }
        }
        loadImage()
    }
        
        //取得したURLを基にStorageから画像を取得する
        func loadImage() {
            
            let date1 = Date()
            let df1 = DateFormatter()

            df1.dateFormat = "EEE"
            print(df1.string(from: date1))
            // 2019-10
            
            //StorageのURLを参照
            let storageref1 = Storage.storage().reference(forURL: "gs://chat-12dd0.appspot.com").child("PTimage" + df1.string(from: date1) + ".jpg")
            //画像をセット
            imageView1.sd_setImage(with: storageref1)
        }
    
        override func viewDidLoad() {
            super.viewDidLoad()
            //firebaseのキャッシュ問題で最終更新後から一時間はキャッシュが更新されない注意されたし
            loadImage()
        }

    }
