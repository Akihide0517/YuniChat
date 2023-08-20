//
//  imageviewer.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/23.
//

import UIKit
import UserNotifications

class imageviewer: UIViewController{
    
    @IBOutlet weak var becouse: UITextView!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var Pimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Pimage.image = enemyimage
        
        // UIImageView にタップイベントを追加
        Pimage.isUserInteractionEnabled = true
        Pimage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.saveImage(_:))))

    }
    
    // セーブを行う
        @objc func saveImage(_ sender: UITapGestureRecognizer) {

            //タップしたUIImageViewを取得
            let targetImageView = sender.view! as! UIImageView
            // その中の UIImage を取得
            let targetImage = targetImageView.image!
            //保存するか否かのアラート
            let alertController = UIAlertController(title: "保存", message: "この画像を保存しますか？", preferredStyle: .alert)
            //OK
            let okAction = UIAlertAction(title: "OK", style: .default) { (ok) in
                //ここでフォトライブラリに画像を保存
                UIImageWriteToSavedPhotosAlbum(targetImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
            }
            //CANCEL
            let cancelAction = UIAlertAction(title: "CANCEL", style: .default) { (cancel) in
                alertController.dismiss(animated: true, completion: nil)
            }
            //OKとCANCELを表示追加し、アラートを表示
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    
    // 保存結果をアラートで表示
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {

           var title = "保存完了"
           var message = "カメラロールに保存しました"

           if error != nil {
               title = "エラー"
               message = "保存に失敗しました"
           }

           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

           // OKボタンを追加
           alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

           // UIAlertController を表示
           self.present(alert, animated: true, completion: nil)
       }
}
