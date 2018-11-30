//
//  GroupCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 11/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class SetImageToRowWithGroupCell: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: GroupsTableViewCell?
    
    init(cell: GroupsTableViewCell, indexPath: IndexPath, tableView: UITableView) {
        self.indexPath = indexPath
        self.tableView = tableView
        self.cell = cell
    }
    
    override func main() {
        guard let tableView = tableView,
            let cell = cell,
            let getCacheImage = dependencies.first as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.groupsImageView.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.groupsImageView.image = image
        }
    }
}
