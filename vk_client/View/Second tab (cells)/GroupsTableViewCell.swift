//
//  InternalGroupsTableViewCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupsImageView: UIImageView!
    @IBOutlet weak var groupsLabel: UILabel!
    @IBOutlet weak var groupsMembersCount: UILabel!
    
    func setup(group: Group, indexPath: IndexPath, tableView: UITableView) {
        self.groupsLabel.text = group.name
        
        // Set image to groupsImageView
        setImageToView(group: group, indexPath: indexPath, tableView: tableView)
        
        self.groupsMembersCount.text = "Members: \(group.membersCount)"
        
        // Customization
        self.groupsImageView.layer.cornerRadius = 20
        self.groupsImageView.clipsToBounds = true
    }
    
    func setImageToView(group: Group, indexPath: IndexPath, tableView: UITableView) {
        let getCacheImage = GetCacheImage(url: group.image)
        let setImageToRow = SetImageToRowWithGroupCell(cell: self, indexPath: indexPath, tableView: tableView)
        setImageToRow.addDependency(getCacheImage)
        VKService.shared.networkQueue.addOperation(getCacheImage)
        OperationQueue.main.addOperation(setImageToRow)
    }
}
