import Foundation
import SwiftyJSON

struct MerchantDTO {
    
	let createdAt : String?
	let updatedAt : String?
	let id : String?
	let email : String?
	let merchantId : String?
	let extensionNumber : String?
	let contactNumber : String?
	let profilePicture : String?
	let password : String?
	let resourceType : String?
	let businessName : String?
	let fullAddress : String?
	let shopAddress : String?
	let licenceNumber : String?
	let merchantSettingsDTOS : String?
	let active : Bool?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        id = json["id"].string
        email = json["email"].string
        merchantId = json["merchantId"].string
        extensionNumber = json["extensionNumber"].string
        contactNumber = json["contactNumber"].string
        profilePicture = json["profilePicture"].string
        password = json["password"].string
        resourceType = json["resourceType"].string
        businessName = json["businessName"].string
        fullAddress = json["fullAddress"].string
        shopAddress = json["shopAddress"].string
        licenceNumber = json["licenceNumber"].string
        merchantSettingsDTOS = json["merchantSettingsDTOS"].string
        active = json["active"].bool
        
	}

}
