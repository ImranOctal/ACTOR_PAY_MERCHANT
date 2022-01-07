//
//  CategoryItems.swift
//  Actorpay Merchant
//
//  Created by iMac on 31/12/21.
//

import Foundation
import SwiftyJSON

struct CategoryItems {
    let id : String?
    let name : String?
    let description : String?
    let image : String?
    let status : Bool?
    let createdAt : String?
    
    init(json: JSON) {
        id = json["id"].string
        name = json["name"].string
        description = json["description"].string
        image = json["image"].string
        status = json["status"].bool
        createdAt = json["createdAt"].string
    }

}
