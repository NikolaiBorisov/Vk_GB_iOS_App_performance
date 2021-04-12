//
//  Attachment.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 24.03.2021.
//

import Foundation
import SwiftyJSON

class Attachment {
    var type: String
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
    }
}
