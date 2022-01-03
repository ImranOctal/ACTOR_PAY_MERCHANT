//
//  ProfileViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import NKVPhonePicker

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
    
    var mobileCode: String?
    
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneCodeTextField.delegate = self
        numberPickerSetup()

    }
    
    //MARK: - Selectors -
    
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonAction(_ sender: UIButton) {
       //save Button Action
        /// save Validation
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
    }
    
    @IBAction func phoneCodeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //Phone Code Button
        if let delegate = phoneCodeTextField.phonePickerDelegate {
            let countriesVC = CountriesViewController.standardController()
            countriesVC.delegate = self as CountriesViewControllerDelegate
            let navC = UINavigationController.init(rootViewController: countriesVC)
            delegate.present(navC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Functions -
    
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
            //            phoneCodeButton.setAttributedTitle(attributedString(countryCode: "+\(country?.phoneExtension ?? "")", arrow: " ▾"), for: .normal)
            phoneCodeTextField.setCode(source: NKVSource(country: country!))
            mobileCode = country?.phoneExtension ?? ""
            UserDefaults.standard.synchronize()
        } else {
            let code = "it"
            let country = Country.country(for: NKVSource(countryCode: code))
            phoneCodeTextField.country = country
            phoneCodeTextField.text = country?.phoneExtension
            //            phoneCodeButton.setAttributedTitle(attributedString(countryCode: "+\(country?.phoneExtension ?? "")", arrow: " ▾"), for: .normal)
            phoneCodeTextField.setCode(source: NKVSource(country: country!))
            mobileCode = country?.phoneExtension ?? ""
        }
    }
}

extension ProfileViewController: CountriesViewControllerDelegate, UITextFieldDelegate {
    func countriesViewController(_ sender: CountriesViewController, didSelectCountry country: Country) {
        print("✳️ Did select country: \(country.countryCode)")
        UserDefaults.standard.set(country.countryCode, forKey: "countryCode")
        mobileCode = country.phoneExtension
        phoneCodeTextField.country = country
    }
    
    func countriesViewControllerDidCancel(_ sender: CountriesViewController) {
        print("😕")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
