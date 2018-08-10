//
//  FriendsPhotoCollectionViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class FriendsPhotoCollectionViewController: UICollectionViewController {

    var friend: Person?
    var photos = [Photo]()
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calculating title for navigation bar
        if let barName = friend?.name {
            let barFirstName = barName.components(separatedBy: " ").first ?? "Friend's"
            title = "\(barFirstName)'s photos"
        }
        
        // Network
        if let id = friend?.user_id {
            VKService.shared.getPhotosForFriendWithID(id) { (photos, error) in
                guard let photos = photos else {
                    print(error?.localizedDescription ?? "" + "FriendsPhotoCollectionViewController")
                    return
                }
                self.photos = photos
                self.collectionView?.reloadData()
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
    
        let photo = photos[indexPath.row]
        cell.setup(imageURLString: photo.imageString, indexPath: indexPath, collectionView: collectionView, queue: queue)
    
        return cell
    }

}

// MARK: CollectionView layout

extension FriendsPhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: (view.frame.width - 15)/2,
            height: (view.frame.width - 15)/2
        )
    }
    
}
