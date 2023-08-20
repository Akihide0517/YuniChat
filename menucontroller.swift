//
//  menucontroller.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/12/12.
//

import Foundation
import UIKit

class menucontroller: UIViewController {
    
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var tileimage4: UIImageView!
    @IBOutlet weak var tileimage3: UIImageView!
    @IBOutlet weak var tileimage2: UIImageView!
    @IBOutlet weak var tileimage: UIImageView!
    
    static var menu = 0
    
    @IBAction func calcultor(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "calculator", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CViewController") as! CViewController
        let nav = UINavigationController(rootViewController: viewController)
        present(nav, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlelabel.text = roomname + "/menu"
        menucontroller.menu = 1
        
        tileimage4.layer.cornerRadius = tileimage4.frame.size.width * 0.06
        tileimage4.clipsToBounds = true
        
        tileimage3.layer.cornerRadius = tileimage3.frame.size.width * 0.06
        tileimage3.clipsToBounds = true
        
        tileimage2.layer.cornerRadius = tileimage2.frame.size.width * 0.06
        tileimage2.clipsToBounds = true
        
        tileimage.layer.cornerRadius = tileimage.frame.size.width * 0.06
        tileimage.clipsToBounds = true
    }
}
