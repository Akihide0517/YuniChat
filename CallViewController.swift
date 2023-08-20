//
//  CallViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/03/07.
//

import UIKit
import UserNotifications

class CallViewController :UIView{
    
    @IBOutlet weak var textField: UITextField!
    var textFieldString = ""
    var a = ""
    
    @IBAction func callTestTapped(_ sender: Any) {
        // TextFieldから文字を取得
        let phoneNumber = textField.text!
        //let phoneNumber = "+81351598200"
        
        guard let url = URL(string: "tel://" + phoneNumber) else { return }
        UIApplication.shared.open(url)
        
        // TextFieldの中身をクリア
        textField.text = "+81"
    }
    
    @IBAction func callClearTapped(_ sender: Any) {
        // TextFieldの中身をクリア
        textField.text = "+81"
        
        //アクションのクラスに日本語の数字がつかわれているのでここがバグの原因かもしれない。
    }
    @IBAction func １(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "1"
    }
    @IBAction func ２(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "2"
    }
    @IBAction func ３(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "3"
    }
    @IBAction func ４(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "4"
    }
    @IBAction func ５(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "5"
    }
    @IBAction func ６(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "6"
    }
    @IBAction func ７(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "7"
    }
    @IBAction func ８(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "8"
    }
    @IBAction func ９(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "9"
    }
    @IBAction func ０(_ sender: Any) {
        var a = textField.text
        textField.text = a! + "0"
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        textField.text = textField.text
        return true
    }
    //override func viewDidLoad() {
        //super.viewDidLoad()
        
    //}
}
