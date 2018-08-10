//
//  InternalGroupsTableViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class InternalGroupsTableViewController: UITableViewController {
    
    var groups = [Group]()
    let queue: OperationQueue = {
        let queue = OperationQueue()
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Network
        VKService.shared.getGroupsFor(self)
//        VKService.shared.getGroups { (groups, error) in
//            if let groups = groups {
//                self.groups = groups
//                self.tableView.reloadData()
//            } else {
//                print(error?.localizedDescription ?? "" + "InternalGroupsTableViewController")
//            }
//        }
        
        // Customization
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InternalGroupCell", for: indexPath) as! GroupsTableViewCell

        let group = groups[indexPath.row]
        cell.setup(group: group, indexPath: indexPath, tableView: tableView, queue: queue)

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
                    self.groups.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }   
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? ExternalGroupsTableViewController else {
            return
        }
        
        controller.antiGroups = groups
    }
    
    @IBAction func unwindFromExternal(segue: UIStoryboardSegue) {
        if let externalVC = segue.source as? ExternalGroupsTableViewController,
            let index = externalVC.tableView.indexPathForSelectedRow?.row {

            let id = externalVC.groups[index].id
            VKService.shared.joinGroupWithID(id) { (error) in
                if let error = error {
                    print("Error while joining group: \(error.localizedDescription)")
                    return
                }
                DispatchQueue.main.async {
                    self.groups.append(externalVC.groups[index])
                    self.tableView.reloadData()
                }

            }
        
        }
    }

}











