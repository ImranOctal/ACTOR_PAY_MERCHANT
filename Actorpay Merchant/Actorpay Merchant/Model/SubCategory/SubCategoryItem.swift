//
//  SubCategoryItem.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/12/21.
//

import Foundation
import SwiftyJSON

struct SubCategoryItem {
    
	let id : String?
	let name : String?
	let description : String?
	let image : String?
	let categoryId : String?
	let categoryName : String?
	let active : Bool?
	let createdAt : String?

    init(json: JSON) {
        id = json["id"].string
        name = json["name"].string
        description = json["description"].string
        image = json["image"].string
        categoryId = json["categoryId"].string
        categoryName = json["categoryName"].string
        active = json["active"].bool
        createdAt = json["createdAt"].string
	}
}
