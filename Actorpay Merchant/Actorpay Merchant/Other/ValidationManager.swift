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
    let acceptTerms = "Please agree to our terms to sign up"
    let sGender = "Please Select Gender"
    let sDateOfBirth = "Please Select DOB"
    let sRole = "Please Select Role"
    let emptyNotesDesc = "Add Note Description"
    let emptyPhoneCode = "Oops! Your Phone Code is Empty"
    let percentageValue = "Percentage should be between 1 to 99"
    
    // Outlet Validation Message
    let outletTitleValidationMsg = "Oops! Your Title is Empty"
    let outletResourcesValidationMsg = "Oops! Your Resources is Empty"
    let outletLicenceValidationMsg = "Oops! Your Licence is Empty"
    let outletMobileValidationMsg = "Oops! Your Phone Number Empty"
    let outletValidMobileValidationMsg = "Oops! Your Phone is Not Correct"
    let outletAddressValidationMsg = "Oops! Your Address is Empty"
    let outletZipcodeValidationMsg = "Oops! Your Zip Code is Empty"
    let outletCityValidationMsg = "Oops! Your City is Empty"
    let outletStateValidationMsg = "Oops! Your State is Empty"
    let outletCountryValidationMsg = "Oops! Your Country is Empty"
    let outletDescValidationMsg = "Oops! Your Description is Empty"
    
    
    let emptyCancelOrderDescription = "Please write reason"
    
    
}
