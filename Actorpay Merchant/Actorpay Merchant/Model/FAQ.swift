import Foundation
import SwiftyJSON

public class FAQ {
	public var id : String?
	public var question : String?
	public var answer : String?
	public var updatedAt : String?
    public var sectionIsExpended = false

    init(json: JSON) {

        id = json["id"].string
        question = json["question"].string
        answer = json["answer"].string
        updatedAt = json["updatedAt"].string
	}

}

