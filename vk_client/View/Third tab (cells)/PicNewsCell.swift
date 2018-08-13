//
//  PicNewsCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 02/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class PicNewsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var articleImageWidthConstraint: NSLayoutConstraint!

    func setup(news: News, indexPath: IndexPath, tableView: UITableView) {
        
        // Setting images
        setImagesToView(news: news, indexPath: indexPath, tableView: tableView)

        nameLabel.text = news.name
        articleImageWidthConstraint.constant = 430
        likesLabel.text = String(news.likes)
        commentsLabel.text = String(news.comments)
        repostsLabel.text = String(news.reposts)
        viewsLabel.text = String(news.views)
        
        // Customization
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
    }
    
    private func setImagesToView(news: News, indexPath: IndexPath, tableView: UITableView) {
        let getCacheImageIcon = GetCacheImage(url: news.iconURLString)
        let getCacheImageContent = GetCacheImage(url: news.articleImageURLString)
        let setImageToRow = SetImageToRowWithPicNewsCell(cell: self, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImageIcon)
        setImageToRow.addDependency(getCacheImageContent)
        VKService.shared.networkQueue.addOperation(getCacheImageIcon)
        VKService.shared.networkQueue.addOperation(getCacheImageContent)
        OperationQueue.main.addOperation(setImageToRow)
    }
}
