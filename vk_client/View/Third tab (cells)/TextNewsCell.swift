//
//  NewsCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 31/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class TextNewsCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    func setup(news: News, indexPath: IndexPath, tableView: UITableView) {
        
        // Set image to view in TextNewsCell
        setImageToView(news: news, indexPath: indexPath, tableView: tableView)
        
        nameLabel.text = news.name
        articleLabel.text = news.article
        likesLabel.text = String(news.likes)
        commentsLabel.text = String(news.comments)
        repostsLabel.text = String(news.reposts)
        viewsLabel.text = String(news.views)
        
        // Customization
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
    }
    
    private func setImageToView(news: News, indexPath: IndexPath, tableView: UITableView) {
        let getCacheImage = GetCacheImage(url: news.iconURLString)
        let setImageToRow = SetImageToRowWithTextNewsCell(cell: self, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        VKService.shared.networkQueue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
    }
    
}
