//
//  Post.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 20.03.2021.
//

import Foundation
import SwiftyJSON

class Post {
    var date: Date
    var text: String
    var type: String
    var postID: Double
    var likesCount: Int
    var repostCount: Int
    var commentConut: Int
    
    init(_ json: JSON) {
        self.date = Date(timeIntervalSince1970: TimeInterval(json["date"].doubleValue))
        self.text = json["text"].stringValue
        self.type = json["type"].stringValue
        self.postID = json["post_id"].doubleValue
        self.likesCount = json["likes"]["count"].intValue
        self.repostCount = json["reposts"]["count"].intValue
        self.commentConut = json["comments"]["count"].intValue
    }
}
