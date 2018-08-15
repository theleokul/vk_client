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
        
        
//        setNameLabel(text: news.name)
//        setSocialMediaActivitiesLabels(likesText: String(news.likes),
//                                       commentsText: String(news.comments),
//                                       repostsText: String(news.reposts),
//                                       viewsText: String(news.views))
        
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

extension PicNewsCell {
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        nameLabelFrame()
//        iconImageViewFrame()
//        articleImageView.frame = CGRect(origin: CGPoint(x: 0, y: 2 * insets + iconSide),
//                                        size: CGSize(width: bounds.width, height: 300.0))
//        socialMediaActivitiesLabelsFrames()
//        
//    }
//    
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
//    func nameLabelFrame() {
//        let labelSize = getLabelSizeShifted(text: nameLabel.text!, font: nameLabel.font)
//        let labelX = 2 * insets + iconSide
//        let labelY = insets + (iconSide - labelSize.height) / 2
//        let labelOrigin = CGPoint(x: labelX, y: labelY)
//        nameLabel.frame = CGRect(origin: labelOrigin, size: labelSize)
//    }
//    
//    func socialMediaActivitiesLabelsFrames() {
//        let width = (bounds.width - 5 * insets) / 4
//        let labelSize = CGSize(width: ceil(width), height: socialMediaActivityHeight)
//        let labelY = 3 * insets + iconSide + articleImageView.frame.height
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
//    func iconImageViewFrame() {
//        let size = CGSize(width: iconSide, height: iconSide)
//        let origin = CGPoint(x: insets, y: insets)
//        iconImageView.frame = CGRect(origin: origin, size: size)
//    }
//    
//    // Additional methods for configuring and recalculating frames for setup(...)
//    
//    func setNameLabel(text: String) {
//        nameLabel.text = text
//        nameLabelFrame()
//    }
//    
//    func setSocialMediaActivitiesLabels(likesText: String, commentsText: String, repostsText: String, viewsText: String) {
//        likesLabel.text = likesText
//        commentsLabel.text = commentsText
//        repostsLabel.text = repostsText
//        viewsLabel.text = viewsText
//        socialMediaActivitiesLabelsFrames()
//    }
}
