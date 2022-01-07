import Foundation
import SwiftyJSON

struct TaxList {
	let id : String?
	let hsnCode : String?
	let productDetails : String?
	let taxPercentage : Double?
	let chapter : String?
	let createdAt : String?
	let updatedAt : String?
	let active : Bool?

    init(json: JSON) {
        id = json["id"].string
        hsnCode = json["hsnCode"].string
        productDetails = json["productDetails"].string
        taxPercentage = json["taxPercentage"].double
        chapter = json["chapter"].string
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        active = json["active"].bool
	}

}
