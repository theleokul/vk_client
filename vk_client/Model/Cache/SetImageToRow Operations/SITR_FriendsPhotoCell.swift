//
//  FriendsPhotoCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 11/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

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
