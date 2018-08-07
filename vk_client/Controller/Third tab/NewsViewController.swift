//
//  NewsViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 31/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {

    var news = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Network
        VKService.shared.getNewsFeedFor(self)
        
        // Customization
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        let oneNews = news[index]
    
        if news[index].articleImageURLString == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextNewsCell", for: indexPath) as! TextNewsCell
            cell.setup(news: oneNews)
            sleep(UInt32(0.5))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicNewsCell", for: indexPath) as! PicNewsCell
            cell.setup(news: oneNews)
            sleep(UInt32(0.5))
            return cell
        }

    }
        
}


