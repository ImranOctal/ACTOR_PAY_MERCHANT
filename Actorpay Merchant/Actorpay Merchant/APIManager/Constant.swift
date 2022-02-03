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
    case getInCategoryDropDown = "merchant-service/get/all/categories"
    case getAllActiveTax = "merchant-service/taxes/active"
    case getInTaxDropDownApi = "merchant-service/taxes/get/all"
    case getTaxDataByHSNCode = "merchant-service/taxes/hsncode/"
    case viewActiveTaxDataByID = "merchant-service/taxes/"
    case orderList = "merchant-service/orders/list/paged"
    case updateOrderStatusApi = "merchant-service/orders/status"
    case cancelOrReturnOrderApi = "merchant-service/orders/cancel/"
    case contryApi = "global-service/v1/country/get/all"
    case staticContentApi = "cms-service/get/static/data/by/cms"
    case getRoleListApi = "merchant-service/role/get/all/paged"
    case faqAll = "cms-service/faq/all"
    case getAllSubMerchantListApi = "merchant-service/submerchant/get/all/paged"
    case createSubMerchantApi = "merchant-service/submerchant/create"
    case getSubMerchantDetailsApi = "merchant-service/submerchant/read/by/id/"
    case deleteSubMerchentByIdApi = "merchant-service/submerchant/delete/by/ids"
    case updateSubMerchantApi = "merchant-service/submerchant/update"
    case deleteRoleByIdApi = "merchant-service/role/delete/by/ids"
    case getAllScreenApi = "merchant-service/get/all/screens"
    case getRoleByIdApi = "merchant-service/role/by/id"
    case createRoleApi = "merchant-service/role/create"
    case updateRoleApi = "merchant-service/role/update"
    case getOrderDetailsByOrderNo = "merchant-service/orders/"
    case getOutletListApi = "merchant-service/v1/merchant/outlet/get/all/paged"
    case deleteOutletByIdApi = "merchant-service/v1/merchant/outlet/delete/by/ids"
    case getOutletDetailsByIdApi = "merchant-service/v1/merchant/outlet/by/id/"
    case createOutletApi = "merchant-service/v1/merchant/outlet/create"
    case updateOutletApi = "merchant-service/v1/merchant/outlet/update"
    case commissionListApi = "merchant-service/productCommission/list/paged"
    case postOrderNoteApi = "merchant-service/orderNotes/post"
}

struct MessageConstant {
    static let noNetwork = "No network connection"
    static let someError = "Some error occured"
    static let noData = "There is no content to be displayed"
    static let sslPinningError = "SSL Pinning Error found."
}
