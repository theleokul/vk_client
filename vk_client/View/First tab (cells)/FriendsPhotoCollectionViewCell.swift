//
//  FriendsPhotoCollectionViewCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 23/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class FriendsPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendsImageView: UIImageView!

    func setup(imageURLString: String, indexPath: IndexPath, collectionView: UICollectionView) {
        setImageToView(imageURLString: imageURLString, indexPath: indexPath, collectionView: collectionView)
    }
    
    func setImageToView(imageURLString: String, indexPath: IndexPath, collectionView: UICollectionView) {
        let getCacheImage = GetCacheImage(url: imageURLString)
        let setImageToRow = SetImageToRowWithFriendsPhotoCell(cell: self, indexPath: indexPath, collectionView: collectionView)
        setImageToRow.addDependency(getCacheImage)
        VKService.shared.networkQueue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
    }
}
