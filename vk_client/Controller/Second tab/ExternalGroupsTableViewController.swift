//
//  ExternalGroupsTableViewController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class ExternalGroupsTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var groups: [Group] = [Group]()
    
    // List of groups which are already subscribed by user
    var antiGroups: [Group]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customization
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExternalGroupCell", for: indexPath) as! GroupsTableViewCell

        let group = groups[indexPath.row]
        cell.setup(group: group, indexPath: indexPath, tableView: tableView)

        return cell
    }
}

extension ExternalGroupsTableViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard !searchText.isEmpty else {
            groups = [Group]()
            tableView.reloadData()
            return
        }
        
        VKService.shared.getExternalSearchGroups(q: searchText) { (groups, error) in
            if let groups = groups {
                
                self.groups = groups
                
                DispatchQueue.main.async {
                    self.removeSubscribedGroups()
                    self.tableView.reloadData()
                }
            } else {
                print(error?.localizedDescription ?? "" + "ExternalGroupsTableViewController: UISearchBarDelegate")
            }
        }
    }
    
    func removeSubscribedGroups() {
        guard let antiGroups = antiGroups else { return }
        for i in 0..<antiGroups.count {
            if let index = groups.index(where: { Int($0.id) == Int(antiGroups[i].id) } ) {
                groups.remove(at: index)
            }
        }
    }
    
}
















