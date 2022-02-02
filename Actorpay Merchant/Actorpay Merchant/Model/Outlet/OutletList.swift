import Foundation
import SwiftyJSON

struct OutletList {
    
	let totalPages : Int?
	let totalItems : Int?
	let items : [OutletItems]?
	let pageNumber : Int?
	let pageSize : Int?

    init(json: JSON) {

        totalPages = json["totalPages"].int
        totalItems = json["totalItems"].int
        items = json["items"].arrayValue.map{ OutletItems(json: $0)}
        pageNumber = json["pageNumber"].int
        pageSize = json["pageSize"].int
	}

}
