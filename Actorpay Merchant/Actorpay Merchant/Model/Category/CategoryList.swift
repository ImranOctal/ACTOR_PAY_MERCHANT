//
//  CategoryList.swift
//  Actorpay Merchant
//
//  Created by iMac on 31/12/21.
//

import Foundation
import SwiftyJSON


struct CategoryList {
    
    let totalPages : Int?
    let totalItems : Int?
    let items : Array<CategoryItems>?
    let pageNumber : Int?
    let pageSize : Int?
    
    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ CategoryItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
    }
    
}
