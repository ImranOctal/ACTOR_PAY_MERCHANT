//
//  ProductList.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/12/21.
//

import Foundation
import SwiftyJSON

struct ProductList {
    
    let totalPages : Int?
    let totalItems : Int?
    let items : Array<Items>?
    let pageNumber : Int?
    let pageSize : Int?
    
    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ Items(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
    }
    
}
