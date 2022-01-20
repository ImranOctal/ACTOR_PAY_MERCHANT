import Foundation
import SwiftyJSON

struct Customer {
    
	let id : String?
	let firstName : String?
	let lastName : String?
	let email : String?
	let contactNumber : String?
	let roles : [String]?
	let kycDone : Bool?

    init(json: JSON) {

        id = json["id"].string
        firstName = json["firstName"].string
        lastName = json["lastName"].string
        email = json["email"].string
        contactNumber = json["contactNumber"].string
		roles = json["roles"].arrayObject as? [String]
        kycDone = json["kycDone"].bool
	}

}
