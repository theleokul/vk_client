//
//  Photo.swift
//  vk_client
//
//  Created by Leonid Kulikov on 01/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class Photo: Object {
    @objc dynamic var imageString: String = ""
    @objc dynamic var owner: Person?
    
    convenience init(json: JSON, owner: Person?) {
        self.init()
        self.imageString = json["photo_604"].stringValue
        self.owner = owner
    }
}







