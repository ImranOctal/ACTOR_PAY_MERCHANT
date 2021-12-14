//
//  LoginViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var isPassTap = false
    var isRememberMeTap = false
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        // Do any additional setup after loading the view.
    }

    //MARK: - Selector -
    
    @IBAction func passwordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // login password
        isPassTap = !isPassTap
        passwordTextField.isSecureTextEntry = !isPassTap
        sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
    }
    
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // remember Me
        isRememberMeTap = !isRememberMeTap
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: isRememberMeTap ? "checkmark" : ""), for: .normal)
            sender.tintColor = isRememberMeTap ? .white : .systemGray5
            sender.backgroundColor = isRememberMeTap ? UIColor(named: "BlueColor") : .none
            sender.borderColor = isRememberMeTap ? UIColor(named: "BlueColor") : .systemGray5
        }

    }
    
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        //  Login Validation
//        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
//            self.alertViewController(message: "Please Enter an email address.")
//            return
//        }
//        if !isValidEmail(emailTextField.text ?? ""){
//            self.alertViewController(message: "Please Enter an email address.")
//            return
//        }
//        if passwordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
//            self.alertViewController(message: "Please Enter an Password.")
//            return
//        }
        
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
        myApp.window?.rootViewController = newVC
        
    }
    @IBAction func faceLoginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // Face Login
        guard #available(iOS 8.0, *) else {
            return print("Not supported")
        }
        
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return print(error as Any)
        }
        
        let reason = "Face ID authentication"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { isAuthorized, error in
            guard isAuthorized == true else {
                return print(error as Any)
            }
            
            print("success")
        }
    }
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // signup Button action
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: - Helper Function -
    
    func alert(title: String, message: String, okActionTitle: String) {
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        let okAction = UIAlertAction(title: okActionTitle, style: .default)
        alertView.addAction(okAction)
        present(alertView, animated: true)
    }
    
}

