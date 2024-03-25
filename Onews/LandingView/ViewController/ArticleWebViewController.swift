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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeWebView))
        navigationItem.title = self.source
        navigationItem.rightBarButtonItems = 
        [UIBarButtonItem(image: createBarButtonRefreshButton(using: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadWebView)),
         UIBarButtonItem(image: createBarButtonRefreshButton(using: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareNewsArticleLink))]
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
        
        if webView.url != nil {
            webView.reload()
        } else {
            webView.load(URLRequest(url: URL(string: self.url!)!))
        }
    }
    
    @objc func shareNewsArticleLink() {
        guard let articleURL = self.url else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [articleURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func createBarButtonRefreshButton(using systemName: String) -> UIImage {
        let config = UIImage.SymbolConfiguration(scale: .medium)
        return UIImage(systemName: systemName, withConfiguration: config)!
    }
}
