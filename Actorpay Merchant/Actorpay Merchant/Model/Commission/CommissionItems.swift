import Foundation
import SwiftyJSON

struct CommissionItems {
    
	let id : String?
	let createdAt : String?
	let updatedAt : String?
	let deleted : Bool?
	let actorCommissionAmt : Double?
	let commissionPercentage : Double?
	let productId : String?
	let orderNo : String?
	let merchantId : String?
	let merchantName : String?
	let productName : String?
	let merchantEarnings : Double?
	let quantity : Int?
	let settlementStatus : String?
	let orderStatus : String?
	let orderItemDTO : String?
	let active : Bool?

    init(json: JSON) {

        id = json["id"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        deleted = json["deleted"].bool
        actorCommissionAmt = json["actorCommissionAmt"].double
        commissionPercentage = json["commissionPercentage"].double
        productId = json["productId"].string
        orderNo = json["orderNo"].string
        merchantId = json["merchantId"].string
        merchantName = json["merchantName"].string
        productName = json["productName"].string
        merchantEarnings = json["merchantEarnings"].double
        quantity = json["quantity"].int
        settlementStatus = json["settlementStatus"].string
        orderStatus = json["orderStatus"].string
        orderItemDTO = json["orderItemDTO"].string
        active = json["active"].bool
	}

}
