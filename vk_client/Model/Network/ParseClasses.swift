//
//  ParseNews.swift
//  vk_client
//
//  Created by Leonid Kulikov on 07/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParseNews: Operation {
    
    var outputNews: [News] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation, let data = getDataOperation.data else { return }
        
        do {
            let json = try JSON(data: data)
            let news: [News] = json["response"]["items"]
                               .arrayValue.map {
                                News(json: $0,
                                     jsonProfiles: json["response"]["profiles"].arrayValue,
                                     jsonGroups: json["response"]["groups"].arrayValue) }
            outputNews = news
        } catch {
            print("ParseNews: ", error)
        }
    }
  
}

class ParseGroups: Operation {
    
    var outputGroups: [Group] = []
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation, let data = getDataOperation.data else { return }
        
        do {
            let json = try JSON(data: data)
            let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
            outputGroups = groups
        } catch {
            print("ParseGroups: ", error)
        }
    }
    
}