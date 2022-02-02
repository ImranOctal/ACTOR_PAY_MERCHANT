import Foundation
import SwiftyJSON

struct SubMerchantItems {
	let createdAt : String?
	let updatedAt : String?
	let id : String?
	let email : String?
	let merchantId : String?
	let extensionNumber : String?
	let contactNumber : String?
	let profilePicture : String?
	let firstName : String?
	let lastName : String?
	let active : String?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        id = json["id"].string
        email = json["email"].string
        merchantId = json["merchantId"].string
		extensionNumber = json["extensionNumber"].string
		contactNumber = json["contactNumber"].string
		profilePicture = json["profilePicture"].string
		firstName = json["firstName"].string
		lastName = json["lastName"].string
		active = json["active"].string
	}

}
