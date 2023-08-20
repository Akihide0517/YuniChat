//
//  OwnCloud.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/04.
//

import Foundation
import UIKit
// WebKitをimportする
import WebKit

class OwnCloudViewController: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.black;
        
        // WKWebViewを生成
        webView = WKWebView(frame: view.frame)
        // WKWebViewをViewControllerのviewに追加する
        view.addSubview(webView)
        // リクエストを生成
        let request = URLRequest(url: URL(string: "https://drive.google.com/drive/u/2/")!)
        // リクエストをロードする
        webView.load(request)
    }

}
