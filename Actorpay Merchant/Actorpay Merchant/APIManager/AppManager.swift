//
//  AppManager.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation
import SwiftyJSON

class AppManager {
  
    static let shared = AppManager()
    
    var token: String {
        get {
            let token =  AppUserDefaults.getSavedObject(forKey: .userAuthToken) as? String
            return token ?? ""
        }
        set(newToken) {
            AppUserDefaults.saveObject(newToken, forKey: .userAuthToken)
        }
    }
    
    var merchantUserId: String {
        get {
            let merchantId =  AppUserDefaults.getSavedObject(forKey: .activeUserId) as? String
            return merchantId ?? ""
        }
        set(merchantId) {
            AppUserDefaults.saveObject(merchantId, forKey: .activeUserId)
        }
    }
    
    var merchantId: String {
        get {
            let merchantId =  AppUserDefaults.getSavedObject(forKey: .activeMerchantId) as? String
            return merchantId ?? ""
        }
        set(merchantId) {
            AppUserDefaults.saveObject(merchantId, forKey: .activeMerchantId)
        }
    }
    
    var rememberMeEmail: String {
        get {
            let rememberMeEmail =  AppUserDefaults.getSavedObject(forKey: .rememberMeEmail) as? String
            return rememberMeEmail ?? ""
        }
        set(rememberMeEmail) {
            AppUserDefaults.saveObject(rememberMeEmail, forKey: .rememberMeEmail)
        }
    }
    
    var rememberMePassword: String {
        get {
            let rememberMePassword =  AppUserDefaults.getSavedObject(forKey: .rememberMePassword) as? String
            return rememberMePassword ?? ""
        }
        set(rememberMePassword) {
            AppUserDefaults.saveObject(rememberMePassword, forKey: .rememberMePassword)
        }
    }
}

class AppUserDefaults {
    class func saveObject(_ object: Any?, forKey key: UserDefaultsConstant) {
        let defaults = UserDefaults.standard
        defaults.set(object, forKey: key.rawValue)
        defaults.synchronize()
    }

    class func getSavedObject(forKey: UserDefaultsConstant) -> Any? {
        let savedObject = UserDefaults.standard.object(forKey: forKey.rawValue)
        return savedObject
    }
}

enum UserDefaultsConstant: String {
    case userAuthToken = "keyAcccessToken"
    case activeUserId = "activeUserId"
    case activeMerchantId = "activeMerchantId"
    case rememberMeEmail = "rememberMeEmail"
    case rememberMePassword = "rememberMePassword"
}
