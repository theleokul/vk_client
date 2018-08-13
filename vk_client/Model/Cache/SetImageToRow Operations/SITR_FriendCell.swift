//
//  SetImageToRow.swift
//  vk_client
//
//  Created by Leonid Kulikov on 10/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class SetImageToRowWithFriendCell: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: FriendsListTableViewCell?
    
    init(cell: FriendsListTableViewCell, indexPath: IndexPath, tableView: UITableView) {
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
            cell.friendsImageView.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.friendsImageView.image = image
        }
    }
}
