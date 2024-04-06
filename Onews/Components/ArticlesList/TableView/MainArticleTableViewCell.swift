//
//  MainArticleTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/20.
//

import Foundation
import UIKit

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
        
        mainArticleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainArticleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainArticleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        mainArticleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -10).isActive = true
    }
    
    func reload() {
        self.mainArticleView.reload()
    }
}
