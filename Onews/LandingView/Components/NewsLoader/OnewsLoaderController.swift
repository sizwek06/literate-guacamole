//
//  OnewsLoaderController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

public class OnewsLoaderViewController {
    
    internal var loader: OnewsLoaderUIView? = OnewsLoaderUIView.init()
    
    public static let sharedInstance = OnewsLoaderViewController()
    
    public init() {}
    
    public func setDisplay(loadingText: String) {
        loader = OnewsLoaderUIView.init(loadingText: loadingText)
    }
    
    public func setText(title: String) {
        
        loader?.setText(title)
    }
    
    public func show() {
        if loader != nil {
            loader?.show()
        }
    }
    
    public func hide() {
        if loader != nil {
            loader?.hide()
        }
    }
}
