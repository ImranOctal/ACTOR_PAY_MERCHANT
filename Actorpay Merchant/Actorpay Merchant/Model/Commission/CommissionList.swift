import Foundation
import SwiftyJSON

struct CommissionList {
    
	let totalPages : Int?
	let totalItems : Int?
	let items : [CommissionItems]?
	let pageNumber : Int?
	let pageSize : Int?
	let merchantSettledTotal : String?
	let merchantPendingTotal : String?
	let merchantCancelledTotal : String?
	let adminSettledTotal : String?
	let adminPendingTotal : String?
	let adminCancelledTotal : String?

    init(json: JSON) {

        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ CommissionItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
        merchantSettledTotal = json["merchantSettledTotal"].string
        merchantPendingTotal = json["merchantPendingTotal"].string
        merchantCancelledTotal = json["merchantCancelledTotal"].string
        adminSettledTotal = json["adminSettledTotal"].string
        adminPendingTotal = json["adminPendingTotal"].string
        adminCancelledTotal = json["adminCancelledTotal"].string
        
	}

}
