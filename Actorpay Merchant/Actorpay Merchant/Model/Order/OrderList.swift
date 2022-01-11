import Foundation
import SwiftyJSON

struct OrderList {
    
	let totalPages : Int?
	let totalItems : Int?
	let items : [OrderItems]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {

        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ OrderItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
	}
}
