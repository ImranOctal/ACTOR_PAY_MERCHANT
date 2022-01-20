import Foundation
import SwiftyJSON

struct StaticContent {
	let id : String?
	let cmsType : Int?
	let title : String?
	let contents : String?
	let metaTitle : String?
	let metaKeyword : String?
	let metaData : String?
	let updatedAt : String?

    init (json: JSON){
        id = json["id"].string
        cmsType = json["cmsType"].int
        title = json["title"].string
        contents = json["contents"].string
        metaTitle = json["metaTitle"].string
        metaKeyword = json["metaKeyword"].string
        metaData = json["metaData"].string
        updatedAt = json["updatedAt"].string
	}

}
