//
//  SettingsViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit

class SettingsViewController: ArticlesListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        super.tableView.register(UINib(nibName: "SettingsTableViewCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        super.tableView.register(SettingsSignOutTableViewCell.self, forCellReuseIdentifier: SettingsSignOutTableViewCell.identifier)
        
        tableView.frame = view.bounds
        super.search.searchBar.isHidden = true
        view.addSubview(tableView)
    }
}

// MARK: - TableView Content
extension SettingsViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 2 : 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? UITableView.automaticDimension : 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none

            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as? SettingsTableViewCell else { return UITableViewCell() }
            // TODO: Create enum of settings to recursive the cells
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsSignOutTableViewCell.identifier) as? SettingsSignOutTableViewCell else { return UITableViewCell() }
            // TODO: Create enum of settings to recursive the cells
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
}
