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
    @IBOutlet weak var currentPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmNewPasswordTextField: UITextField!
    
    var isPassTap = false
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.changePasswordValidation()
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
    
    // Change Password Validation
    func changePasswordValidation() {
        if currentPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            currentPasswordTextField.setError("  "+ValidationManager.shared.emptyPassword+"  ", show: true, triagleConst: -49)
            
            return
        }  else if !isValidPassword(mypassword: currentPasswordTextField.text ?? "") {
            currentPasswordTextField.setError("  "+ValidationManager.shared.containPassword+"  ", show: true,triagleConst: -49,labelHeight: 60)
            return
        } else {
            currentPasswordTextField.setError()
        }
        
        if newPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            newPasswordTextField.setError("  "+ValidationManager.shared.emptyPassword+"  ", show: true,triagleConst: -49)
            return
        } else if !isValidPassword(mypassword: newPasswordTextField.text ?? "") {
            newPasswordTextField.setError("  "+ValidationManager.shared.containPassword+"  ", show: true,triagleConst: -49,labelHeight: 60)
            return
        } else {
            newPasswordTextField.setError()
        }
        
        if confirmNewPasswordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            confirmNewPasswordTextField.setError("  "+ValidationManager.shared.emptyPassword, show: true,triagleConst: -49)
            return
        } else if newPasswordTextField.text != confirmNewPasswordTextField.text {
            confirmNewPasswordTextField.setError("  "+ValidationManager.shared.misMatchPassword+"  ", show: true,triagleConst: -49)
            return
        } else {
            confirmNewPasswordTextField.setError()
        }
        self.changePasswordApi()
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
        currentPasswordTextField.setError()
        newPasswordTextField.setError()
        confirmNewPasswordTextField.setError()
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
        if(touches.first?.view != changePasswordView){
            removeAnimate()
            self.dismiss(animated: true, completion: nil)
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
                print(message)
            }else {
                dissmissLoader()
                let message = response.message
                 print(message)
                self.removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
