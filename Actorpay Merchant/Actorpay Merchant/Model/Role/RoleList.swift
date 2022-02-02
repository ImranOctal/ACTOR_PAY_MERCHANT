//
//  FilterProductViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 25/01/22.
//

import Foundation
import SwiftyJSON

var roleList: RoleList?
var roleItems: [RoleItems] = []
var roleListPage = 0
var roleListTotalCount = 5

struct RoleList {
	let totalPages : Int?
	let totalItems : Int?
	let items : [RoleItems]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ RoleItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
    }

}
