//
//  PrifileViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/06.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import UserNotifications
import PKHUD

class PViewController: UIViewController, UITextFieldDelegate {
    
    var userDefaults = UserDefaults.standard
    
    @IBOutlet weak var hideview: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var seilabel: UITextField!
    @IBOutlet weak var namelabel: UITextField!
    @IBOutlet weak var rolllabel: UITextField!
    @IBOutlet weak var yourview: UIView!
    
    @IBAction func secretButtonTapped(_ sender: Any) {
        //yourview.isHidden = !yourview.isHidden
    }
    
    @IBAction private func tappedLogoutButton() {
        do {
            try Auth.auth().signOut()
            pushLoginViewController()
        } catch {
            print("ログアウトに失敗しました。 \(error)")
        }
    } 
    
    private func pushLoginViewController() {
        let storyboar = UIStoryboard(name: "SignUp", bundle: nil)
        let signUpViewController = storyboar.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        let nav = UINavigationController(rootViewController: signUpViewController)//MARK: here!
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true, completion: nil)
    }
    
    private func fetchLogInUserInfo() {
        Firestore.firestore().collection("users").document(String(name.text!)).getDocument { (snap, error) in
                if let error = error {
                    fatalError("\(error)")
                }
            
                guard let data = snap?.data() else { return }
                let ImageName = snap?.get("profileImageUrl") as! String
                let MyName = snap?.get("username") as! String
            
                mytruename = MyName
                self.name.text = MyName
                self.showImage(imageView: self.image, url: ImageName)
                UserDefaults.standard.set(mytruename, forKey: "myname")
            }
    }
    
    private func showImage(imageView: UIImageView, url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            imageView.image = image
        } catch let err {
            print("Error: \(err.localizedDescription)")
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = myname
        UserDefaults.standard.set(myname, forKey: "myimage")
        
        fetchLogInUserInfo()
        image.layer.cornerRadius = 80
        //yourview.isHidden = !yourview.isHidden
        label.adjustsFontSizeToFitWidth = true
        super.viewDidLoad()//?
        
        // UserDefaultsに初回起動フラグが設定されているかを確認
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        
        if isFirstLaunch {
            hideview.isHidden = true
            print("初回起動ではありません")
            
            //UserDefaults.standard.set(false, forKey: "isFirstLaunch")
        } else {
            hideview.isHidden = false
            print("初回起動です")
        }
        
        Ex()
        label.text = UserDefaults.standard.object(forKey: "ki-") as! String
        //namelabel.text = (UserDefaults.standard.object(forKey: "name") as! String)
        //seilabel.text = UserDefaults.standard.object(forKey: "sei") as! String
        //rolllabel.text = UserDefaults.standard.object(forKey: "roll") as! String
        
        namelabel.delegate = self
        seilabel.delegate = self
        rolllabel.delegate = self
        self.toruView.isHidden = true
        
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
        namelabel.inputAccessoryView = toolbar
        seilabel.inputAccessoryView = toolbar
        rolllabel.inputAccessoryView = toolbar
    }

    @IBAction func okbutton(_ sender: Any) {
        var userDefaults = UserDefaults.standard
        
        userDefaults.set(namelabel.text, forKey: "name")
        userDefaults.set(seilabel.text, forKey: "sei")
        userDefaults.set(rolllabel.text, forKey: "roll")
        HUD.flash(.success, delay:1.0)
        
        hideview.isHidden = true
        UserDefaults.standard.set(true, forKey: "isFirstLaunch")
    }
    
    //完了ボタンを押した時の処理
     @objc func didTapDoneButton() {
         namelabel.resignFirstResponder()
         seilabel.resignFirstResponder()
         rolllabel.resignFirstResponder()
     }

    @objc func keyboardWillShow(_ notification: NSNotification){
        if let userInfo = notification.userInfo, let keyboardFrameInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            //inputViewBottomMargin.constant = keyboardFrameInfo.cgRectValue.height
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification){
        //inputViewBottomMargin.constant = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }

    @IBOutlet weak var toruView: UIStackView!
    
    @IBAction func calculator(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "calculator", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CViewController") as! CViewController
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true)
    }
    
    @IBAction func appearButton(_ sender: Any) {
        if toruView.isHidden {
            UIView.animate(withDuration: 0.3) {
                self.toruView.isHidden = false
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.toruView.isHidden = true
            }
        }
    }
}
