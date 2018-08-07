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

class VKService {
    
    static let shared = VKService()
    
    private var token: String = ""
    private var user_id: String = ""
    
    func getFriends(completion: @escaping ([Person]?, Error?) -> Void) {
        
        let url = "https://api.vk.com/method/friends.get"
        let parameters: Parameters = [
            "user_id": user_id,
            "order": "hints",
            //"count": 40,
            "fields": "photo_100, city, domain",
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let value = response.value else {
                completion(nil, response.error)
                return
            }
            
            let json = JSON(value)
            let friends = json["response"]["items"].arrayValue.map { Person(json: $0) }
            
            completion(friends, nil)
        }
    }
    
    func getPhotosForFriendWithID(_ friendsID: Int, completion: @escaping ([Photo]?, Error?) -> Void) {
        
        let url = "https://api.vk.com/method/photos.get"
        let parameters: Parameters = [
            "owner_id": friendsID,
            "album_id": "wall",
            "rev": 0,
            //"count": 40,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let value = response.value else {
                completion(nil, response.error)
                return
            }
            
            let json = JSON(value)
            let photos = json["response"]["items"].arrayValue.map { Photo(json: $0) }
            completion(photos, nil)
        }
    }
    
    func deleteFriendWithID(_ id: String, completion: @escaping (Error?) -> Void) {
        let url = "https://api.vk.com/method/friends.delete"
        let parameters: Parameters = [
            "user_id": id,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            guard let _ = response.value else {
                completion(response.error)
                return
            }
            completion(nil)
        }
    }
    
    
    func getGroups(completion: @escaping ([Group]?, Error?) -> Void) {
        
        let url = "https://api.vk.com/method/groups.get"
        let parameters: Parameters = [
            "user_id": user_id,
            "extended": 1,
            "fields": "members_count",
            //"count": 40,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
            guard let value = response.value else {
                completion(nil, response.error)
                return
            }
            
            let json = JSON(value)
            let groups = json["response"]["items"].arrayValue.map { Group(json: $0) }
            completion(groups, nil)
        }
    }
    
    func getSearchGroups(q: String = "", completion: @escaping ([Group]?, Error?) -> Void) {
        
        let url = "https://api.vk.com/method/groups.search"
        let parameters: Parameters = [
            "q": q,
            "fields": "members_count",
            "sort": 1,
            //"count": 40,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON { response in
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
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
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
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            guard let _ = response.value else {
                completion(response.error)
                return
            }
            
            completion(nil)
        }
    }
    
    private let networkQueue = OperationQueue()
    
    func getNewsFeedFor(_ vc: NewsViewController) {
        
        let url = "https://api.vk.com/method/newsfeed.get"
        let parameters: Parameters = [
            "filters": "post, photo",
            "access_token": token,
            "v": 5.80
        ]
        let request = Alamofire.request(url, parameters: parameters)
        
        let getNewsOperation = GetDataOperation(request: request)
        getNewsOperation.qualityOfService = .userInteractive
        networkQueue.addOperation(getNewsOperation)
        
        let parseNews = ParseNews()
        parseNews.qualityOfService = .userInteractive
        parseNews.addDependency(getNewsOperation)
        networkQueue.addOperation(parseNews)
        
        let reloadNewsController = ReloadNewsController(vc: vc)
        reloadNewsController.addDependency(parseNews)
        OperationQueue.main.addOperation(reloadNewsController)
        
    }
    
    func setup(token: String, user_id: String) {
        self.token = token
        self.user_id = user_id
    }
    
    private init() {}
    
}











