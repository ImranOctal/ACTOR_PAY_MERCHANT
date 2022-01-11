//
//  ValidationManager.swift
//  Actorpay Merchant
//
//  Created by iMac on 05/01/22.
//

import Foundation

class ValidationManager {
    
    static let shared = ValidationManager()
    
    let emptyEmail = "Oops! Your Email is Empty"
    let validEmail = "Oops! Your Email is Invalid"
    let emptyPassword = "Oops! Your Password is Empty"
    let validPassword = "Oops! Your Password is Invalid"
    let containPassword = "Password should contain min of 8 characters and at least 1 lowercase, 1 symbol, 1 uppercase and 1 numeric value"
    let misMatchPassword = "Oops! Your Password Mismatch"
    let emptyField = "Field should not be empty"
    let emptyPhone = "Oops! Your Phone is Empty"
    let validPhone = "Oops! Your Phone is Invalid"
    let emptyProductName = "Oops! Your Product Name is Empty"
    let productNameLength = "Oops! Your Product Name's length is less than 3"
    let selectCategory = "Please Select Category"
    let selectSubCategory = "Please Select Subcategory"
    let emptyActualPrice = "Oops! Product Price is Empty or less than 1"
    let emptyDealprice = "Oops! Product Price is Empty or less than 1"
    let chooseTax = "Please Choose Tax Details"
    let emptyQuantity = "Oops! Product Quantity is Empty or 0"
    let emptyProductDescription = "Oops! Your Product Description is Empty"
}
