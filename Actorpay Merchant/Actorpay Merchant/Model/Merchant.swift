//
//  Merchant.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/12/21.
//

import Foundation
import SwiftyJSON

public class Merchant {
    public var role : String?
    public var id : String?
    public var email : String?
    public var businessName : String?
    public var permission : String?
    public var profileImage : String?
    public var access_token : String?
    public var refresh_token : String?
    public var token_type : String?
    
    init(json: JSON) {
        role = json["role"].string
        id = json["id"].string
        email = json["email"].string
        businessName = json["businessName"].string
        permission = json["permission"].string
        profileImage = json["profileImage"].string
        access_token = json["access_token"].string
        refresh_token = json["refresh_token"].string
        token_type = json["token_type"].string
    }
}
