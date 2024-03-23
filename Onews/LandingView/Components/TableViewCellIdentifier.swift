//
//  TableViewCellIdentifier.swift
//  Onews
//
//  Created by Sizwe Khathi on 2023/10/25.
//

import Foundation
import UIKit

// MARK: TableView Identifier
extension UITableViewCell {
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    public static var identifier: String {
        return String(describing: self)
    }
}

// MARK: CollectionView Identifier
extension UICollectionViewCell {
    public static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    public static var identifier: String {
        return String(describing: self)
    }
}
