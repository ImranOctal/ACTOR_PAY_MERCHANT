//
//  FilterProductViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 25/01/22.
//

import Foundation
import SwiftyJSON

struct RoleItems {
	let createdAt : String?
	let updatedAt : String?
	let id : String?
	let name : String?
	let description : String?
	let active : Bool?
	let screenAccessPermission : [ScreenAccessPermission]?

    init(json: JSON) {
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        id = json["id"].string
        name = json["name"].string
        description = json["description"].string
        active = json["active"].bool
        screenAccessPermission = json["screenAccessPermission"].arrayValue.map{ ScreenAccessPermission(json: $0)}
	}
}
