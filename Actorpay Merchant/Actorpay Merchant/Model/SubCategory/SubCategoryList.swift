//
//  SubCategoryList.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/12/21.
//

import Foundation
import SwiftyJSON

struct SubCategoryList {
    
	let totalPages : Int?
	let totalItems : Int?
	let items : [SubCategoryItem]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ SubCategoryItem(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
	}

}
