//
//  NewsCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 31/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class TextNewsCell: UITableViewCell {
    
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
    @IBOutlet weak var articleLabel: UILabel! {
        didSet {
            articleLabel.translatesAutoresizingMaskIntoConstraints = false
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
    
    let insets: CGFloat = 20.0
    let iconSide: CGFloat = 60.0
    let socialMediaActivityHeight: CGFloat = 24.0
    
    func setup(news: News, indexPath: IndexPath, tableView: UITableView, framesPack: NewsFramesPack) {
        
        nameLabel.frame = framesPack.nameFrame
        iconImageView.frame = framesPack.iconFrame
        articleLabel.frame = framesPack.articleOrContentImageFrame
        likesLabel.frame = framesPack.likesFrame
        commentsLabel.frame = framesPack.commentsFrame
        repostsLabel.frame = framesPack.repostsFrame
        viewsLabel.frame = framesPack.viewsFrame
        
        setImageToView(news: news, indexPath: indexPath, tableView: tableView)
        nameLabel.text = news.name
        articleLabel.text = news.article
        likesLabel.text = String(news.likes)
        commentsLabel.text = String(news.comments)
        repostsLabel.text = String(news.reposts)
        viewsLabel.text = String(news.views)
        
        // Customization
        iconImageView.layer.cornerRadius = 20
    }
    
    private func setImageToView(news: News, indexPath: IndexPath, tableView: UITableView) {
        let getCacheImage = GetCacheImage(url: news.iconURLString)
        let setImageToRow = SetImageToRowWithTextNewsCell(cell: self, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        VKService.shared.networkQueue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
}










