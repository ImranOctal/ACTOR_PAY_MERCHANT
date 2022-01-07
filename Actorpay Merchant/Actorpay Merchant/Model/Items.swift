//
//  Items.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/12/21.
//

import Foundation
import SwiftyJSON

public class Items {
    public var id: String?
    public var productId : String?
    public var name : String?
    public var description : String?
    public var categoryId : String?
    public var subCategoryId : String?
    public var actualPrice : Double?
    public var dealPrice : Double?
    public var image : String?
    public var merchantId : String?
    public var merchantName : String?
    public var stockCount : Int?
    public var taxId : String?
    public var stockStatus : String?
    public var status : Bool?
    public var sgst : Double?
    public var cgst : Double?
    public var productTaxId : String?
    public var createdAt : String?
    
    init(json: JSON) {
        id = json["id"].string
        productId = json["productId"].string
        name = json["name"].string
        description = json["description"].string
        categoryId = json["categoryId"].string
        subCategoryId = json["subCategoryId"].string
        actualPrice = json["actualPrice"].double
        dealPrice = json["dealPrice"].double
        image = json["image"].string
        merchantId = json["merchantId"].string
        stockCount = json["stockCount"].int
        taxId = json["taxId"].string
        stockStatus = json["stockStatus"].string
        status = json["status"].bool
        sgst = json["sgst"].double
        cgst = json["cgst"].double
        productTaxId = json["productTaxId"].string
        createdAt = json["createdAt"].string
    }
}
