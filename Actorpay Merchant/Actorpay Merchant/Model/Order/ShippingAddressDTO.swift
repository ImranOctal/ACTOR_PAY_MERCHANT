import Foundation
import SwiftyJSON

struct ShippingAddressDTO {
	let addressLine1 : String?
	let addressLine2 : String?
	let city : String?
	let state : String?
	let country : String?
	let id : String?
	let primaryContactNumber : String?
	let secondaryContactNumber : String?

    init(json: JSON) {

        addressLine1 = json["addressLine1"].string
        addressLine2 = json["addressLine2"].string
        city = json["city"].string
        state = json["state"].string
        country = json["country"].string
        id = json["id"].string
        primaryContactNumber = json["primaryContactNumber"].string
        secondaryContactNumber = json["secondaryContactNumber"].string
	}

}
