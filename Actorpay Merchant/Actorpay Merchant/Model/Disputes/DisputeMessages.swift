//
//  DisputeMessages.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import Foundation
import SwiftyJSON

struct DisputeMessages {
    
    var createdAt: String?
    var updatedAt: String?
    var message: String?
    var postedById: String?
    var postedByName: String?
    var userType: String?
    var disputeId: String?
    var active: Bool?
    
    init(json: JSON) {
        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        message = json["message"].string
        postedById = json["postedById"].string
        postedByName = json["postedByName"].string
        userType = json["userType"].string
        disputeId = json["disputeId"].string
        active = json["active"].bool
    }
}

