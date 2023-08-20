//
//  chatcontroller.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/11/24.
//

import Foundation
import UIKit
// WebKitをimportする
import WebKit

class chatcontroller: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewを生成
        webView = WKWebView(frame: view.frame)
        // WKWebViewをViewControllerのviewに追加する
        view.addSubview(webView)
        // リクエストを生成
        let request = URLRequest(url: URL(string: "https://whereby.com/yoshida-home")!)
        // リクエストをロードする
        webView.load(request)
    }
}
