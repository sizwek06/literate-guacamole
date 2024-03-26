//
//  OnewsLoader.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

open class OnewsLoader: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var loadingTextLabel: UILabel!
    @IBOutlet weak var loaderView: UIView!

   public var loadingText: String?

    public init(loadingText: String = "This will only take a moment.") {

        self.init()
        self.loadingText = loadingText
    }

   public override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()

    }

    public required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }

    public func commonInit() {

        Bundle(for: OnewsLoader.self).loadNibNamed("OnewsLoader", owner: self, options: nil)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(contentView)

        translatesAutoresizingMaskIntoConstraints = false
        loaderView.layer.cornerRadius = 8.0
    }

   public func show() {

        let window = UIApplication.shared.keyWindow

        if let window = window {
            imageView.loadGif(asset: "NewsApp")
            loadingTextLabel.text = K.loadingText

            window.addSubview(self)

            window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[loaderScreen]|",
                                                                 options: [],
                                                                 metrics: [:],
                                                                 views: ["loaderScreen": self]))
            window.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[loaderScreen]|",
                                                                 options: [],
                                                                 metrics: [:],
                                                                 views: ["loaderScreen": self]))
        }
    }

   public func hide() {
       DispatchQueue.main.async {
           self.removeFromSuperview()
       }
    }
}
