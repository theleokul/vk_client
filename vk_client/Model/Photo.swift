//
//  Photo.swift
//  vk_client
//
//  Created by Leonid Kulikov on 01/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Photo {
    let imageString: String?
    
    init(json: JSON) {
        let urlString = json["photo_604"].stringValue
        self.imageString = urlString
    }
}







