//
//  Global.swift
//  Actorpay
//
//  Created by iMac on 01/12/21.
//

import Foundation
import UIKit
import MBProgressHUD


let obj_AppDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
let myApp = UIApplication.shared.delegate as! AppDelegate
let token = ""
var deviceFcmToken = ""
typealias typeAliasStringDictionary         = [String: String]
var selectedTabIndex = 0
var selectedTabTag = 1001
let VAL_TITLE                               = "Val_TITLE"
let VAL_IMAGE                               = "VAL_IMAGE"
var primaryColor = UIColor.init(hexFromString: "#183967")
var progressHud = MBProgressHUD()

func showLoading() {
    DispatchQueue.main.async {
        if progressHud.superview != nil {
            progressHud.hide(animated: false)
        }
        progressHud = MBProgressHUD.showAdded(to: (myApp.window?.rootViewController!.view)!, animated: true)
        if #available(iOS 9.0, *) {
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.gray
        } else {
        }
        DispatchQueue.main.async {
            progressHud.show(animated: true)
        }
    }
}

func dissmissLoader() {
    DispatchQueue.main.async {
        progressHud.hide(animated: true)
    }
}

func deviceID() -> String{
    return UIDevice.current.identifierForVendor?.uuidString ?? ""
}

func appVersion() -> String {
    if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
        return version
    }
    return ""
}


func attributedString(countryCode: String, arrow : String) -> NSMutableAttributedString {
    let countryCodeAttr = [ NSAttributedString.Key.foregroundColor: UIColor.black ]
    let countryCodeAttrString = NSAttributedString(string: countryCode, attributes: countryCodeAttr)
    
    let arrowAttr = [ NSAttributedString.Key.foregroundColor: UIColor.darkGray ]
    let arrowAttrString = NSAttributedString(string: arrow, attributes: arrowAttr)
    
    let mutableAttributedString = NSMutableAttributedString()
    mutableAttributedString.append(countryCodeAttrString)
    mutableAttributedString.append(arrowAttrString)
    return mutableAttributedString
}

func topCorner(bgView:UIView, maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
    bgView.layer.shadowRadius = 2
    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = 40
    bgView.layer.masksToBounds = maskToBounds
 }

func rightCorners(bgView:UIView, maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
    bgView.layer.shadowRadius = 2
    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = 50
    bgView.layer.masksToBounds = maskToBounds
 }

func topCorners(bgView:UIView, cornerRadius: CGFloat ,maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
//    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
//    bgView.layer.shadowRadius = 2
//    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = cornerRadius
    bgView.layer.masksToBounds = maskToBounds
 }

func bottomCorner(bgView:UIView, cornerRadius: CGFloat ,maskToBounds: Bool) {
    bgView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
//    bgView.layer.shadowOffset = CGSize(width: -1, height: -2)
//    bgView.layer.shadowRadius = 2
//    bgView.layer.shadowOpacity = 0.1
    bgView.layer.cornerRadius = cornerRadius
    bgView.layer.masksToBounds = maskToBounds
 }

struct ScreenSize
{
   static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
   static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
   static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
   static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

func isValidEmail(email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    emailPred.evaluate(with: email)
    return false
}

func isValidPassword(mypassword : String) -> Bool
{
    let passwordreg =  ("(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[@#$%^&*]).{8,}")
    let passwordtesting = NSPredicate(format: "SELF MATCHES %@", passwordreg)
    return passwordtesting.evaluate(with: mypassword)
}

func isValidMobileNumber(mobileNumber: String) -> Bool {
    let mobileregex = ("^[0-9]{10}$")
    let mobilePred = NSPredicate(format: "SELF MATCHES %@", mobileregex)
    return mobilePred.evaluate(with: mobileNumber)
}

func doubleToStringWithComma(_ price: Double) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.groupingSeparator = ","
    numberFormatter.groupingSize = 3
    numberFormatter.usesGroupingSeparator = true
    numberFormatter.decimalSeparator = "."
    numberFormatter.numberStyle = .decimal
    numberFormatter.maximumFractionDigits = 2
    return numberFormatter.string(from: price as NSNumber)!
}
