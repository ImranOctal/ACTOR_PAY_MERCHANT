//
//  APIHelper.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation
import SwiftyJSON
import Alamofire

final class APIHelper {
    
    //MARK: Login Api
    static func loginUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request(method: .post, url: APIEndPoint.login.rawValue, parameters: params) { (response) in
            if response.success {
                let status = response.response["status"]
                if status == "200" {
                    success(true, response)
                }else {
                    success(false, response)
                }
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: SignUp Api
    static func registerUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request(method: .post, url: APIEndPoint.register.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Change Password Api
    static func changePassword(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.changePassword.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Forgot Password Api
    static func forgotPassword(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request(method: .post, url: APIEndPoint.forgetPassword.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Reset Password Api
    static func resetPassword(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.resetPassword.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get Merchant Details By Id Api
    static func getMerchantDetailsById(id: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.merchantDetailsById.rawValue + "\(id)") { (response) in
            if response.success {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Update Merchant Details Api
    static func updateMerchantDetails(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.putRequest(method: .put, url: APIEndPoint.merchantDetailsUpdate.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Add New Product Api
    static func addNewProductApi(params: Parameters, imgData: Data?, imageKey: String , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.uploadData(method: .post, url: APIEndPoint.addNewAndUpdateProductApi.rawValue, parameters: params, imgData: imgData, imageKey: imageKey) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Update Product APi
    static func updateProductDetails(params: Parameters, imgData: Data?, imageKey: String , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.uploadData(method: .post, url: APIEndPoint.addNewAndUpdateProductApi.rawValue, parameters: params, imgData: imgData, imageKey: imageKey) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get Product List Api
    static func getProductListApi(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.productList.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: View All Active Product List Api
    static func viewAllActiveProductListApi(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.activProductList.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get Product Details By Id
    static func getProductDetails(id: String ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getProductDetailsById.rawValue + "\(id)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Remove Product By Id
    static func removeProductById(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request2(method: .delete, url: APIEndPoint.removeProductById.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Change Product Status
    static func changeProductStatusApi(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request2(method: .put, url: APIEndPoint.changeProductStatus.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Category Api
    static func getAllCategoriesAPI(parameters: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getAllCategories.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get In Category Dropdown Api
    static func getInCategoryDropdownApi(parameters: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getInCategoryDropDown.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Subcategory Api
    static func getSubCategoriesApi(parameters: Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getSubCategories.rawValue ,parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    
    //MARK: Get SubCategory By Category
    static func getSubCategoriesByCategoryApi(parameters: Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getSubCategoriesByCategory.rawValue ,parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Active Tax
    static func getAllActiveTax(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.getAllActiveTax.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get In Tax Drop Down Api
    static func getInTaxDropDownApi(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.getInTaxDropDownApi.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get All Tax Data By HSN Code
    static func getAllTaxDataByHSNCodeApi(parameters: Parameters, HSNCode:String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.getTaxDataByHSNCode.rawValue + "\(HSNCode)", parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: View Active Tax Data By ID
    static func viewActiveTaxDataByIDApi(parameters: Parameters, taxID:String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.viewActiveTaxDataByID.rawValue + "\(taxID)", parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Get Order List Api
    static func getOrderListApi(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.orderList.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Change Order Status
    static func updateOrderStatusApi(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request2(method: .put, url: APIEndPoint.updateOrderStatusApi.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Cancel Or Return Order Api
    static func cancelOrReturnOrderApi(params: Parameters ,orderNo:String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.request2(method: .post, url: APIEndPoint.cancelOrReturnOrderApi.rawValue+"\(orderNo)", parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK:  Get Country List Api
    static func getCountryListApi(parameters: Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethodWithoutAuth(method: .get, url: APIEndPoint.contryApi.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    //MARK: Static Content Api With Type
    static func staticContentApi(parameters: Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void) {
        APIManager.shared.getMethodWithoutAuth(method: .get, url: APIEndPoint.staticContentApi.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
}
