//
//  NetworkService.swift
//  vk_client
//
//  Created by Leonid Kulikov on 27/07/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

class VKService {
    
    static let shared = VKService()
    
    private var token: String = ""
    private var user_id: String = ""
    let networkQueue: OperationQueue = {
        let networkQueue = OperationQueue()
        networkQueue.qualityOfService = .userInitiated
        return networkQueue
    }()
    
    func getFriends() {
        
        let url = "https://api.vk.com/method/friends.get"
        let parameters: Parameters = [
            "user_id": user_id,
            "order": "hints",
            "count": 300,
            "fields": "photo_100, city, domain",
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let value = response.value else {
                fatalError("VkService getFriends(): \(String(describing: response.error))")
            }
            
            let json = JSON(value)
            let friends = json["response"]["items"].arrayValue.map { Person(json: $0) }
            DatabaseService.shared.saveFriendsToRealm(friends)
        }
    }
    
    func getPhotosForFriend(_ friend: Person) {
        
        let url = "https://api.vk.com/method/photos.get"
        let parameters: Parameters = [
            "owner_id": friend.user_id,
            "album_id": "wall",
            "rev": 0,
            "count": 40,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let value = response.value else {
                fatalError("VkService getPhotosForFriend(): \(String(describing: response.error))")
            }
            
            let json = JSON(value)
            let photos = json["response"]["items"].arrayValue.map { Photo(json: $0, owner: friend) }
            DatabaseService.shared.saveFriendsPhotosToRealm(photos, friend: friend)
        }
    }
    
    func deleteFriendWithID(_ id: String, completion: @escaping (Error?) -> Void) {
        let url = "https://api.vk.com/method/friends.delete"
        let parameters: Parameters = [
            "user_id": id,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let _ = response.value else {
                completion(response.error)
                return
            }
            completion(nil)
        }
    }
    
    
    func getInternalGroupsFor(_ vc: InternalGroupsTableViewController) {
        
        let url = "https://api.vk.com/method/groups.get"
        let parameters: Parameters = [
            "user_id": user_id,
            "extended": 1,
            "fields": "members_count",
            "count": 40,
            "access_token": token,
            "v": 5.80
        ]
        
        let request = Alamofire.request(url, parameters: parameters)
        
        let getGroupsOperation: GetDataOperation = {
            let getGroupsOperation = GetDataOperation(request: request)
            getGroupsOperation.qualityOfService = .userInitiated
            return getGroupsOperation
        }()
        networkQueue.addOperation(getGroupsOperation)
        
        let parseInternalGroups: ParseInternalGroups = {
            let parseGroups = ParseInternalGroups()
            parseGroups.qualityOfService = .userInitiated
            parseGroups.addDependency(getGroupsOperation)
            return parseGroups
        }()
        networkQueue.addOperation(parseInternalGroups)
        
    }
    
    func getExternalSearchGroups(q: String = "", completion: @escaping ([Group]?, Error?) -> Void) {
        
        let url = "https://api.vk.com/method/groups.search"
        let parameters: Parameters = [
            "q": q,
            "fields": "members_count",
            "sort": 1,
            "count": 40,
            "access_token": token,
            "v": 5.80
        ]

        Alamofire.request(url, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let value = response.value else {
                completion(nil, response.error)
                return
            }
            
            let json = JSON(value)
            let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
            completion(groups, nil)
        }
        
    }
    
    func joinGroupWithID(_ id: String, completion: @escaping (Error?) -> Void) {
        let url = "https://api.vk.com/method/groups.join"
        let parameters: Parameters = [
            "group_id": id,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let _ = response.value else {
                completion(response.error)
                return
            }
            
            completion(nil)
        }
    }
    
    func leaveGroupWithID(_ id: String, completion: @escaping (Error?) -> Void) {
        let url = "https://api.vk.com/method/groups.leave"
        let parameters: Parameters = [
            "group_id": id,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInitiated)) { response in
            guard let _ = response.value else {
                completion(response.error)
                return
            }
            
            completion(nil)
        }
    }
    
    func getNewsFeedFor(_ vc: NewsViewController) {
        
        let url = "https://api.vk.com/method/newsfeed.get"
        let parameters: Parameters = [
            "filters": "post, photo",
            "returned_banned": 0,
            "photo_sizes": 1,
            "count": 30,
            "access_token": token,
            "v": "5.80"
        ]
        let request = Alamofire.request(url, parameters: parameters)
        
        let getNewsOperation = GetDataOperation(request: request)
        getNewsOperation.qualityOfService = .userInitiated
        networkQueue.addOperation(getNewsOperation)
        
        let parseNews = ParseNews()
        parseNews.qualityOfService = .userInitiated
        parseNews.addDependency(getNewsOperation)
        networkQueue.addOperation(parseNews)
        
    }
    
    func setup(token: String, user_id: String) {
        self.token = token
        self.user_id = user_id
    }
    
    private init() {}
    
}











