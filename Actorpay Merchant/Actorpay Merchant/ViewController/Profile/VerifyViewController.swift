//
//  VerifyViewController.swift
//  Actorpay
//
//  Created by iMac on 21/01/22.
//

import UIKit
import SDWebImage

class VerifyViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var phoneNumberView: UIView!
    @IBOutlet weak var countryCodeLbl: UILabel!        
    @IBOutlet weak var countryFlagImgView: UIImageView!
    @IBOutlet weak var phoneNumberField: UITextField! {
        didSet {
            phoneNumberField.delegate = self
            phoneNumberField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLbl: UILabel!
    
    var isEmailVerify = false
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerLbl.text = isEmailVerify ? "Update Email" : "Update Phone"
        phoneNumberView.isHidden = isEmailVerify
        emailView.isHidden = !isEmailVerify
        errorView.isHidden = true
        topCorners(bgView: headerView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: buttonView, cornerRadius: 10, maskToBounds: true)
        self.setUpCountryCodeData()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Ok Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if isEmailVerify {
            if emailValidation() {
                print("Email")
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }else{
            if phoneNumberValidation() {
                print("PhoneNumber")
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Country Code Picker Button Action
    @IBAction func phoneCodeBtnAction(_ sender: UIButton) {
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
    
    //MARK: - Helper Functions -
    
    // Email Validation
    func emailValidation() -> Bool {
        var isValidate = true
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.emptyEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.validEmail
            isValidate = false
        } else {
            errorView.isHidden = true
        }
        return isValidate
    }
    
    // Phone Number Validation
    func phoneNumberValidation() -> Bool {
        
        var isValidate = true
        
        if countryCodeLbl.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.emptyPhoneCode
            isValidate = false
        }else {
            errorView.isHidden = true
        }
        
        if phoneNumberField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneNumberField.text ?? "") {
            errorView.isHidden = false
            errorLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            errorView.isHidden = true
        }
        
        return isValidate
        
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
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Dismiss View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.endEditing(true)
                self.view.removeFromSuperview()
            }
        });
    }

    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != emailView){
            removeAnimate()
        }
    }
    
}

//MARK: - Extensions -

extension VerifyViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.emptyEmail
            } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.validEmail
            } else {
                errorView.isHidden = true
            }
        case phoneNumberField:
            if phoneNumberField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: phoneNumberField.text ?? "") {
                errorView.isHidden = false
                errorLbl.text = ValidationManager.shared.validPhone
            } else {
                errorView.isHidden = true
            }
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}
