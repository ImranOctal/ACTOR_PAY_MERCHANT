import Foundation
import SwiftyJSON

struct OrderNotesDtos {
    
	let createdAt : String?
	let orderNoteBy : String?
	let userId : String?
	let userType : String?
	let orderStatus : String?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        orderNoteBy = json["orderNoteBy"].string
        userId = json["userId"].string
        userType = json["userType"].string
        orderStatus = json["orderStatus"].string
	}

}
