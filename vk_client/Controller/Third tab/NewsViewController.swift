//
//  NewsViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 31/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import RealmSwift

enum FontsForCells: CGFloat {
    case header = 24.0
    case regular = 20.0
}

class NewsViewController: UITableViewController {

    var news: Results<News>!
    var preparedFramesForEachCell: [NewsFramesPack] = []
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        
        // Network
        VKService.shared.getNewsFeedFor(self)
        
        // Customization
        tableView.tableFooterView = UIView()
        
    }
    
    func pairTableAndRealm() {
        
        news = DatabaseService.shared.getAllNews()
        prepareFrames()
        
        notificationToken = news.observe({ [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                
                // Before updating tableView, we should update our frames for cells according the new data
                //self?.prepareFrames() // This is a short but more heavy way to do it
                // Fast and simple, I hope...
                var delSnapshot = deletions
                while !delSnapshot.isEmpty {
                    self?.preparedFramesForEachCell.remove(at: delSnapshot.removeLast())
                }
                self?.prepareFrames(rows: modifications)
                for i in insertions {
                    self?.preparedFramesForEachCell.insert(NewsFramesPack(), at: i)
                }
                self?.prepareFrames(rows: insertions)
                // End of updating frames, now we can start to update our tableView

                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .fade)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .fade)
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                                     with: .fade)
                tableView.endUpdates()
            case .error(let error):
                fatalError("Realm notification: \(error)")
            }
        })
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
            cell.setup(news: oneNews, indexPath: indexPath, tableView: tableView,
                       framesPack: preparedFramesForEachCell[index])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PicNewsCell", for: indexPath) as! PicNewsCell
            cell.setup(news: oneNews, indexPath: indexPath, tableView: tableView,
                       framesPack: preparedFramesForEachCell[index])
            return cell
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return preparedFramesForEachCell[indexPath.row].rowHeight
    }
    
}

// MARK: - Prepare frames for cells

extension NewsViewController {
    
    func prepareFrames() {
        preparedFramesForEachCell = Array(repeating: NewsFramesPack(), count: news.count)
        var iterator: Int = -1
        let arrayWithIndexes: [Int] = news.map {_ in
            iterator += 1
            return iterator
        }
        prepareFrames(rows: arrayWithIndexes)
    }

    func prepareFrames(rows: [Int]) {
        
        for i in rows {
            
            let name: CGRect = nameLabelFrame(text: news[i].name)
            let icon: CGRect = iconImageViewFrame()
            
            if news[i].articleImageURLString == "" {
                let article: CGRect = articleLabelFrame(text: news[i].article)
                let (likes, comments, reposts, views) = socialMediaActivitiesLabelsFrames(articleHeight: article.size.height)
                
                preparedFramesForEachCell[i] = NewsFramesPack(nameFrame: name,
                                                              iconFrame: icon,
                                                              articleOrContentImageFrame: article,
                                                              likesFrame: likes,
                                                              commentsFrame: comments,
                                                              repostsFrame: reposts,
                                                              viewsFrame: views)
            } else {
                let articleImage: CGRect = articleImageFrame(width: news[i].articleImageWidth,
                                                             height: news[i].articleImageHeight)
                let (likes, comments, reposts, views) = socialMediaActivitiesLabelsFrames(articleHeight: articleImage.size.height)
                
                preparedFramesForEachCell[i] = NewsFramesPack(nameFrame: name,
                                                              iconFrame: icon,
                                                              articleOrContentImageFrame: articleImage,
                                                              likesFrame: likes,
                                                              commentsFrame: comments,
                                                              repostsFrame: reposts,
                                                              viewsFrame: views)
            }
        }
    }
    
    func getLabelSizeShifted(text: String, font: UIFont) -> CGSize {
        
        let maxWidth = tableView.bounds.width - (3 * NewsFramesPack.insets + NewsFramesPack.iconSide)
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .truncatesLastVisibleLine,
                                     attributes: [NSAttributedStringKey.font : font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func getLabelSize(text: String, font: UIFont) -> CGSize {
        
        let maxWidth = tableView.bounds.width - 2 * NewsFramesPack.insets
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedStringKey.font : font],
                                     context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func nameLabelFrame(text: String) -> CGRect {
        let labelSize = getLabelSizeShifted(text: text,
                                            font: UIFont.systemFont(ofSize: FontsForCells.header.rawValue,
                                            weight: .semibold))
        let labelX = 2 * NewsFramesPack.insets + NewsFramesPack.iconSide
        let labelY = NewsFramesPack.insets + (NewsFramesPack.iconSide - labelSize.height) / 2
        let labelOrigin = CGPoint(x: labelX, y: labelY)
        return CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func iconImageViewFrame() -> CGRect {
        let size = CGSize(width: NewsFramesPack.iconSide, height: NewsFramesPack.iconSide)
        let origin = CGPoint(x: NewsFramesPack.insets, y: NewsFramesPack.insets)
        return CGRect(origin: origin, size: size)
    }
    
    func articleLabelFrame(text: String) -> CGRect {
        let labelSize = getLabelSize(text: text, font: UIFont.systemFont(ofSize: FontsForCells.regular.rawValue, weight: .regular))
        let labelX = NewsFramesPack.insets
        let labelY = 2 * NewsFramesPack.insets + NewsFramesPack.iconSide
        let labelOrigin = CGPoint(x: labelX, y: labelY)
        return CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func socialMediaActivitiesLabelsFrames(articleHeight: CGFloat) -> (CGRect, CGRect, CGRect, CGRect) {
        let width = (tableView.bounds.width - 5 * NewsFramesPack.insets) / 4
        let labelSize = CGSize(width: ceil(width), height: NewsFramesPack.socialMediaActivityHeight)
        let labelY = 3 * NewsFramesPack.insets + NewsFramesPack.iconSide + articleHeight
        let likesOrigin = CGPoint(x: NewsFramesPack.insets, y: labelY)
        let commentsOrigin = CGPoint(x: 2 * NewsFramesPack.insets + width, y: labelY)
        let repostsOrigin = CGPoint(x: 3 * NewsFramesPack.insets + 2 * width, y: labelY)
        let viewsOrigin = CGPoint(x: 4 * NewsFramesPack.insets + 3 * width, y: labelY)
        
        return (CGRect(origin: likesOrigin, size: labelSize),
                CGRect(origin: commentsOrigin, size: labelSize),
                CGRect(origin: repostsOrigin, size: labelSize),
                CGRect(origin: viewsOrigin, size: labelSize))
    }
    
    func getImageViewSize(width: Int, height: Int) -> CGSize {
        let parity = CGFloat( Float(height) / Float(width) )
        let imageWidth: CGFloat = tableView.bounds.width
        let imageHeight: CGFloat = imageWidth * parity
        return CGSize(width: ceil(imageWidth), height: ceil(imageHeight))
    }
    
    func articleImageFrame(width: Int, height: Int) -> CGRect {
        let imageViewSize = getImageViewSize(width: width, height: height)
        let imageViewY = 2 * NewsFramesPack.insets + NewsFramesPack.iconSide
        let imageViewOrigin = CGPoint(x: 0.0, y: imageViewY)
        return CGRect(origin: imageViewOrigin, size: imageViewSize)
    }

}






