//
//  ProfileViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import Alamofire
import SDWebImage

class ProfileViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var businessNameTextField: UITextField! {
        didSet {
            businessNameTextField.delegate = self
        }
    }
    @IBOutlet weak var mobileNumberTextField: UITextField!  {
        didSet {
            mobileNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var shopAddressTextField: UITextField!  {
        didSet {
            shopAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var fullAddressTextField: UITextField!  {
        didSet {
            fullAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var shopActNoOrLicenceTextField: UITextField!  {
        didSet {
            shopActNoOrLicenceTextField.delegate = self
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var businessNameValidationLbl: UILabel!
    @IBOutlet weak var mobileValidationLbl: UILabel!
    @IBOutlet weak var shopAddressValidationLbl: UILabel!
    @IBOutlet weak var fullAddressValidationLbl: UILabel!
    @IBOutlet weak var shopLicenceValidationLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    @IBOutlet weak var emailVerifyBtn: UIButton!
    @IBOutlet weak var mobileVerifyBtn: UIButton!
    
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    var isEmailVarified = true
    var isMobileVarified = false
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailVarifyFlow()
        self.mobileVerifyButtonFlow()
        self.setUpCountryCodeData()
        self.validationLabelManage()
        self.setMerchantDetailsData()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setMerchantDetailsData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setMerchantDetailsData),name:Notification.Name("setMerchantDetailsData"), object: nil)
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Save Button Action
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if self.profileValidation() {
            self.validationLabelManage()
            self.updateMerchantProfile()
        }
    }
    
    //Country Code Button Action
    @IBAction func phoneCodeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
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
    
    @IBAction func emailVerifyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isEmailVarified = !isEmailVarified
        emailVarifyFlow()
        if isEmailVarified {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as? VerifyOtpViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func mobileVerifyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isMobileVarified = !isMobileVarified
        mobileVerifyButtonFlow()
        if isMobileVarified {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as? VerifyOtpViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Functions -
    
    // Profile Validation
    func profileValidation() -> Bool {
        var isValidate = true
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            emailValidationLbl.textColor = UIColor.red
            emailValidationLbl.text = ValidationManager.shared.emptyEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text ?? ""){
            emailValidationLbl.textColor = UIColor.red
            emailValidationLbl.text = ValidationManager.shared.validEmail
            isValidate = false
        } else {
            emailVarifyFlow()
        }
        
        if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
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
        
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            mobileValidationLbl.textColor = UIColor.red
            mobileValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
            mobileValidationLbl.textColor = UIColor.red
            mobileValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            mobileVerifyButtonFlow()
        }
        
        if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            shopAddressValidationLbl.isHidden = false
            shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopAddressValidationLbl.isHidden = true
        }
        
        if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            fullAddressValidationLbl.isHidden = false
            fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            fullAddressValidationLbl.isHidden = true
        }
        
        if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            shopLicenceValidationLbl.isHidden = false
            shopLicenceValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopLicenceValidationLbl.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        businessNameValidationLbl.isHidden = true
        shopAddressValidationLbl.isHidden = true
        fullAddressValidationLbl.isHidden = true
        shopLicenceValidationLbl.isHidden = true
    }
    
    func emailVarifyFlow() {
        if isEmailVarified {
            emailTextField.isUserInteractionEnabled = false
            emailTextField.textColor = UIColor.darkGray
            emailValidationLbl.text = "Verified"
            emailValidationLbl.textColor = UIColor.init(hexFromString: "2878B6")
            emailVerifyBtn.setTitle("UPDATE", for: .normal)
        } else {
            emailTextField.isUserInteractionEnabled = true
            emailTextField.textColor = UIColor.black
            emailValidationLbl.textColor = UIColor.orange
            emailValidationLbl.text = "Verification Pending"
            emailVerifyBtn.setTitle("Verify", for: .normal)
        }
    }
    
    func mobileVerifyButtonFlow() {
        if isMobileVarified {
            mobileNumberTextField.isUserInteractionEnabled = false
            mobileNumberTextField.textColor = UIColor .darkGray
            mobileValidationLbl.text = "Verified"
            mobileValidationLbl.textColor = UIColor.init(hexFromString: "2878B6")
            mobileVerifyBtn.setTitle("UPDATE", for: .normal)
        } else {
            mobileNumberTextField.isUserInteractionEnabled = true
            mobileNumberTextField.textColor = UIColor .black
            mobileValidationLbl.text = "Verification Pending"
            mobileValidationLbl.textColor = UIColor.orange
            mobileVerifyBtn.setTitle("Verify", for: .normal)
        }
    }
    
    //Set Merchant Details Data
    @objc func setMerchantDetailsData() {
        businessNameLabel.text = merchantDetails?.businessName
        emailTextField.text = merchantDetails?.email
        businessNameTextField.text = merchantDetails?.businessName
        mobileNumberTextField.text = merchantDetails?.contactNumber
        shopAddressTextField.text = merchantDetails?.shopAddress
        fullAddressTextField.text = merchantDetails?.fullAddress
        shopActNoOrLicenceTextField.text = merchantDetails?.licenceNumber
        profileImgView.sd_setImage(with: URL(string: merchantDetails?.profilePicture ?? ""), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
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
extension ProfileViewController {
    
    // Update Profile Api
    func updateMerchantProfile() {
        let params: Parameters = [
            "id":AppManager.shared.merchantUserId,
            "email":emailTextField.text ?? "",
            "extensionNumber":countryCode,
            "contactNumber":mobileNumberTextField.text ?? "",
            "shopAddress":shopAddressTextField.text ?? "",
            "fullAddress":fullAddressTextField.text ?? "",
            "businessName":businessNameTextField.text ?? "",
            "licenceNumber":shopActNoOrLicenceTextField.text ?? ""
        ]
        showLoading()
        APIHelper.updateMerchantDetails(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:Notification.Name("getMerchantDetailsByIdApi"), object: self)
            }
        } 
    }
}


//MARK: TextField Delegate Methods
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                emailValidationLbl.textColor = UIColor.red
                emailValidationLbl.text = ValidationManager.shared.emptyEmail
            } else if !isValidEmail(emailTextField.text ?? ""){
                emailValidationLbl.textColor = UIColor.red
                emailValidationLbl.text = ValidationManager.shared.validEmail
            } else {
                emailValidationLbl.textColor = UIColor.orange
                emailValidationLbl.text = "Varification Pending"
            }
        case businessNameTextField:
            if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                businessNameValidationLbl.isHidden = false
                businessNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                businessNameValidationLbl.isHidden = true
            }
        
        case mobileNumberTextField:
            if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                mobileValidationLbl.textColor = UIColor.red
                mobileValidationLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
                mobileValidationLbl.textColor = UIColor.red
                mobileValidationLbl.text = ValidationManager.shared.validPhone
            } else {
                mobileValidationLbl.textColor = UIColor.orange
                mobileValidationLbl.text = "Varification Pending"

            }
        case shopAddressTextField:
            if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                shopAddressValidationLbl.isHidden = false
                shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                shopAddressValidationLbl.isHidden = true
            }
        case fullAddressTextField:
            if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                fullAddressValidationLbl.isHidden = false
                fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                fullAddressValidationLbl.isHidden = true
            }
        case shopActNoOrLicenceTextField:
            if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                shopLicenceValidationLbl.isHidden = false
                shopLicenceValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                shopLicenceValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
