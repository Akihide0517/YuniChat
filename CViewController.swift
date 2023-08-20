//
//  ViewController.swift
//  calculator
//
//  Created by 吉田成秀 on 2022/11/13.
//

import UIKit
 
class CViewController: UIViewController {
 
    @IBOutlet weak var nameText: UITextField!
    var delegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let oneButtonNumber : int_fast8_t = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
            delegate.numberValue = 0
            delegate.nameValue = nil
        
        if(menucontroller.menu == 1){
            nameText.text = roomname
        }
    }

    @IBAction func next_Button(_ sender: Any) {
            delegate.nameValue = nameText.text
        let second = Second_ViewController()
        //present(second, animated: true, completion: nil)
    }
}
