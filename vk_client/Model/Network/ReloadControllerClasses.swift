//
//  ReloadNewsController.swift
//  vk_client
//
//  Created by Leonid Kulikov on 07/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit

class ReloadNewsController: Operation {
    var vc: NewsViewController
    
    init(vc: NewsViewController) {
        self.vc = vc
    }
    
    override func main() {
        guard let parseNews = dependencies.first as? ParseNews else { return }
        
        vc.news = parseNews.outputNews
        vc.tableView.reloadData()
    }
}

class ReloadInternalGroupsController: Operation {
    var vc: InternalGroupsTableViewController
    
    init(vc: InternalGroupsTableViewController) {
        self.vc = vc
    }
    
    override func main() {
        guard let parseGroups = dependencies.first as? ParseGroups else { return }
        
        vc.groups = parseGroups.outputGroups
        vc.tableView.reloadData()
    }
}

class ReloadExternalGroupsController: Operation {
    var vc: ExternalGroupsTableViewController
    
    init(vc: ExternalGroupsTableViewController) {
        self.vc = vc
    }
    
    override func main() {
        guard let parseGroups = dependencies.first as? ParseGroups else { return }
        
        vc.groups = parseGroups.outputGroups
        vc.tableView.reloadData()
    }
}
