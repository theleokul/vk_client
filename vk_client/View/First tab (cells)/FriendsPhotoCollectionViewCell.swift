//
//  FriendsPhotoCollectionViewCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 23/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import Kingfisher

class FriendsPhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendsImageView: UIImageView!

    
    var imageString: String? {
        didSet {
            if let imageString = imageString, let url = URL(string: imageString) {
                friendsImageView.kf.setImage(with: url)
            } else {
                friendsImageView.image = nil
                friendsImageView.kf.cancelDownloadTask()
            }
        }
    }
    
    // CollectionView reuse her cells, so I just clean it up before it displays another picture
    override func prepareForReuse() {
        super.prepareForReuse()
        imageString = nil
    }
}
