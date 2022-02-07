import Foundation
import SwiftyJSON

struct OrderNotesDtos {
    
    let createdAt : String?
    let orderNoteId : String?
    let orderId : String?
    let orderNo : String?
    let orderNoteBy : String?
    let userId : String?
    let merchantId : String?
    let userType : String?
    let orderNoteDescription : String?
    let active : Bool?
    let orderStatus : String?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        orderNoteId = json["orderNoteId"].string
        orderId = json["orderId"].string
        orderNo = json["orderNo"].string
        orderNoteBy = json["orderNoteBy"].string
        userId = json["userId"].string
        merchantId = json["merchantId"].string
        userType = json["userType"].string
        orderNoteDescription = json["orderNoteDescription"].string
        active = json["active"].bool
        orderStatus = json["orderStatus"].string
        
	}

}
