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
    
    func getAllGroups() -> Results<Group> {
        return realm.objects(Group.self)
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
    
    private init() {}
}
