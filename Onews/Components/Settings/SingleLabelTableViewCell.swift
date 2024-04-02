//
//  SettingsSignOutTableViewCell.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

class SingleLabelTableViewCell: UITableViewCell {
    
    lazy var userState: Bool = false
    
    lazy var cellView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var signOutLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = self.userState ? UIFont(name: "SF-Pro-Text-SemiBold", size: 15.0) : UIFont(name: "SF-Pro-Rounded", size: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        cellView.addSubview(signOutLabel)
        
        cellView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        cellView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        signOutLabel.centerXAnchor.constraint(equalTo: cellView.centerXAnchor).isActive = true
        signOutLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
    }
}
