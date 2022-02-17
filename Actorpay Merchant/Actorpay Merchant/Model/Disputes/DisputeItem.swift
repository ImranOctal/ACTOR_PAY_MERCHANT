//
//  DisputeItem.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import Foundation
import SwiftyJSON

struct DisputeItem {
    
    let createdAt : String?
    let updatedAt : String?
    let disputeId : String?
    let disputeCode : String?
    let title : String?
    let description : String?
    let imagePath : String?
    let orderItemId : String?
    let penalityPercentage : String?
    let status : String?
    let userId : String?
    let userName : String?
    let merchantName : String?
    let merchantId : String?
    let disputeFlag : Bool?
    let disputeMessages : [DisputeMessages]?
    let active : Bool?

    init(json: JSON) {

        createdAt = json["createdAt"].string
        updatedAt = json["updatedAt"].string
        disputeId = json["disputeId"].string
        disputeCode = json["disputeCode"].string
        title = json["title"].string
        description = json["description"].string
        imagePath = json["imagePath"].string
        orderItemId = json["orderItemId"].string
        penalityPercentage = json["penalityPercentage"].string
        status = json["status"].string
        userId = json["userId"].string
        userName = json["userName"].string
        merchantName = json["merchantName"].string
        merchantId = json["merchantId"].string
        disputeFlag = json["disputeFlag"].bool
        disputeMessages = json["disputeMessages"].arrayValue.map({DisputeMessages.init(json: $0)})
        active = json["active"].bool
    }

}
