import Foundation
import SwiftyJSON

struct SubMerchantList {
    
	let totalPages : Int?
	let totalItems : Int?
	let items : [SubMerchantItems]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {
        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ SubMerchantItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
    }

}
