//
//  ChangePasswordViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import Alamofire

class ChangePasswordViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePasswordLabelView: UIView!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var currentPasswordTextField: UITextField! {
        didSet {
            currentPasswordTextField.delegate = self
            currentPasswordTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var newPasswordTextField: UITextField! {
        didSet {
            newPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var confirmNewPasswordTextField: UITextField! {
        didSet {
            confirmNewPasswordTextField.delegate = self
        }
    }
    @IBOutlet weak var currentPasswordErrorView: UIView!
    @IBOutlet weak var newPasswordErrorView: UIView!
    @IBOutlet weak var confirmNewPasswordErrorView: UIView!
    @IBOutlet weak var currentPasswordValidationLbl: UILabel!
    @IBOutlet weak var newPasswordValidationLbl: UILabel!
    @IBOutlet weak var confirmNewPasswordValidationLbl: UILabel!
    
    var isPassTap = false
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        self.manageErrorView()
        topCorners(bgView: changePasswordLabelView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: buttonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    //Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton){
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    //Ok Button Action
    @IBAction func okButtonAction(_ sender: UIButton){
        if self.changePasswordValidation() {
            self.manageErrorView()
            self.changePasswordApi()
        }
    }
    
    // Password Toggle Button Action
    @IBAction func passwordToggleButton(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001{
            isPassTap = !isPassTap
            currentPasswordTextField.isSecureTextEntry = !isPassTap
            sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
        } else if sender.tag == 1002{
            isPassTap = !isPassTap
            newPasswordTextField.isSecureTextEntry = !isPassTap
            sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
        }else{
            isPassTap = !isPassTap
            confirmNewPasswordTextField.isSecureTextEntry = !isPassTap
            sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
        }
    }
    
    //MARK: - Helper Functions -
    
    // Error View Manage
    func manageErrorView() {
        currentPasswordErrorView.isHidden = true
        newPasswordErrorView.isHidden = true
        confirmNewPasswordErrorView.isHidden = true
    }
    
    // Change Password Validation
    func changePasswordValidation() -> Bool {
        var isValidate = true
        
        if currentPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            currentPasswordErrorView.isHidden = false
            currentPasswordValidationLbl.text = ValidationManager.shared.emptyPassword
            isValidate = false
        }  else if !isValidPassword(mypassword: currentPasswordTextField.text ?? "") {
            currentPasswordErrorView.isHidden = false
            currentPasswordValidationLbl.text = ValidationManager.shared.containPassword
            isValidate = false
        } else {
            currentPasswordErrorView.isHidden = true
        }
        
        if newPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            newPasswordErrorView.isHidden = false
            newPasswordValidationLbl.text = ValidationManager.shared.emptyPassword
            isValidate = false
        } else if !isValidPassword(mypassword: newPasswordTextField.text ?? "") {
            newPasswordErrorView.isHidden = false
            newPasswordValidationLbl.text = ValidationManager.shared.containPassword
            isValidate = false
        } else {
            newPasswordErrorView.isHidden = true
        }
        
        if confirmNewPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            confirmNewPasswordErrorView.isHidden = false
            confirmNewPasswordValidationLbl.text = ValidationManager.shared.emptyPassword
            isValidate = false
        } else if newPasswordTextField.text != confirmNewPasswordTextField.text {
            confirmNewPasswordErrorView.isHidden = false
            confirmNewPasswordValidationLbl.text = ValidationManager.shared.misMatchPassword
            isValidate = false
        } else {
            confirmNewPasswordErrorView.isHidden = true
        }
        
        return isValidate
    }
    
    // Show View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    //Remove View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if !(changePasswordView.frame.contains(currentPoint)) {
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
        
}

//MARK: - Extensions -

//MARK: Api Call
extension ChangePasswordViewController {
    
    //Change Password Api
    func changePasswordApi() {
        let params: Parameters = [
            "currentPassword": "\(currentPasswordTextField.text ?? "")",
            "newPassword": "\(newPasswordTextField.text ?? "")",
            "confirmPassword": "\(confirmNewPasswordTextField.text ?? "")"
        ]
        showLoading()
        APIHelper.changePassword(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                 print(message)
                self.removeAnimate()
                self.dismiss(animated: true, completion: nil)
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
}

//MARK: UITextField Delegate Methods
extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case currentPasswordTextField:
            if currentPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                currentPasswordErrorView.isHidden = false
                currentPasswordValidationLbl.text = ValidationManager.shared.emptyPassword
            }  else if !isValidPassword(mypassword: currentPasswordTextField.text ?? "") {
                currentPasswordErrorView.isHidden = false
                currentPasswordValidationLbl.text = ValidationManager.shared.containPassword
            } else {
                currentPasswordErrorView.isHidden = true
            }
        case newPasswordTextField:
            if newPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                newPasswordErrorView.isHidden = false
                newPasswordValidationLbl.text = ValidationManager.shared.emptyPassword
            } else if !isValidPassword(mypassword: newPasswordTextField.text ?? "") {
                newPasswordErrorView.isHidden = false
                newPasswordValidationLbl.text = ValidationManager.shared.containPassword
            } else {
                newPasswordErrorView.isHidden = true
            }
        case confirmNewPasswordTextField:
            if confirmNewPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                confirmNewPasswordErrorView.isHidden = false
                confirmNewPasswordValidationLbl.text = ValidationManager.shared.emptyPassword
            } else if newPasswordTextField.text != confirmNewPasswordTextField.text {
                confirmNewPasswordErrorView.isHidden = false
                confirmNewPasswordValidationLbl.text = ValidationManager.shared.misMatchPassword
            } else {
                confirmNewPasswordErrorView.isHidden = true
            }
        default:
            break
        }
    }
}
