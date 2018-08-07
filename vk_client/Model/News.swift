//
//  News.swift
//  vk_client
//
//  Created by Leonid Kulikov on 03/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Kingfisher

class News {
    
    let iconURLString: String
    let name: String
    let article: String
    let articleImageURLString: String
    let likes: Int
    let comments: Int
    let reposts: Int
    let views: Int
    
    init(json: JSON, jsonProfiles: [JSON], jsonGroups: [JSON]) {
        self.article = json["text"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.comments = json["comments"]["count"].intValue
        self.reposts = json["reposts"]["count"].intValue
        self.views = json["views"]["count"].intValue
        
        
        // Get icon and name
        let indexProfile = jsonProfiles.index { (jsonProfile) -> Bool in
            return jsonProfile["id"].intValue == json["source_id"].intValue
        }
        if let index = indexProfile {
            self.name = jsonProfiles[index]["first_name"].stringValue + " " + jsonProfiles[index]["last_name"].stringValue
            self.iconURLString = jsonProfiles[index]["photo_100"].stringValue
        } else {
            let indexGroup = jsonGroups.index { (jsonGroup) -> Bool in
                return jsonGroup["id"].intValue == abs(json["source_id"].intValue)
            }
            if let index = indexGroup {
                self.name = jsonGroups[index]["name"].stringValue
                self.iconURLString = jsonGroups[index]["photo_100"].stringValue
            } else {
                self.name = ""
                self.iconURLString = ""
            }
        }
        
        // Get article's photo
        let attachments = json["attachments"].arrayValue
        
        let photoIndex = attachments.index { $0["type"].stringValue == "photo" }

        if let photoIndex = photoIndex {
            let photoSizes = attachments[photoIndex]["photo"]["sizes"].arrayValue
            let xSizeIndex = photoSizes.index { $0["type"].stringValue == "x" }
            if let xSizeIndex = xSizeIndex {
                self.articleImageURLString = photoSizes[xSizeIndex]["src"].stringValue
            } else { self.articleImageURLString = "" }
            
        } else { self.articleImageURLString = "" }

    }
}
