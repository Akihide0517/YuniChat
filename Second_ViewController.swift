//
//  Second_ViewController.swift
//  calculator
//
//  Created by 吉田成秀 on 2022/11/13.
//

import UIKit

class Second_ViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var A: UIButton!
    @IBOutlet weak var B: UIButton!
    @IBOutlet weak var CEO: UIButton!
    @IBOutlet weak var Special: UIButton!
    
    let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel?.text = (delegate.nameValue)
        
        if(delegate.nameValue != "1234"){
            A.isHidden = true
        }
        if(delegate.nameValue != "5678"){
            B.isHidden = true
        }
        if(delegate.nameValue != "0"){
            CEO.isHidden = true
        }
        if(delegate.nameValue != roomname){
            Special.isHidden = true
        }
    }
}
