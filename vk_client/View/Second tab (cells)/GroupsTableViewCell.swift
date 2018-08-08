//
//  InternalGroupsTableViewCell.swift
//  vk_client
//
//  Created by Leonid Kulikov on 24/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import Kingfisher

class GroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupsImageView: UIImageView!
    @IBOutlet weak var groupsLabel: UILabel!
    @IBOutlet weak var groupsMembersCount: UILabel!
    
    func setup(group: Group) {
        self.groupsLabel.text = group.name
        self.groupsImageView.kf.setImage(with: group.image)
        self.groupsMembersCount.text = "Members: \(group.membersCount)"
        
        // Customization
        self.groupsImageView.layer.cornerRadius = 20
        self.groupsImageView.clipsToBounds = true
    }
}
