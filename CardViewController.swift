//
//  CardViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/24.
//

import Foundation
import SwiftUI

class CardViewController: UIViewController {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var sei: UILabel!
    @IBOutlet weak var roll: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func viewDidLoad() {
        
        Ex()
        email.text = UserDefaults.standard.object(forKey: "ki-") as! String
        name.text = UserDefaults.standard.object(forKey: "name") as! String
        sei.text = UserDefaults.standard.object(forKey: "sei") as! String
        roll.text = UserDefaults.standard.object(forKey: "roll") as! String
        
        
    }
}
