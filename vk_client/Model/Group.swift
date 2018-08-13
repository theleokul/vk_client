//
//  Group.swift
//  vk_client
//
//  Created by Leonid Kulikov on 26/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Group: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var membersCount: Int = 0
    
    convenience init(json: JSON) {
        self.init()
        
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.image = json["photo_100"].stringValue
        self.membersCount = json["members_count"].intValue
    }
}
