//
//  OnewsLoaderController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

public class OnewsLoaderViewController {
    
    internal var loader: OnewsLoader? = OnewsLoader.init()
    
    public static let sharedInstance = OnewsLoaderViewController()
    
    public init() {}
    
    public func setDisplay(title: String, description: String) {
        loader = OnewsLoader.init()
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
