//
//  DatabaseService.swift
//  vk_client
//
//  Created by Leonid Kulikov on 15/08/2018.
//  Copyright © 2018 Leonid Kulikov. All rights reserved.
//

import Foundation
import RealmSwift

class DatabaseService {
    
    static let shared: DatabaseService = DatabaseService()
    let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
    
    func getAllFriends() -> Results<Person> {
        return realm.objects(Person.self)
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
    
    func deletePersonAtIndex(_ index: Int) {
        let friends = getAllFriends()
        guard index >= 0 && index < friends.count else { return }
        
        let person = friends[index]
        do {
            try realm.write {
                realm.delete(person)
            }
        } catch {
            print("DatabaseService: deletePersonAtIndex, \(error)")
        }
    }
    
    func getPhotosFor(_ person: Person?) -> Results<Photo> {
        guard let person = person else { fatalError("DatabaseService getPhotosFor") }
        return realm.objects(Photo.self).filter("owner = %@", person)
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
    
    func getAllGroups() -> Results<Group> {
        return realm.objects(Group.self)
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
    
    func deleteGroupAtIndex(_ index: Int) {
        let groups = getAllGroups()
        guard index >= 0 && index < groups.count else { return }
        
        let group = groups[index]
        do {
            try realm.write {
                realm.delete(group)
            }
        } catch {
            print("DatabaseService: deletePersonAtIndex, \(error)")
        }
    }
    
    func addGroup(_ group: Group) {
        do {
            try realm.write {
                realm.add(group)
            }
        } catch {
            print("DatabaseService: addGroup, \(error)")
        }
    }
    
    func getAllNews() -> Results<News> {
        return realm.objects(News.self)
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
    
    private init() {}
}
