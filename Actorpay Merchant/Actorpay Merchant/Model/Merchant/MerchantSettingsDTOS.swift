import Foundation
import SwiftyJSON

struct MerchantSettingsDTOS : Codable {
	
    let createdAt : String?
	let updatedAt : String?
	let id : String?
	let paramName : String?
	var paramValue : String?
	let paramDescription : String?
	let merchantDTO : String?
	let active : Bool?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        id = json["id"].string
        paramName = json["paramName"].string
        paramValue = json["paramValue"].string
        paramDescription = json["paramDescription"].string
        merchantDTO = json["merchantDTO"].string
        active = json["active"].bool
	}

}
