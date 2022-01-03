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
    static func loginUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request(method: .post, url: APIEndPoint.login.rawValue, parameters: params) { (response) in
//            let status = response.response["status"]
            if response.success {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
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
    
    static func updateUser(params: Parameters,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void ){
        APIManager.shared.request2(method: .put, url: APIEndPoint.merchantUpdate.rawValue, parameters: params) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
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
    
    //MARK: - GET METHOD API -
    
    static func getUserDetailsById(id: String, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.get_merchant_details_by_id.rawValue + "\(id)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
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
    
    static func getSubCategoriesAPI(parameters: Parameters, success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.getSubCategories.rawValue ,parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    static func getProductDetails(id: String ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(url: APIEndPoint.productList.rawValue + "/\(id)") { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    static func getProductList(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
        APIManager.shared.getMethod(method: .get, url: APIEndPoint.productList.rawValue, parameters: parameters) { (response) in
            let status = response.response["status"]
            if status == "200" {
                success(true, response)
            }else {
                success(false, response)
            }
        }
    }
    
    
    
//    static func getCartItemsList(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
//        APIManager.shared.getMethod(method: .get, url: APIEndPoint.cartItemList.rawValue, parameters: parameters) { (response) in
//            let status = response.response["status"]
//            if status == "200" {
//                success(true, response)
//            }else {
//                success(false, response)
//            }
//        }
//    }
//
//    static func getFAQAll(parameters: Parameters ,success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
//        APIManager.shared.getMethod(method: .get, url: APIEndPoint.faqAll.rawValue, parameters: parameters) { (response) in
//            let status = response.response["status"]
//            if status == "200" {
//                success(true, response)
//            }else {
//                success(false, response)
//            }
//        }
//    }
//
//    static func removeCartItem(id: String , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
//        APIManager.shared.request2(method: .delete, url: APIEndPoint.removeCartItem.rawValue+"/"+id, parameters: [:]) { (response) in
//            let status = response.response["status"]
//            if status == "200" {
//                success(true, response)
//            }else {
//                success(false, response)
//            }
//        }
//    }
//
//    static func updateCartItem(params: Parameters , success:@escaping (_ success: Bool,_ response: APIResponse) -> Void){
//        APIManager.shared.request2(method: .post, url: APIEndPoint.updateCartItem.rawValue, parameters: params) { (response) in
//            let status = response.response["status"]
//            if status == "200" {
//                success(true, response)
//            }else {
//                success(false, response)
//            }
//        }
//    }
    
}
