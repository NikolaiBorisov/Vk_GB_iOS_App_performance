//
//  FriendsService.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 05.04.2021.
//

import Foundation
import Alamofire

class FriendService {
    
    static func getFriends(controller: MyFriendsTableController) {
        let params: Parameters = [
            "fields": "photo_100"
        ]
        let request = AF.request("https://api.vk.com/method/friends.get", parameters: getBaseParameters(params))
        let queue = OperationQueue()
        let getData = GetOperationData(request: request)
        queue.addOperation(getData)
        let parse = ParseFriends()
        parse.addDependency(getData)
        queue.addOperation(parse)
        let reload = ReloadTableView(controller: controller)
        reload.addDependency(parse)
        OperationQueue.main.addOperation(reload)
    }
}

private func getBaseParameters(_ params: Parameters) -> Parameters {
    let nW = NetworkConstants()
    var parameters = params
    parameters["access_token"] = Session.shared.token
    parameters["v"] = nW.versionAPI
    return parameters
}
