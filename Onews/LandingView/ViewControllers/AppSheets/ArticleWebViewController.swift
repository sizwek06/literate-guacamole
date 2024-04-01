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
        
        navigationController?.navigationBar.backgroundColor = UIColor(named: "CollectionColor")
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Close", style: .plain, target: self, action: #selector(closeWebView)),
                                            UIBarButtonItem(image: createBarButton(using: "safari"), style: .plain, target: self, action: #selector(openInSafari))]
        navigationItem.title = self.source
        navigationItem.rightBarButtonItems = 
        [UIBarButtonItem(image: createBarButton(using: "arrow.clockwise"), style: .plain, target: self, action: #selector(reloadWebView)),
         UIBarButtonItem(image: createBarButton(using: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareNewsArticleLink))]
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    @objc func closeWebView() {
        self.dismiss(animated: true)
    }
    
    @objc func openInSafari() {
        if let url = URL(string: self.url!) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc func reloadWebView() {
        OnewsLoaderViewController.sharedInstance.show()
        if webView.url != nil {
            webView.reload()
        } else {
            webView.load(URLRequest(url: URL(string: self.url!)!))
        }
        OnewsLoaderViewController.sharedInstance.hide()
    }
    
    @objc func shareNewsArticleLink() {
        OnewsLoaderViewController.sharedInstance.show()
        guard let articleURL = self.url else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [articleURL], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        OnewsLoaderViewController.sharedInstance.hide()
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func createBarButton(using systemName: String) -> UIImage {
        let config = UIImage.SymbolConfiguration(scale: .medium)
        return UIImage(systemName: systemName, withConfiguration: config)!
    }
}
