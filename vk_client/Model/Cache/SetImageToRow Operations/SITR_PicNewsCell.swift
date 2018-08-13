//
//  PicNewsCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 11/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class SetImageToRowWithPicNewsCell: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: PicNewsCell?
    
    init(cell: PicNewsCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImageIcon = dependencies.first as? GetCacheImage,
            let getCacheImageContent = dependencies[1] as? GetCacheImage,
            let icon = getCacheImageIcon.outputImage,
            let contentImage = getCacheImageContent.outputImage else { return }
        
//        let parity = contentImage.size.height/contentImage.size.width
//        cell.articleImageWidthConstraint.constant = tableView.bounds.width * parity
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.iconImageView.image = icon
            cell.articleImageView.image = contentImage
        } else if tableView.indexPath(for: cell) == nil {
            cell.iconImageView.image = icon
            cell.articleImageView.image = contentImage
        }
    }
}
