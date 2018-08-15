//
//  FriendsPhotoCollectionViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsPhotoCollectionViewController: UICollectionViewController {

    var friend: Person?
    var photos: Results<Photo>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        
        // Calculating title for navigation bar
        if let barName = friend?.name {
            let barFirstName = barName.components(separatedBy: " ").first ?? "Friend's"
            title = "\(barFirstName)'s photos"
        }
        
        // Network
        guard let friend = friend else { return }
        VKService.shared.getPhotosForFriend(friend)
    }
    
    func pairTableAndRealm() {
        photos = DatabaseService.shared.getPhotosFor(friend)
        
        notificationToken = photos.observe({ [weak self] changes in
            guard let collectionView = self?.collectionView else { return }
            switch changes {
            case .initial:
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                collectionView.performBatchUpdates({
                    collectionView.insertItems(at: insertions.map { IndexPath(row: $0, section: 0) })
                    collectionView.deleteItems(at: deletions.map { IndexPath(row: $0, section: 0) })
                    collectionView.reloadItems(at: modifications.map { IndexPath(row: $0, section: 0) })
                }, completion: nil)
            case .error(let error):
                fatalError("Realm notification: \(error)")
            }
        })
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendsPhotoCell", for: indexPath) as! FriendsPhotoCollectionViewCell
    
        let photo = photos[indexPath.row]
        cell.setup(imageURLString: photo.imageString, indexPath: indexPath, collectionView: collectionView)
    
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
