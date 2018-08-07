//
//  PicNewsCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 02/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import Kingfisher

class PicNewsCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var articleImageWidthConstraint: NSLayoutConstraint!

    func setup(news: News) {
        iconImageView.kf.setImage(with: URL(string: news.iconURLString))
        nameLabel.text = news.name
        articleImageView.kf.indicatorType = .activity
        articleImageWidthConstraint.constant = 430
        articleImageView.kf.setImage(with: URL(string: news.articleImageURLString))
        likesLabel.text = String(news.likes)
        commentsLabel.text = String(news.comments)
        repostsLabel.text = String(news.reposts)
        viewsLabel.text = String(news.views)
        
        // Customization
        iconImageView.layer.cornerRadius = 20
        iconImageView.clipsToBounds = true
    }
}











//        if let url = URL(string: news.articleImageURLString) {
//            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) {
//                (image, error, cacheType, url) in
//                if let image = image {
//                    self.articleImageView.image = image
//                }
//            }
//        }
