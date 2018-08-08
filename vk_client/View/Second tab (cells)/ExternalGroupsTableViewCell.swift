//
//  GroupsTableViewCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class ExternalGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    func setup(group: Group) {
        self.groupNameLabel.text = group.name
        //self.groupImageView.image = group.image
        //self.membersLabel.text = String(group.members)
    }
}
