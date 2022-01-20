//
//  NewSubAdminViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class NewSubAdminViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var lastNameTextField: UITextField! {
        didSet {
            lastNameTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField!  {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var userNameTextField: UITextField! {
        didSet {
            userNameTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var phoneNumberTextField: UITextField!  {
        didSet {
            phoneNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var addressTextField: UITextField!  {
        didSet {
            addressTextField.delegate = self
        }
    }
    
    @IBOutlet weak var firstNameValidationLbl: UILabel!
    @IBOutlet weak var lastNameValidationLbl: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var userNameValidationLbl: UILabel!
    @IBOutlet weak var passwordValidationLbl: UILabel!
    @IBOutlet weak var contactNoValidationLbl: UILabel!
    @IBOutlet weak var addressValidationLbl: UILabel!
    
    //MARK:- life Cycle Function -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.validationLabelManage()
    }
    
    //MARK:- Selectors -

    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
        
    // Submit Button Action
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if adminValidation() {
            self.validationLabelManage()
        }
    }
    
    //MARK: - Helper Functions -
    
    // Admin Validation
    func adminValidation() -> Bool {
        var isValidate = true
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            firstNameValidationLbl.isHidden = false
            firstNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            firstNameValidationLbl.isHidden = true
        }
        
        if lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            lastNameValidationLbl.isHidden = false
            lastNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            lastNameValidationLbl.isHidden = true
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
        
        if userNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            userNameValidationLbl.isHidden = false
            userNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            userNameValidationLbl.isHidden = true
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
        
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            contactNoValidationLbl.isHidden = false
            contactNoValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
            contactNoValidationLbl.isHidden = false
            contactNoValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            contactNoValidationLbl.isHidden = true
        }
        
        if addressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            addressValidationLbl.isHidden = false
            addressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            addressValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        firstNameValidationLbl.isHidden = true
        lastNameValidationLbl.isHidden = true
        emailValidationLbl.isHidden = true
        userNameValidationLbl.isHidden = true
        passwordValidationLbl.isHidden = true
        contactNoValidationLbl.isHidden = true
        addressValidationLbl.isHidden = true
    }

}

//MARK: - Extensions -

//MARK: UITextField Delegate Methods
extension NewSubAdminViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                firstNameValidationLbl.isHidden = false
                firstNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                firstNameValidationLbl.isHidden = true
            }
        case lastNameTextField:
            if lastNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                lastNameValidationLbl.isHidden = false
                lastNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                lastNameValidationLbl.isHidden = true
            }
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                emailValidationLbl.isHidden = false
                emailValidationLbl.text = ValidationManager.shared.emptyEmail
            } else if !isValidEmail(emailTextField.text ?? "") {
                emailValidationLbl.isHidden = false
                emailValidationLbl.text = ValidationManager.shared.validEmail
            } else {
                emailValidationLbl.isHidden = true
            }
        case userNameTextField:
            if userNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                userNameValidationLbl.isHidden = false
                userNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                userNameValidationLbl.isHidden = true
            }
        case passwordTextField:
            if passwordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                passwordValidationLbl.isHidden = false
                passwordValidationLbl.text = ValidationManager.shared.emptyPassword
            }
            else if !isValidPassword(mypassword: passwordTextField.text ?? "") {
                passwordValidationLbl.isHidden = false
                passwordValidationLbl.text = ValidationManager.shared.containPassword
            } else {
                passwordValidationLbl.isHidden = true
            }
        case phoneNumberTextField:
            if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                contactNoValidationLbl.isHidden = false
                contactNoValidationLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
                contactNoValidationLbl.isHidden = false
                contactNoValidationLbl.text = ValidationManager.shared.validPhone
            } else {
                contactNoValidationLbl.isHidden = true
            }
        case addressTextField:
            if addressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                addressValidationLbl.isHidden = false
                addressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                addressValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
    
}
