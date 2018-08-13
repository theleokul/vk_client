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
        networkQueue.qualityOfService = .userInteractive
        return networkQueue
    }()
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    func getFriends(completion: @escaping (Error?) -> Void) {
        
        let url = "https://api.vk.com/method/friends.get"
        let parameters: Parameters = [
            "user_id": user_id,
            "order": "hints",
            "count": 300,
            "fields": "photo_100, city, domain",
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
            guard let value = response.value else {
                completion(response.error)
                return
            }
            
            let json = JSON(value)
            let friends = json["response"]["items"].arrayValue.map { Person(json: $0) }
            self.saveFriendsToRealm(friends)
            
            completion(nil)
        }
    }
    
    func saveFriendsToRealm(_ friends: [Person]) {
        DispatchQueue.main.async {
            do {
                try self.realm.write {
                    self.realm.add(friends, update: true)
                }
            } catch {
                print("VkService.shared.saveFriendsToRealm: \(error)")
            }
        }
    }
    
    func getPhotosForFriend(_ friend: Person, completion: @escaping (Error?) -> Void) {
        
        let url = "https://api.vk.com/method/photos.get"
        let parameters: Parameters = [
            "owner_id": friend.user_id,
            "album_id": "wall",
            "rev": 0,
            "count": 40,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
            guard let value = response.value else {
                completion(response.error)
                return
            }
            
            let json = JSON(value)
            let photos = json["response"]["items"].arrayValue.map { Photo(json: $0, owner: friend) }
            self.saveFriendsPhotosToRealm(photos, friend: friend)
            
            completion(nil)
        }
    }
    
    func saveFriendsPhotosToRealm(_ photos: [Photo], friend: Person) {
        DispatchQueue.main.async {
            let oldPhotos = self.realm.objects(Photo.self).filter("owner = %@", friend)
            
            do {
                try self.realm.write {
                    self.realm.delete(oldPhotos)
                    self.realm.add(photos)
                }
            } catch {
                print("VkService.shared.saveFriendsPhotosToRealm: \(error)")
            }
        }
    }
    
    func deleteFriendWithID(_ id: String, completion: @escaping (Error?) -> Void) {
        let url = "https://api.vk.com/method/friends.delete"
        let parameters: Parameters = [
            "user_id": id,
            "access_token": token,
            "v": 5.80
        ]
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
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
            getGroupsOperation.qualityOfService = .userInteractive
            return getGroupsOperation
        }()
        networkQueue.addOperation(getGroupsOperation)
        
        let parseInternalGroups: ParseInternalGroups = {
            let parseGroups = ParseInternalGroups()
            parseGroups.qualityOfService = .userInteractive
            parseGroups.addDependency(getGroupsOperation)
            return parseGroups
        }()
        networkQueue.addOperation(parseInternalGroups)
        
        let reloadInternalGroupController = ReloadInternalGroupsController(vc: vc)
        reloadInternalGroupController.addDependency(parseInternalGroups)
        OperationQueue.main.addOperation(reloadInternalGroupController)
        
    }
    
    func saveInternalGroupsToRealm(_ groups: [Group]) {
        DispatchQueue.main.async {
            let oldGroups = self.realm.objects(Group.self)
            
            do {
                try self.realm.write {
                    self.realm.delete(oldGroups)
                    self.realm.add(groups)
                }
            } catch {
                print("VkService.shared.saveGroupsToRealm: \(error)")
            }
        }
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

        Alamofire.request(url, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
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
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
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
        
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON(queue: DispatchQueue.global(qos: .userInteractive)) { response in
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
            "filters": "post",
            "photo_sizes": 1,
            "count": 30,
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
    
    func saveNewsToRealm(_ news: [News]) {
        DispatchQueue.main.async {
            let oldNews = self.realm.objects(News.self)
            
            do {
                try self.realm.write {
                    self.realm.delete(oldNews)
                    self.realm.add(news)
                }
            } catch {
                print("VkService.shared.saveNewsToRealm: \(error)")
            }
        }
    }
    
    func setup(token: String, user_id: String) {
        self.token = token
        self.user_id = user_id
    }
    
    private init() {}
    
}











