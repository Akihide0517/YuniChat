//
//  infocontroller.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/26.
//

import UIKit

class infocontroller: UIViewController {
    
    var nowimage = 0
    @IBOutlet weak var image: UIImageView!
    
    @IBAction func hidari(_ sender: Any) {
        if(nowimage != 0){
            nowimage = nowimage - 1
        }
        image.image = UIImage(named: String(nowimage))
    }
    @IBAction func migi(_ sender: Any) {
        if(nowimage != 4){
            nowimage = nowimage + 1
        }
        image.image = UIImage(named: String(nowimage))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        image.image = UIImage(named: "0")
    }
}
