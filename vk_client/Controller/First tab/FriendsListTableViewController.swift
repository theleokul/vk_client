//
//  FriendsListTableViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 23/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class FriendsListTableViewController: UITableViewController {
    
    var friends: [Person] = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
        
        // Network
        friends = Array(VKService.shared.realm.objects(Person.self))
        VKService.shared.getFriends { [weak self] error in
            if let error = error {
                print("FriendsListTableViewController: \(error)")
                return
            }
            
            DispatchQueue.main.async {
                self?.friends = Array(VKService.shared.realm.objects(Person.self))
                self?.tableView.reloadData()
            }
        }
        
        // Customization
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = String(friends[indexPath.row].user_id)
            VKService.shared.deleteFriendWithID(id) { (error) in
                if let error = error {
                    print("Error while deleting freind: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.friends.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
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
