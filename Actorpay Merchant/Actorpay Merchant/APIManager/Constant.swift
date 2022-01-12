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
    case changePassword = "merchant-service/merchant/user/change/password"
    case forgetPassword = "merchant-service/merchant/forget/password"
    case resetPassword = "merchant-service/merchant/reset/password"
    case merchantDetailsById = "merchant-service/merchant/by/id/"
    case merchantDetailsUpdate = "merchant-service/merchant/update"
    case productList = "merchant-service/products/list/paged"
    case activProductList = "merchant-service/products/active/true"
    case getProductDetailsById = "merchant-service/products/"
    case removeProductById = "merchant-service/products/remove"
    case changeProductStatus = "merchant-service/products/change/status"
    case addNewAndUpdateProductApi = "merchant-service/products"    
    case getAllCategories = "merchant-service/get/all/categories/paged"
    case getSubCategoriesByCategory = "merchant-service/get/all/subcategories/by/category"
    case getSubCategories = "merchant-service/get/all/subcategories/paged?"
    case getAllActiveTax = "merchant-service/taxes/active"
    case getTaxDataByHSNCode = "merchant-service/taxes/hsncode/"
    case viewActiveTaxDataByID = "merchant-service/taxes/"
}

struct MessageConstant {
    static let noNetwork = "No network connection"
    static let someError = "Some error occured"
    static let noData = "There is no content to be displayed"
    static let sslPinningError = "SSL Pinning Error found."
}
