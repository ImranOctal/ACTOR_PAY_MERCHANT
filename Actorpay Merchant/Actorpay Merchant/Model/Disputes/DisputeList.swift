//
//  DisputeList.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import Foundation
import SwiftyJSON

struct DisputeList {
    
    let totalPages : Int?
    let totalItems : Int?
    let items : Array<DisputeItem>?
    let pageNumber : Int?
    let pageSize : Int?

    init(json: JSON) {

        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ DisputeItem(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
        
    }
}
