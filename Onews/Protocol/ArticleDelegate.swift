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
    func showNewsLoading()
    func hideNewsLoading()
}
