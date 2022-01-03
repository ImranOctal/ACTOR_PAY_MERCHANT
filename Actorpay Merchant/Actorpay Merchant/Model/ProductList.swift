//
//  ProductList.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/12/21.
//

import Foundation
import SwiftyJSON

public class ProductList {
    public var totalPages : Int?
    public var totalItems : Int?
    public var items : Array<Items>?
    public var pageNumber : Int?
    public var pageSize : Int?

    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ Items(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
    }
}
