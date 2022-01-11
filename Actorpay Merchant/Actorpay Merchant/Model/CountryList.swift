import Foundation
import SwiftyJSON

struct CountryList {
    
	let id : String?
	let active : Bool?
	let country : String?
	let countryCode : String?
    let countryFlag : String?
	let defaultStatus : Bool?

    init(json: JSON) {

        id = json["id"].string
        active = json["active"].bool
        country = json["country"].string
        countryCode = json["countryCode"].string
        countryFlag = json["countryFlag"].string
        defaultStatus = json["default"].bool
	}

}
