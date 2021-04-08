//
//  PromiseFriends.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 08.04.2021.
//

import Foundation
import RealmSwift
import PromiseKit
import Alamofire

class PromiseFriends {
    
    static func freandPromise () -> Promise<[User]> {
        
        let params: Parameters = [
            "fields" : "photo_100",
        ]
        
        let request = AF.request("https://api.vk.com/method/" + "friends.get",  parameters: getBaseParameters(params))
        
        return Promise { resolver in
            request.responseData {
                response in
                switch response.result {
                case let .success(value): do {
                    do {
                        let friend =  try JSONDecoder().decode(FriendResponse.self, from: value).response.items
                        saveDataFriends(friend)
                    }
                    catch {
                        print(error)
                    }
                    }
                case let .failure(error): resolver.reject(error)
                }
            }
        }
    }
    
   
}

func saveDataFriends(_ friends: [User]) {
    do {
        let realm = try Realm()
        print(realm.configuration.fileURL as Any)
        let oldValue = realm.objects(User.self)
        realm.beginWrite()
        realm.delete(oldValue)
        realm.add(friends, update: .modified)
        try realm.commitWrite()
        
    } catch {
        print(error)
    }
}

private func getBaseParameters(_ params : Parameters) -> Parameters {
    var parameters = params
    parameters["access_token"] = Session.shared.token
    parameters["v"] = "5.103"
    return parameters
}
