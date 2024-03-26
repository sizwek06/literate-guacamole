//
//  UserViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/26.
//

import Foundation
import UIKit

class UserViewController: ArticlesListViewController {
    
    var userName = "@seezus"
    
    var articlesArray = [
        Article(source: Source(id: "abc-news", name: "ABC News"), author: "Will McDuffie", title: "7 dead in 'destructive' Mississippi tornado, official says - ABC News", description: "A deadly tornado touched down in Mississippi, officials said.",url: "https://abcnews.go.com/US/7-dead-mississippi-tornado-official/story?id=98117564", urlToImage: "https://s.abcnews.com/images/US/mississipppi-tornado_1679721477403_hpMain_16x9_992.jpg", publishedAt: "2023-05-21T19:15:11Z", content: "At least seven people died in a \"destructive\" tornado that rolled across Mississippi late Friday, leaving a trail of damage for more than 100 miles, local and federal authorities said.\r\nSearch and re… [+1791 chars]"),
        Article(source: Source(id: nil, name: "Fox Business"), author: "Ken Martin", title: "Intel co-founder Gordon Moore dies at 94 - Fox Business", description: "Gordon Moore, the man who co-founded the technology giant Intel, has died at the age of 94. Moore died peacefully his home in Hawaii surrounded by family.", url: "https://www.foxbusiness.com/technology/intel-co-founder-gordon-moore-dies-at-94", urlToImage: "https://a57.foxnews.com/static.foxbusiness.com/foxbusiness.com/content/uploads/2023/03/0/0/Intel-Moore-A.jpg?ve=1&tl=1", publishedAt: "2023-05-21T07:15:11Z", content: "Intel's co-founder Gordon Moore died on Friday at the age of 94.\r\nThe announcement was made in a statement from Intel and the Gordon and Betty Moore Foundation.\r\nThe foundation reported he died peace… [+4477 chars]"),
        Article(source: Onews.Source(id: Optional("espn"), name: "ESPN"), author: Optional("Jeff Legwold"), title: "Houston outlasts Texas A&M in OT, advances in NCAA tournament - ESPN", description: Optional("Emanuel Sharp started overtime with a 3-pointer that put top-seeded Houston ahead to stay, as the Cougars advanced to the Sweet 16 back in Texas by topping ninth-seeded Texas A&M 100-95 on Sunday night."), url: "https://www.espn.com/mens-college-basketball/story/_/id/39804678/houston-outlasts-texas-ot-advance-ncaa-tournament", urlToImage: Optional("https://a2.espncdn.com/combiner/i?img=%2Fphoto%2F2024%2F0325%2Fr1309682_1296x729_16%2D9.jpg"), publishedAt: "2024-03-25T05:06:00Z", content: Optional("MEMPHIS, Tenn. -- As the closing seconds of the greatest of overtime escapes played out in front of him Sunday night, Houston coach Kelvin Sampson could have turned his head to the right and seen fou… [+4041 chars]")),
        Article(source: Onews.Source(id: nil, name: "New York Post"), author: Optional("Jack Hobbs"), title: "Oliver Hudson details childhood \'trauma\' with mom Goldie Hawn: \'I felt unprotected\' - New York Post ", description: Optional("Oliver Hudson, son of Hollywood stars Goldie Hawn and Bill Hudson, got candid about his childhood trauma and how he sometimes felt “unprotected” by his mother."), url: "https://nypost.com/2024/03/25/entertainment/oliver-hudson-felt-unprotected-trauma-with-mom-goldie-hawn/", urlToImage: Optional("https://nypost.com/wp-content/uploads/sites/2/2024/03/78987838.jpg?quality=75&strip=all&w=1024"), publishedAt: "2024-03-25T13:57:08Z", content: Optional("Oliver Hudson, son of Hollywood stars Goldie Hawn and Bill Hudson, is getting candid about his childhood and how he sometimes felt “unprotected” by his famous mom. \r\n“My mother was the one that I had… [+3963 chars]")),
        Article(source: Onews.Source(id: Optional("ign"), name: "IGN"), author: Optional("Wesley Yin-Poole"), title: "Stellar Blade Demo Hits PS5 This Friday (Officially This Time) - IGN", description: Optional("Sony has announced a demo for upcoming PlayStation 5 exclusive Stellar Blade, which goes live this Friday, March 29, at 7am PDT / 2pm GMT. Here\'s what it includes."), url: "https://www.ign.com/articles/stellar-blade-demo-hits-ps5-this-friday-officially-this-time", urlToImage: Optional("https://assets-prd.ignimgs.com/2024/01/31/stellarbladegameplayoverviewtrailer-ign-blogroll-1706740555448.jpg?width=1280"), publishedAt: "2024-03-25T13:02:35Z", content: Optional("Sony has announced a demo for upcoming PlayStation 5 exclusive Stellar Blade, which goes live this Friday, March 29, at 7am PDT / 2pm GMT.\r\nThe demo takes place from the beginning of the game up to t… [+1706 chars]")),
        Article(source: Onews.Source(id: nil, name: "YouTube"), author: nil, title: "Samsung QN900D QLED 8K TV First Look | It’s 8K Anyway - Digital Trends", description: Optional("The Samsung QN900D 8K Neo QLED TV is proof that Samsung has no intention of taking its foot off the gas when it comes to 8K TVs.  As one of the last TV brand..."), url: "https://www.youtube.com/watch?v=1JkzpDXUpzA", urlToImage: Optional("https://i.ytimg.com/vi/1JkzpDXUpzA/maxresdefault.jpg"), publishedAt: "2024-03-25T12:59:00Z", content: nil)
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Profile"
        super.tableView.register(UINib(nibName: "UserProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "userProfileTableViewCell")
        
        tableView.frame = view.bounds
        super.search.searchBar.isHidden = true
        view.addSubview(tableView)
    }
    
}

extension UserViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "User Profile" : "Articles"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : self.articlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 250 : UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let article = self.articlesArray[indexPath.row]
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsArticle", for: indexPath) as? NewsArticleTableViewCell else { return UITableViewCell() }
                        
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
            downloadImg(urlString: article.urlToImage, imgView: cell.articleImg)
            
            cell.articleLabel.text = article.title
            cell.websiteLabel.text = article.source.name.uppercased()
            cell.websiteLabel.textColor = returnSourceColour()
            cell.timeLabel.text = Date().convertStringToDate(dateString: article.publishedAt)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileTableViewCell", for: indexPath) as? UserProfileTableViewCell else { return UITableViewCell() }
            
            cell.selectionStyle = .none
            cell.backgroundColor = .none
            
            cell.usernameLabel.text = self.userName
            cell.userProfileButton.titleLabel?.text = userName.isEmpty ? "Sign In" : "Sign Out"
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articlesArray[indexPath.row]
        
        DispatchQueue.main.async {
            self.handleOpenArticleURL(url: article.url, source: article.source.name)
            self.hideNewsLoading()
        }
    }
}
