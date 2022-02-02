import Foundation
import SwiftyJSON

struct OutletItems {
	let createdAt : String?
	let updatedAt : String?
	let addressLine1 : String?
	let addressLine2 : String?
	let zipCode : String?
	let city : String?
	let state : String?
	let country : String?
	let latitude : String?
	let longitude : String?
	let id : String?
	let title : String?
	let licenceNumber : String?
	let resourceType : String?
	let merchantId : String?
	let contactNumber : String?
	let extensionNumber : String?
	let description : String?
	let active : Bool?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        addressLine1 = json["addressLine1"].string
        addressLine2 = json["addressLine2"].string
        zipCode = json["zipCode"].string
        city = json["city"].string
        state = json["state"].string
        country = json["country"].string
        latitude = json["latitude"].string
        longitude = json["longitude"].string
        id = json["id"].string
        title = json["title"].string
        licenceNumber = json["licenceNumber"].string
        resourceType = json["resourceType"].string
        merchantId = json["merchantId"].string
        contactNumber = json["contactNumber"].string
        extensionNumber = json["extensionNumber"].string
        description = json["description"].string
        active = json["active"].bool
	}
    
}
