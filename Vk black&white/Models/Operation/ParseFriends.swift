//
//  ParseFriends.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 05.04.2021.
//

import Foundation
import RealmSwift

class ParseFriends: Operation {
    
    override func main() {
        guard let operation = dependencies.first as? GetOperationData,
              let data = operation.data  else { return }
        
        //let dataFriends = try? JSONDecoder().decode(FriendsSections.self, from: data).responce.items
        //ParseFriends.self.saveDataFriends(dataFriends!)
    }
    
    static func saveDataFriends(_ friends: [User]) {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL!)
            let oldValue = realm.objects(User.self)
            realm.beginWrite()
            realm.delete(oldValue)
            realm.add(friends, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
}
