import Foundation
import SwiftyJSON

struct OrderItems {
    
	let orderId : String?
	let orderNo : String?
	let totalQuantity : Int?
	let totalPrice : Double?
	let totalSgst : Double?
	let totalCgst : Double?
	let customer : Customer?
	let merchantId : String?
	let orderStatus : String?
	let orderItemDtos : [OrderItemDtos]?
	let createdAt : String?
	let totalTaxableValue : Double?

    init(json: JSON) {

        orderId = json["orderId"].string
        orderNo = json["orderNo"].string
        totalQuantity = json["totalQuantity"].int
        totalPrice = json["totalPrice"].double
        totalSgst = json["totalSgst"].double
        totalCgst = json["totalCgst"].double
		customer = Customer(json: json["customer"])
        merchantId = json["merchantId"].string
        orderStatus = json["orderStatus"].string
        orderItemDtos = json["orderItemDtos"].arrayValue.map{ OrderItemDtos(json: $0)}
        createdAt = json["createdAt"].string
        totalTaxableValue = json["totalTaxableValue"].double
	}

}
