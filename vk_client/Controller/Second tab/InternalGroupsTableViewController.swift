//
//  InternalGroupsTableViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import RealmSwift

class InternalGroupsTableViewController: UITableViewController {
    
    var groups: Results<Group>!
    var notificationToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pairTableAndRealm()
        
        // Network
        VKService.shared.getInternalGroupsFor(self)
        
        // Customization
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }
    
    func pairTableAndRealm() {
        
        groups = DatabaseService.shared.getAllGroups()
        
        notificationToken = groups.observe({ [weak self] changes in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("Realm notification: \(error)")
            }
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InternalGroupCell", for: indexPath) as! GroupsTableViewCell

        let group = groups[indexPath.row]
        cell.setup(group: group, indexPath: indexPath, tableView: tableView)

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let id = groups[indexPath.row].id
            VKService.shared.leaveGroupWithID(id) { (error) in
                if let error = error {
                    print("Error while joining group: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    DatabaseService.shared.deleteGroupAtIndex(indexPath.row)
                }
            }
        }   
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let externalVC = segue.destination as? ExternalGroupsTableViewController else {
            return
        }
        
        externalVC.antiGroups = Array(groups)
    }
    
    @IBAction func unwindFromExternal(segue: UIStoryboardSegue) {
        guard let externalVC = segue.source as? ExternalGroupsTableViewController,
            let index = externalVC.tableView.indexPathForSelectedRow?.row  else { return }

        let id = externalVC.groups[index].id
        VKService.shared.joinGroupWithID(id) { (error) in
            if let error = error {
                print("Error while joining group: \(error.localizedDescription)")
                return
            }
            DispatchQueue.main.async {
                DatabaseService.shared.addGroup(externalVC.groups[index])
            }
        }
        
    }

}











