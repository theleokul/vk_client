//
//  Person.swift
//  vk_client
//
//  Created by Leonid Kulikov on 26/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Person: Object {
    @objc dynamic var user_id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var profileImageURLString: String = ""
    
    convenience init(json: JSON) {
        self.init()
        
        self.user_id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.profileImageURLString = json["photo_100"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "user_id"
    }
    
    var toAnyObject: Any {
        return [
            "name": name,
            "profileImg": profileImageURLString
        ]
    }
    
}
