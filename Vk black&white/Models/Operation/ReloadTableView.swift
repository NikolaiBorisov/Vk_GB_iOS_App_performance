//
//  ReloadTableView.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 05.04.2021.
//

import Foundation
import RealmSwift

class ReloadTableView: Operation {
    
    var controller: MyFriendsTableController
    var friends: Results<User>?
    
    init(controller: MyFriendsTableController) {
        self.controller = controller
    }
    
    override func main() {
        guard (dependencies.first as? ParseFriends) != nil else { return }
        guard let realm = try? Realm() else { return }
        friends = realm.objects(User.self)
        controller.allFriends = friends
        controller.tableView.reloadData()
    }
}
