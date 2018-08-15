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
        
        //setSocialMediaActivitiesLabels(likesText: String(news.likes), commentsText: String(news.comments), repostsText: String(news.reposts), viewsText: String(news.views))
        //self.setNeedsLayout()
        //self.layoutIfNeeded()
        
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

// MARK: - Layout subviews

extension TextNewsCell {
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        socialMediaActivitiesLabelsFrames()
//
//    }
    
    
//    func setNameLabel(text: String) {
//        nameLabel.text = text
//        nameLabelFrame()
//    }
//    
//    func setArticleLabel(text: String) {
//        articleLabel.text = text
//        articleLabelFrame()
//    }
//    
//    func setSocialMediaActivitiesLabels(likesText: String, commentsText: String, repostsText: String, viewsText: String) {
//        likesLabel.text = likesText
//        commentsLabel.text = commentsText
//        repostsLabel.text = repostsText
//        viewsLabel.text = viewsText
//        socialMediaActivitiesLabelsFrames()
//    }
    
//    func getLabelSizeShifted(text: String, font: UIFont) -> CGSize {
//
//        let maxWidth = bounds.width - (3 * insets + iconSide)
//        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
//        let rect = text.boundingRect(with: textBlock, options: .truncatesLastVisibleLine, attributes: [NSAttributedStringKey.font : font], context: nil)
//        let width = Double(rect.size.width)
//        let height = Double(rect.size.height)
//        let size = CGSize(width: ceil(width), height: ceil(height))
//        return size
//    }
//
//    func getLabelSize(text: String, font: UIFont) -> CGSize {
//
//        let maxWidth = bounds.width - 2 * insets
//        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
//        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil)
//        let width = Double(rect.size.width)
//        let height = Double(rect.size.height)
//        let size = CGSize(width: ceil(width), height: ceil(height))
//        return size
//    }
//
//    func nameLabelFrame() {
//        let labelSize = getLabelSizeShifted(text: nameLabel.text!, font: nameLabel.font)
//        let labelX = 2 * insets + iconSide
//        let labelY = insets + (iconSide - labelSize.height) / 2
//        let labelOrigin = CGPoint(x: labelX, y: labelY)
//        nameLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
//    }
//
//    func articleLabelFrame() {
//        let labelSize = getLabelSize(text: articleLabel.text!, font: articleLabel.font)
//        let labelX = insets
//        let labelY = 2 * insets + iconSide
//        let labelOrigin = CGPoint(x: labelX, y: labelY)
//        articleLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
//    }
//
//    func socialMediaActivitiesLabelsFrames() {
//        let width = (bounds.width - 5 * insets) / 4
//        let labelSize = CGSize(width: ceil(width), height: socialMediaActivityHeight)
//        let labelY = 3 * insets + iconSide + articleLabel.frame.height
//        let likesOrigin = CGPoint(x: insets, y: labelY)
//        let commentsOrigin = CGPoint(x: 2 * insets + width, y: labelY)
//        let repostsOrigin = CGPoint(x: 3 * insets + 2 * width, y: labelY)
//        let viewsOrigin = CGPoint(x: 4 * insets + 3 * width, y: labelY)
//        likesLabel.frame = CGRect(origin: likesOrigin, size: labelSize)
//        commentsLabel.frame = CGRect(origin: commentsOrigin, size: labelSize)
//        repostsLabel.frame = CGRect(origin: repostsOrigin, size: labelSize)
//        viewsLabel.frame = CGRect(origin: viewsOrigin, size: labelSize)
//    }
//
//    // Additional methods for configuring and recalculating frames for setup(...)
//
//    func iconImageViewFrame() {
//        let size = CGSize(width: iconSide, height: iconSide)
//        let origin = CGPoint(x: insets, y: insets)
//        iconImageView.frame = CGRect(origin: origin, size: size)
//    }
    
}











