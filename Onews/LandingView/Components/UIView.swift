//
//  UIView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/07/23.
//

import Foundation
import UIKit

extension UIView {
    
    func addBlurToView() {
        var blurEffect: UIBlurEffect!
        
        if #available(iOS 10.0, *) {
            blurEffect = UIBlurEffect(style: .dark)
        } else {
            blurEffect = UIBlurEffect(style: .light)
        }
        
        let activitInd = UIActivityIndicatorView(style: .large)
        activitInd.color = .lightGray
        activitInd.hidesWhenStopped = true
        activitInd.frame = CGRect(x: 0.0, y: 00, width: 80.0, height: 80.0)
        activitInd.center = self.center
        
        activitInd.startAnimating()
                   
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        blurredEffectView.frame = self.bounds
        blurredEffectView.alpha = 0.9
        blurredEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurredEffectView)
        self.addSubview(activitInd)
    }
    
    func removeBlurFromView() {
        for subview in subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
        
        for subview in subviews {
            if subview is UIActivityIndicatorView {
                subview.removeFromSuperview()
            }
        }
    }
}
