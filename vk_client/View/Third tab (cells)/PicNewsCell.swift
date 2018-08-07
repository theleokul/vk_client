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

    func setup(news: News) {
        self.iconImageView.kf.setImage(with: URL(string: news.iconURLString))
        self.nameLabel.text = news.name
        self.articleImageView.kf.setImage(with: URL(string: news.articleImageURLString))
        self.likesLabel.text = String(news.likes)
        self.commentsLabel.text = String(news.comments)
        self.repostsLabel.text = String(news.reposts)
        self.viewsLabel.text = String(news.views)
    }
}
