//
//  ArticleWebViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/24.
//

import Foundation
import WebKit

class ArticleWebViewController: UIViewController, WKNavigationDelegate {
    
    var url: String?
    var webView: WKWebView!
    
    init(url: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: self.url!)!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
}
