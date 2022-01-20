import Foundation
import SwiftyJSON


struct OrderItemDtos {
    
	let createdAt : String?
	let deleted : Bool?
	let productId : String?
    let productName : String?
	let productPrice : Double?
	let productQty : Int?
	let productSgst : Double?
	let productCgst : Double?
	let merchantId : String?
	let totalPrice : Double?
	let shippingCharge : Int?
	let taxPercentage : Double?
	let taxableValue : Double?
	let categoryId : String?
	let subcategoryId : String?
	let image : String?
	let merchantName : String?
	let active : Bool?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        deleted = json["deleted"].bool
        productId = json["productId"].string
        productName = json["productName"].string
        productPrice = json["productPrice"].double
        productQty = json["productQty"].int
        productSgst = json["productSgst"].double
        productCgst = json["productCgst"].double
        merchantId = json["merchantId"].string
        totalPrice = json["totalPrice"].double
        shippingCharge = json["shippingCharge"].int
        taxPercentage = json["taxPercentage"].double
        taxableValue = json["taxableValue"].double
        categoryId = json["categoryId"].string
        subcategoryId = json["subcategoryId"].string
        image = json["image"].string
        merchantName = json["merchantName"].string
        active = json["active"].bool
	}

}
