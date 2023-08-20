//
//  AccountViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/12.
//

import Foundation
import UIKit
import Firebase // Firebaseをインポート
import FirebaseAuth

class AccountViewController: UIViewController {

    var auth: Auth?
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }

    // 登録ボタンを押したときに呼ぶメソッド。
    @IBAction func registerAccount() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        auth!.createUser(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result {
                // errorが nil であり、resultがnilではない == user情報がきちんと取得されている。
                self.performSegue(withIdentifier: "Timeline", sender: result.user) // 遷移先の画面でuser情報を渡している。
            }
        }
    }
}
// デリゲートメソッドは可読性のためextensionで分けて記述します。
extension AccountViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
