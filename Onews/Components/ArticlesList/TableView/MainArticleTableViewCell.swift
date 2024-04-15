//
//  MainArticleTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/20.
//

import Foundation
import UIKit
import OnewsSDK

class MainArticleTableViewCell: UITableViewCell {
    
    var articlesArray: [Article]?
    var isUserSignedIn: Bool?
    
    lazy var mainArticleView: MainArticleView = {
        let mainArticle = MainArticleView(articlesArray: articlesArray ?? [],
                                          isSignedIn: isUserSignedIn ?? false)
        mainArticle.translatesAutoresizingMaskIntoConstraints = false
        mainArticle.isUserInteractionEnabled = true
        return mainArticle
    }()
    
    lazy var pageIndicator: UIPageControl = {
        let dots = UIPageControl(frame: CGRect(x: 100, y: 100, width: 120, height: 25))
        dots.numberOfPages = 3
        dots.currentPageIndicatorTintColor = .black
        dots.pageIndicatorTintColor = .lightGray
        dots.backgroundColor = .white
        dots.translatesAutoresizingMaskIntoConstraints = false
        return dots
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        accessoryType = .none
        selectionStyle = .none
        
        contentView.addSubview(mainArticleView)
        contentView.addSubview(pageIndicator)
        
        mainArticleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainArticleView.heightAnchor.constraint(equalToConstant: 480.0).isActive = true
        mainArticleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        mainArticleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5).isActive = true
        
        pageIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        pageIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    func reload() {
        self.mainArticleView.reload()
    }
}
