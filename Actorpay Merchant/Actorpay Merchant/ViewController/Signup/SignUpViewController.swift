//
//  SignUpViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class SignUpViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var fullAddressTextField: UITextField!
    @IBOutlet weak var shopActNoOrLicenceTextField: UITextField!
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var firstNameValidationLbl: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var passwordValidationLbl: UILabel!
    @IBOutlet weak var phoneValidationLbl: UILabel!
    @IBOutlet weak var businessNameValidationLbl: UILabel!
    @IBOutlet weak var shopAddressValidationLbl: UILabel!
    @IBOutlet weak var fullAddressValidationLbl: UILabel!
    @IBOutlet weak var shopLicenceValidationLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    
    var isPassTap = false
    var isRememberMeTap = false
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    
    //MARK: - Life Cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpCountryCodeData()
        self.validationLabelManage()
        topCorner(bgView: mainView, maskToBounds: true)
        setupMultipleTapLabel()
    }
    
    //MARK: - Selectors -
    
    // Password Toggle Button Action
    @IBAction func passwordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isPassTap = !isPassTap
        passwordTextField.isSecureTextEntry = !isPassTap
        sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
    }
    
    // Country Code Button Action
    @IBAction func phoneCodeButtonAction(_ sender: UIButton) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CountryPickerViewController") as! CountryPickerViewController
        newVC.comp = { countryList in
            self.countryList = countryList
            UserDefaults.standard.set(self.countryList?.countryCode, forKey: "countryCode")
            UserDefaults.standard.set(self.countryList?.countryFlag, forKey: "countryFlag")
            self.countryFlagImgView.sd_setImage(with: URL(string: self.countryList?.countryFlag ?? ""), placeholderImage: UIImage(named: "IN.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            self.countryCodeLbl.text = self.countryList?.countryCode
        }
        self.present(newVC, animated: true, completion: nil)
    }
    
    // Remember Me Button Action
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isRememberMeTap = !isRememberMeTap
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: isRememberMeTap ? "checkmark" : ""), for: .normal)
            sender.tintColor = isRememberMeTap ? .white : .systemGray5
            sender.backgroundColor = isRememberMeTap ? UIColor(named: "BlueColor") : .none
            sender.borderColor = isRememberMeTap ? UIColor(named: "BlueColor") : .systemGray5
        }
    }
    
    // SignUp Button Action
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        if self.signUpValidation() {
            self.validationLabelManage()
            self.signUpApi()
        }
    }
    
    // Login Button Action
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Terms and privacy Tab Label Action
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Terms of Use") {
            print("Terms of Use")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            newVC.titleLabel = "Terms of Use"
            self.navigationController?.pushViewController(newVC, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Privacy Policy") {
            print("Privacy Policy")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
            newVC.titleLabel = "Privacy Policy"
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //MARK: - helper Functions -
    
    // SignUp Validation
    func signUpValidation() -> Bool {
        var isValidate = true
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            firstNameValidationLbl.isHidden = false
            firstNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            firstNameValidationLbl.isHidden = true
        }
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            emailValidationLbl.isHidden = false
            emailValidationLbl.text = ValidationManager.shared.emptyEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text ?? "") {
            emailValidationLbl.isHidden = false
            emailValidationLbl.text = ValidationManager.shared.validEmail
            isValidate = false
        } else {
            emailValidationLbl.isHidden = true
        }
        
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            passwordValidationLbl.isHidden = false
            passwordValidationLbl.text = ValidationManager.shared.emptyPassword
            isValidate = false
        }
        else if !isValidPassword(mypassword: passwordTextField.text ?? "") {
            passwordValidationLbl.isHidden = false
            passwordValidationLbl.text = ValidationManager.shared.containPassword
            isValidate = false
        } else {
            passwordValidationLbl.isHidden = true
        }
        
        if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            businessNameValidationLbl.isHidden = false
            businessNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            businessNameValidationLbl.isHidden = true
        }
        
        if countryCodeLbl.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select Country Code.")
            isValidate = false
        }
        
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            phoneValidationLbl.isHidden = false
            phoneValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
            phoneValidationLbl.isHidden = false
            phoneValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            phoneValidationLbl.isHidden = true
        }
        
        if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            shopAddressValidationLbl.isHidden = false
            shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopAddressValidationLbl.isHidden = true
        }
        
        if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            fullAddressValidationLbl.isHidden = false
            fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            fullAddressValidationLbl.isHidden = true
        }
        
        if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            shopLicenceValidationLbl.isHidden = false
            shopLicenceValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopLicenceValidationLbl.isHidden = true
        }
        
        if !isRememberMeTap {
            self.alertViewController(message: "Please agree to our terms to sign up")
            isValidate = false
        }
        
        return isValidate
        
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        emailValidationLbl.isHidden = true
        phoneValidationLbl.isHidden = true
        passwordValidationLbl.isHidden = true
        firstNameValidationLbl.isHidden = true
        shopAddressValidationLbl.isHidden = true
        fullAddressValidationLbl.isHidden = true
        shopLicenceValidationLbl.isHidden = true
        businessNameValidationLbl.isHidden = true
    }
    
    // Setup Terms and Privacy Tap Label
    func setupMultipleTapLabel() {
        termsAndPrivacyLabel.text = "By Signing up you are agreeing to our Terms of Use and Privacy Policy"
        termsAndPrivacyLabel.textAlignment = .left
        let text = (termsAndPrivacyLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let termsRange = (text as NSString).range(of: "Terms of Use")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.init(hexFromString: "#009EEF"), range: termsRange)
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.init(hexFromString: "#009EEF"), range: privacyRange)
        termsAndPrivacyLabel.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsAndPrivacyLabel.isUserInteractionEnabled = true
        termsAndPrivacyLabel.addGestureRecognizer(tapAction)
    }
    
    // Country Code Data SetUp
    func setUpCountryCodeData() {
        if ((UserDefaults.standard.string(forKey: "countryCode")) != nil) {
            countryCode = (UserDefaults.standard.string(forKey: "countryCode") ?? "")
            countryFlag = (UserDefaults.standard.string(forKey: "countryFlag") ?? "")
            countryFlagImgView.sd_setImage(with: URL(string: countryFlag), placeholderImage: UIImage(named: "IN.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            self.countryCodeLbl.text = countryCode
            UserDefaults.standard.synchronize()
        } else {
            countryFlagImgView.sd_setImage(with: URL(string: countryFlag), placeholderImage: UIImage(named: "IN.png"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
            self.countryCodeLbl.text = countryCode
        }
    }
}

//MARK:- Extensions -

//MARK: Api Call
extension SignUpViewController {
    
    // SignUp Api
    func signUpApi(){
        let params: Parameters = [
            "email":"\(emailTextField.text ?? "")",
            "extensionNumber":countryCode,
            "contactNumber":"\(mobileNumberTextField.text ?? "")",
            "password":"\(passwordTextField.text ?? "")",
            "firstName":"\(firstNameTextField.text ?? "")",
            "shopAddress": "\(shopAddressTextField.text ?? "")",
            "fullAddress": "\(fullAddressTextField.text ?? "")",
            "businessName": "\(businessNameTextField.text ?? "")",
            "licenceNumber": "\(shopActNoOrLicenceTextField.text ?? "")",
            "fcmToken": "\(deviceFcmToken)",
            "deviceInfo": [
                "deviceType":"iPhone",
                "appVersion":appVersion(),
                "deviceToken":deviceFcmToken,
                "deviceData":"\(UIDevice.modelName)"
            ]
        ]
        print(params)
        showLoading()
        APIHelper.registerUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
}

//MARK: SetUp TapGesture Recognizer
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
                                                        locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

//MARK: TextField Delegate Methods
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
