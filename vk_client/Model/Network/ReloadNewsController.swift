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
