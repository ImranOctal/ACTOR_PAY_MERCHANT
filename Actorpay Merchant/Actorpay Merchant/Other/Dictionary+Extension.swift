//
//  Dictionary+Extension.swift
//  rider
//
//  Created by b2c on 10/1/17.
//  Copyright © 2017 Akhil Jayaram. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Dictionary where Key == String{
    mutating func update(other:Dictionary) {
        for (key,value) in other {
            self.updateValue(value, forKey:key)
        }
    }
    var data:[String : Any] {
        return  self["data"] as! [String : Any]
    }
    
}

extension JSON
{
    var data:JSON{
        return  self["data"]
    }
    
}
