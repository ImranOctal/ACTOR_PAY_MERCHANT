//
//  LoginViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    var isPassTap = false
    var isRememberMeTap = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        // Do any additional setup after loading the view.
    }

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
        
    }
    @IBAction func loginButtonAction(_ sender: UIButton) {
        //  Login Validation
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an email address.")
            return
        }
        if !isValidEmail(emailTextField.text ?? ""){
            self.alertViewController(message: "Please Enter an email address.")
            return
        }
        if passwordTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an Password.")
            return
        }
        
//        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
//        myApp.window?.rootViewController = newVC
        
    }
    @IBAction func faceLoginButtonAction(_ sender: UIButton) {
        // Face Login
    }
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        // signup Button action
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}

