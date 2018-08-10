//
//  SetImageToRow.swift
//  vk_client
//
//  Created by Leonid Kulikov on 10/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

enum CellType: String {
    case FriendsListTableViewCell = "FriendsListTableViewCell"
    case FriendsPhotoCollectionViewCell = "FriendsPhotoCollectionViewCell"
    case GroupsTableViewCell = "GroupsTableViewCell"
    case TextNewsCell = "TextNewsCell"
    case PicNewsCell = "PicNewsCell"
}

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

class SetImageToRowWithFriendsPhotoCell: Operation {
    
    private let indexPath: IndexPath
    private weak var collectionView: UICollectionView?
    private var cell: FriendsPhotoCollectionViewCell?
    
    init(cell: FriendsPhotoCollectionViewCell, indexPath: IndexPath, collectionView: UICollectionView) {
        self.indexPath = indexPath
        self.collectionView = collectionView
        self.cell = cell
    }
    
    override func main() {
        guard let collectionView = collectionView,
            let cell = cell,
            let getCacheImage = dependencies.first as? GetCacheImage,
            let image = getCacheImage.outputImage else { return }
        
        if let newIndexPath = collectionView.indexPath(for: cell), newIndexPath == indexPath {
            cell.friendsImageView.image = image
        } else if collectionView.indexPath(for: cell) == nil {
            cell.friendsImageView.image = image
        }
    }
}

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

class SetImageToRowWithTextNewsCell: Operation {
    
    private let indexPath: IndexPath
    private weak var tableView: UITableView?
    private var cell: TextNewsCell?
    
    init(cell: TextNewsCell, indexPath: IndexPath, tableView: UITableView) {
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
            cell.iconImageView.image = image
        } else if tableView.indexPath(for: cell) == nil {
            cell.iconImageView.image = image
        }
    }
}

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
        
        if let newIndexPath = tableView.indexPath(for: cell), newIndexPath == indexPath {
            cell.iconImageView.image = icon
            cell.articleImageView.image = contentImage
        } else if tableView.indexPath(for: cell) == nil {
            cell.iconImageView.image = icon
            cell.articleImageView.image = contentImage
        }
    }
}
