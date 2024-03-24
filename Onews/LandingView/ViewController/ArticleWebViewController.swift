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
    var source: String?
    var webView: WKWebView!
    
    init(url: String, source: String) {
        super.init(nibName: nil, bundle: nil)
        self.url = url
        self.source = source
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest(url: URL(string: self.url!)!))
        webView.allowsBackForwardNavigationGestures = true
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeWebView))
        navigationItem.title = self.source
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: createRefreshButton(), style: .plain, target: self, action: #selector(reloadWebView))
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    @objc func closeWebView() {
        self.dismiss(animated: true)
    }
    
    @objc func reloadWebView() {
        self.webView.addBlurToView()
        
        if webView.url != nil {
                webView.reload()
            } else {
                webView.load(URLRequest(url: URL(string: self.url!)!))
            }
        self.webView.removeBlurFromView()
    }
    
    func createRefreshButton() -> UIImage {
        let config = UIImage.SymbolConfiguration(scale: .large)
        return UIImage(systemName: "arrow.clockwise", withConfiguration: config)!
    }
}
