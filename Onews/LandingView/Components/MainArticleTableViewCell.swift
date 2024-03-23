//
//  MainArticleTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/03/20.
//

import Foundation
import UIKit

class MainArticleTableViewCell: UITableViewCell {
    
    lazy var mainArticleView: MainArticleView = {
        let mainArticle = MainArticleView()
        mainArticle.translatesAutoresizingMaskIntoConstraints = false
        return mainArticle
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        backgroundColor = .white
        accessoryType = .none
        selectionStyle = .none
        
        contentView.addSubview(mainArticleView)
        
        mainArticleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        mainArticleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        mainArticleView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
        mainArticleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: -10).isActive = true
    }
}
