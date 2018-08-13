//
//  ReloadInternalGroupsController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 11/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class ReloadInternalGroupsController: Operation {
    var vc: InternalGroupsTableViewController
    
    init(vc: InternalGroupsTableViewController) {
        self.vc = vc
    }
    
    override func main() {        
        vc.groups = Array(VKService.shared.realm.objects(Group.self))
        vc.tableView.reloadData()
    }
}
