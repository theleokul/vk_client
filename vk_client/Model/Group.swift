//
//  Group.swift
//  vk_client
//
//  Created by Leonid Kulikov on 26/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import SwiftyJSON

class Group: Equatable {
    
    let id: String
    let name: String
    let image: URL?
    let membersCount: Int
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.image = URL(string: json["photo_100"].stringValue)
        self.membersCount = json["members_count"].intValue
    }
}
