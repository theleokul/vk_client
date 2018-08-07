//
//  Person.swift
//  vk_client
//
//  Created by Leonid Kulikov on 26/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import SwiftyJSON

class Person {
    let user_id: Int
    let name: String
    let profileImageURL: URL?
    
    init(json: JSON) {
        self.user_id = json["id"].intValue
        self.name = json["first_name"].stringValue + " " + json["last_name"].stringValue
        self.profileImageURL = URL(string: json["photo_100"].stringValue)
    }  
    
}
