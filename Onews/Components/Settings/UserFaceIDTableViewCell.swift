//
//  UserFaceIDTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/04/02.
//

import Foundation
import UIKit

class UserFaceIDTableViewCell: UITableViewCell {

    lazy var cellView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var useFaceIDButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.setTitle(K.useFaceIDText, for: .normal)
        button.layer.cornerRadius = 8.0
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .none
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(useFaceIDButton)
        
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        useFaceIDButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        useFaceIDButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        useFaceIDButton.widthAnchor.constraint(equalTo: cellView.widthAnchor).isActive = true
    }
}
