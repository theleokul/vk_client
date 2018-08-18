//
//  PicNewsCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 02/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class PicNewsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView! {
        didSet {
            iconImageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var articleImageView: UIImageView! {
        didSet {
            articleImageView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var likesLabel: UILabel! {
        didSet {
            likesLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var commentsLabel: UILabel! {
        didSet {
            commentsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var repostsLabel: UILabel! {
        didSet {
            repostsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var viewsLabel: UILabel! {
        didSet {
            viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    func setup(news: News, indexPath: IndexPath, tableView: UITableView, framesPack: NewsFramesPack) {
        
        nameLabel.text = news.name
        likesLabel.text = String(news.likes)
        commentsLabel.text = String(news.comments)
        repostsLabel.text = String(news.reposts)
        viewsLabel.text = String(news.views)
        
        nameLabel.frame = framesPack.nameFrame
        iconImageView.frame = framesPack.iconFrame
        articleImageView.frame = framesPack.articleOrContentImageFrame
        likesLabel.frame = framesPack.likesFrame
        commentsLabel.frame = framesPack.commentsFrame
        repostsLabel.frame = framesPack.repostsFrame
        viewsLabel.frame = framesPack.viewsFrame
        
        // Setting images
        setImagesToView(news: news, indexPath: indexPath, tableView: tableView)
        
        // Customization
        iconImageView.layer.cornerRadius = 20
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        articleImageView.image = nil
    }
}
