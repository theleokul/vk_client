//
//  FriendsListTableViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 23/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import RealmSwift

class FriendsListTableViewController: UITableViewController {
    
    var friends: Results<Person>!
    var notificationToken: NotificationToken?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        pairTableAndRealm()
        
        // Network
        VKService.shared.getFriends()
        
        // Customization
        tableView.tableFooterView = UIView()
    }
    
    func pairTableAndRealm() {
        
        friends = DatabaseService.shared.getAllFriends()
        
        notificationToken = friends.observe({ [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
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
        return friends.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendCell", for: indexPath) as! FriendsListTableViewCell

        let person = friends[indexPath.row]
        cell.setup(person: person, indexPath: indexPath, tableView: tableView)

        return cell
    }
    
    // MARK: - Table view editing

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = String(friends[indexPath.row].user_id)
            VKService.shared.deleteFriendWithID(id) { (error) in
                if let error = error {
                    print("Error while deleting freind: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    DatabaseService.shared.deletePersonAtIndex(indexPath.row)
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photosVC = segue.destination as? FriendsPhotoCollectionViewController
        
        if let controller = photosVC, let row = tableView.indexPathForSelectedRow?.row {
            let friend = friends[row]
            controller.friend = friend
        }
    }
    
}
