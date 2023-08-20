//
//  SampleWKWebViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/06/04.
//

import Foundation
import UIKit
// WebKitをimportする
import WebKit

class SampleWKWebViewController: UIViewController {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebViewを生成
        webView = WKWebView(frame: view.frame)
        // WKWebViewをViewControllerのviewに追加する
        view.addSubview(webView)
        // リクエストを生成
        let request = URLRequest(url: URL(string: "http://yunitiate.html.xdomain.jp/project-task/task.html")!)
        // リクエストをロードする
        webView.load(request)
    }

}
