//
//  ProfileViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import NKVPhonePicker
import Alamofire
import SDWebImage

class ProfileViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneCodeTextField: NKVPhonePickerTextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var shopAddressTextField: UITextField!
    @IBOutlet weak var fullAddressTextField: UITextField!
    @IBOutlet weak var shopActNoOrLicenceTextField: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    var mobileCode: String?
    
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneCodeTextField.delegate = self
        numberPickerSetup()
        setMerchantDetailsData()
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Save Button Action
    @IBAction func saveButtonAction(_ sender: UIButton) {
        // save Validation
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an email address.")
            return
        }
        if !isValidEmail(emailTextField.text ?? ""){
            self.alertViewController(message: "Please Enter an email address.")
            return
        }
        if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an business Name.")
            return
        }
        if phoneCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select Country Code.")
            return
        }
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a phone number.")
            return
        }
        if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a shop address.")
            return
        }
        if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a Full address.")
            return
        }
        if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a shop act number or licence.")
            return
        }
        
        self.updateMerchantProfile()
    }
    
    //Country Code Button Action
    @IBAction func phoneCodeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let delegate = phoneCodeTextField.phonePickerDelegate {
            let countriesVC = CountriesViewController.standardController()
            countriesVC.delegate = self as CountriesViewControllerDelegate
            let navC = UINavigationController.init(rootViewController: countriesVC)
            delegate.present(navC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Functions -
    
    //Set Merchant Details Data
    func setMerchantDetailsData() {
        businessNameLabel.text = merchantDetails?.businessName
        emailTextField.text = merchantDetails?.email
        businessNameTextField.text = merchantDetails?.businessName
        mobileNumberTextField.text = merchantDetails?.contactNumber
        shopAddressTextField.text = merchantDetails?.shopAddress
        fullAddressTextField.text = merchantDetails?.fullAddress
        shopActNoOrLicenceTextField.text = merchantDetails?.licenceNumber
        profileImgView.sd_setImage(with: URL(string: merchantDetails?.profilePicture ?? ""), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
    }
    
    //Country Code Picker SetUp
    func numberPickerSetup() {
        phoneCodeTextField.phonePickerDelegate = self
        phoneCodeTextField.countryPickerDelegate = self
        phoneCodeTextField.flagSize = CGSize(width: 20, height: 10)
        phoneCodeTextField.flagInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        phoneCodeTextField.shouldScrollToSelectedCountry = false
        phoneCodeTextField.enablePlusPrefix = false
        
        if ((UserDefaults.standard.string(forKey: "countryCode")) != nil) {
            let code = (UserDefaults.standard.string(forKey: "countryCode") ?? Locale.current.regionCode) ?? ""
            let country = Country.country(for: NKVSource(countryCode: code))
            phoneCodeTextField.country = country
            phoneCodeTextField.text = country?.phoneExtension
            phoneCodeTextField.setCode(source: NKVSource(country: country!))
            mobileCode = country?.phoneExtension ?? ""
            UserDefaults.standard.synchronize()
        } else {
            let code = "in"
            let country = Country.country(for: NKVSource(countryCode: code))
            phoneCodeTextField.country = country
            phoneCodeTextField.text = country?.phoneExtension
            phoneCodeTextField.setCode(source: NKVSource(country: country!))
            mobileCode = country?.phoneExtension ?? ""
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
            "extensionNumber":"+91",
            "contactNumber":mobileNumberTextField.text ?? "",
            "shopAddress":shopAddressTextField.text ?? "",
            "fullAddress":fullAddressTextField.text ?? "",
            "businessName":businessNameTextField.text ?? "",
            "password":"Test@111"
        ]
        showLoading()
        APIHelper.updateMerchantDetails(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:Notification.Name("getMerchantDetailsByIdApi"), object: self)
            }
        } 
    }
}

//MARK: Country Code Picker Delegate Methods
extension ProfileViewController: CountriesViewControllerDelegate {
    
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country.countryCode)")
        UserDefaults.standard.set(country.countryCode, forKey: "countryCode")
        mobileCode = country.phoneExtension
        phoneCodeTextField.country = country
    }
    
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("😕")
    }
}

//MARK: TextField Delegate Methods
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
