//
//  ArticleDelegate.swift
//  Onews
//
//  Created by SizweKhathi on 2023/07/01.
//

import Foundation
import UIKit

protocol ArticleDelegate {
    func didReceiveArticlesSuccessfully()
    func didFailWithError(error: String)
    func returnSourceColour() -> UIColor
    func downloadImg(urlString: String?, imgView: UIImageView)
    func showNewsLoading()
    func hideNewsLoading()
}
