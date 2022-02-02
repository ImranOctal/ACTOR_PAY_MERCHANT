import Foundation
import SwiftyJSON

struct ScreenAccessPermission {
    
	let screenId : String?
	let read : Bool?
	let write : Bool?
	let screenName : String?

    init(json: JSON) {

        screenId = json["screenId"].string
        read = json["read"].bool
        write = json["write"].bool
        screenName = json["screenName"].string
	}
    
    init(screenId: String, read: Bool, write:Bool, screenName: String) {
        self.screenId = screenId
        self.read = read
        self.write = write
        self.screenName = screenName
    }
        
}
