//
//  ForgotPasswordViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import Alamofire

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
            emailTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var emailErrorView: UIView!
    @IBOutlet weak var emailValidationLbl: UILabel!
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailErrorView.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    // Ok Button Action
    @IBAction func okButtonAction(_ sender: UIButton){
        self.view.endEditing(true)
        if self.forgotPasswordValidation() {
            emailErrorView.isHidden = true
            self.forgotPasswordApi()
        }
    }
    
    //MARK: - Helper Functions -
    
    // Forgot Password Validation
    func forgotPasswordValidation() -> Bool {
        
        var isValidate = true
        
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            emailErrorView.isHidden = false
            emailValidationLbl.text = ValidationManager.shared.emptyEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
            emailErrorView.isHidden = false
            emailValidationLbl.text = ValidationManager.shared.validEmail
            isValidate = false
        } else {
            emailErrorView.isHidden = true
        }
        
        return isValidate
        
    }
    
}

//MARK: - Extensions -

//MARK: Api call
extension ForgotPasswordViewController {
    
    //Forgot Password Api
    func forgotPasswordApi() {
        let params: Parameters = [
            "emailId": "\(emailTextField.text ?? "")"
        ]
        showLoading()
        APIHelper.forgotPassword(bodyParameter: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            } else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.dismiss(animated: true, completion: nil)
            }
        }

    }
}

//MARK: UITextFieldDelegate Methods

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                emailErrorView.isHidden = false
                emailValidationLbl.text = ValidationManager.shared.emptyEmail
            } else if !isValidEmail(emailTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""){
                emailErrorView.isHidden = false
                emailValidationLbl.text = ValidationManager.shared.validEmail
            } else {
                emailErrorView.isHidden = true
            }
        default:
            break
        }
    }
    
}
