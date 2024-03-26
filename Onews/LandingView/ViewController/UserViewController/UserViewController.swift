//
//  UserViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

class UserViewController: UIViewController {
    
    var articlesArray = [
        Article(source: Source(id: "abc-news", name: "ABC News"), author: "Will McDuffie", title: "7 dead in 'destructive' Mississippi tornado, official says - ABC News", description: "A deadly tornado touched down in Mississippi, officials said.",url: "https://abcnews.go.com/US/7-dead-mississippi-tornado-official/story?id=98117564",urlToImage: "https://s.abcnews.com/images/US/mississipppi-tornado_1679721477403_hpMain_16x9_992.jpg", publishedAt: "2023-05-21T19:15:11Z", content: "At least seven people died in a \"destructive\" tornado that rolled across Mississippi late Friday, leaving a trail of damage for more than 100 miles, local and federal authorities said.\r\nSearch and re… [+1791 chars]"),
        Article(source: Source(id: nil, name: "Fox Business"), author: "Ken Martin", title: "Intel co-founder Gordon Moore dies at 94 - Fox Business", description: "Gordon Moore, the man who co-founded the technology giant Intel, has died at the age of 94. Moore died peacefully his home in Hawaii surrounded by family.", url: "https://www.foxbusiness.com/technology/intel-co-founder-gordon-moore-dies-at-94", urlToImage: "https://a57.foxnews.com/static.foxbusiness.com/foxbusiness.com/content/uploads/2023/03/0/0/Intel-Moore-A.jpg?ve=1&tl=1", publishedAt: "2023-05-21T07:15:11Z", content: "Intel's co-founder Gordon Moore died on Friday at the age of 94.\r\nThe announcement was made in a statement from Intel and the Gordon and Betty Moore Foundation.\r\nThe foundation reported he died peace… [+4477 chars]"),
        Article(source: Onews.Source(id: Optional("espn"), name: "ESPN"), author: Optional("Jeff Legwold"), title: "Houston outlasts Texas A&M in OT, advances in NCAA tournament - ESPN", description: Optional("Emanuel Sharp started overtime with a 3-pointer that put top-seeded Houston ahead to stay, as the Cougars advanced to the Sweet 16 back in Texas by topping ninth-seeded Texas A&M 100-95 on Sunday night."), url: "https://www.espn.com/mens-college-basketball/story/_/id/39804678/houston-outlasts-texas-ot-advance-ncaa-tournament", urlToImage: Optional("https://a2.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0325%2Fr1309682_1296x729_16%2D9.jpg"), publishedAt: "2024-03-25T05:06:00Z", content: Optional("MEMPHIS, Tenn. -- As the closing seconds of the greatest of overtime escapes played out in front of him Sunday night, Houston coach Kelvin Sampson could have turned his head to the right and seen fou… [+4041 chars]"))
        ]
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(UINib(nibName: "NewsArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "newsArticle")
        table.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        table.refreshControl = UIRefreshControl()
//        table.refreshControl?.addTarget(self, action:
//                                            #selector(tableViewReloadNewsArticles),
//                                          for: .valueChanged)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        
        tableView.rowHeight = 150
        tableView.separatorStyle = .singleLine
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        view.addSubview(tableView)
    }
}

extension UserViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "User Profile" : "Articles"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.articlesArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 250 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let article = self.articlesArray[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle", for: indexPath) as? NewsArticleTableViewCell else { return UITableViewCell() }
                        
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
//            downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
            
            cell.articleLabel.text = article.title
            cell.websiteLabel.text = article.source.name.uppercased()
//            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
            cell.usernameLabel.text = "@seezus"
            
            return cell
        }
    }
}
