//
//  DetailViewController.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/07/08.
//
import UIKit
import WebKit

class DetailViewController: UIViewController , WKUIDelegate{

    var webView: WKWebView!

    var urlString = ""

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        if(URL(string:urlString) != nil){
            let myURL = URL(string:urlString)
            let myRequest = URLRequest(url: myURL!)
            webView.load(myRequest)
        }else{
            print("nil!")
        }
    }
}
