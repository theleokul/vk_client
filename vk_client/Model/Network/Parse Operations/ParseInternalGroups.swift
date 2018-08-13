//
//  ParseInternalGroups.swift
//  vk_client
//
//  Created by Leonid Kulikov on 11/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import Foundation
import SwiftyJSON

class ParseInternalGroups: Operation {
    
    override func main() {
        guard let getDataOperation = dependencies.first as? GetDataOperation, let data = getDataOperation.data else { return }
        
        do {
            let json = try JSON(data: data)
            let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
            VKService.shared.saveInternalGroupsToRealm(groups)
        } catch {
            print("ParseGroups: ", error)
        }
    }
    
}
