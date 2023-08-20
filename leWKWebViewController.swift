//
//  leWKWebViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/04.
//

import Foundation
import UIKit
// WebKitをimportする
import WebKit

class leWKWebViewController: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewを生成
        webView = WKWebView(frame: view.frame)
        // WKWebViewをViewControllerのviewに追加する
        view.addSubview(webView)
        // リクエストを生成
        let request = URLRequest(url: URL(string: "https://yunitiate.web.fc2.com/login.html")!)
        // リクエストをロードする
        webView.load(request)
    }

}
