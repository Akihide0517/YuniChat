//
//  ViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/02/26.
//
//これはニュースのページを表示するプログラムです。
//現状サイトが完成していないので代わりとしてNewsListTableViewViewControllerをchatlistに接続しています
//これはコードもわからんしあまりいい状態でもないので使える状態になったらすぐに変更して下さい

import UIKit
import WebKit

class ViewController: UIViewController {

    // @IBOutlet weak var callTestTapped: UIButton!
    @IBOutlet weak var View_web: WKWebView!
    @IBAction func modoru(_ sender: UIButton) {
        //somthing here
    }
    @IBAction func twiesmodoru(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    @IBOutlet weak var ButtonBar3: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        WKWebsiteDataStore.default().removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), modifiedSince: Date(timeIntervalSince1970: 0), completionHandler: {})
        
        ButtonBar3.layer.shadowOffset = CGSize(width: 0.0, height: 2.5)
        ButtonBar3.layer.shadowColor = UIColor.black.cgColor
        ButtonBar3.layer.shadowOpacity = 0.6
        ButtonBar3.layer.shadowRadius = 4
        
        let testurl = URL(string: "http://yunitiate.html.xdomain.jp/project-news/index.html")!
        let req     = URLRequest(url: testurl)
        View_web.load(req)
    }
}

