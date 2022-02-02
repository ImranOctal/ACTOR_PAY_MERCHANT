import Foundation
import SwiftyJSON

struct ScreenList {
	let createdAt : String?
	let updatedAt : String?
	let id : String?
	let screenName : String?
	let screenPath : String?
	let screenOrder : Int?
	let active : Bool?
    var isReadSelected: Bool?
    var isWriteSelected: Bool?
    

    init(json: JSON) {

        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        id = json["id"].string
        screenName = json["screenName"].string
        screenPath = json["screenPath"].string
        screenOrder = json["screenOrder"].int
        active = json["active"].bool
	}

}
