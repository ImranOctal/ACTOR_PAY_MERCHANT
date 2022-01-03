//
//  Constant.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation

enum APIBaseUrlPoint: String {
    case localHostBaseURL = "http://192.168.1.171:8765/api/"
}

enum APIEndPoint: String {
    case login = "merchant-service/auth/login"
    case register = "merchant-service/merchant/signup"
    case merchantUpdate = "merchant-service/merchant/update"
    case changePassword = "merchant-service/merchant/user/change/password"
    case forgetPassword = "merchant-service/merchant/forget/password"
    case resetPassword = "merchant-service/merchant/reset/password"
    case get_merchant_details_by_id = "merchant-service/merchant/by/id/"
    case productList = "merchant-service/products/active/true"
    case getAllCategories = "merchant-service/get/all/categories/paged"
    case getSubCategories = "merchant-service/get/all/subcategories/by/category"
}

struct MessageConstant {
    static let noNetwork = "No network connection"
    static let someError = "Some error occured"
    static let noData = "There is no content to be displayed"
    static let sslPinningError = "SSL Pinning Error found."
}
