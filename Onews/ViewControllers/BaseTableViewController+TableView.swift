//
//  BaseTableViewController+TableView.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

extension BaseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 515 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func addLabelToImage(imageString: String, labelString: String) -> UIImage? {
        var image = UIImage()
        
        let tempView = UIStackView(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.height))
        
        let textLabel = UILabel()
        textLabel.text = labelString
        textLabel.font = UIFont(name: "SF-Pro-Semibold", size: 12)
        textLabel.textColor = .white
        
        imageView.contentMode = .scaleAspectFit
        tempView.axis = .vertical
        tempView.alignment = .center
        tempView.spacing = 8
        imageView.image = UIImage(systemName: imageString)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        tempView.addArrangedSubview(imageView)
        tempView.addArrangedSubview(textLabel)
        let renderer = UIGraphicsImageRenderer(bounds: tempView.bounds)
        image = renderer.image { rendererContext in
            tempView.layer.render(in: rendererContext.cgContext)
        }
        return image
    }
}
