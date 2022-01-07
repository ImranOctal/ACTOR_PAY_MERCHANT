//
//  LoginViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit
import LocalAuthentication
import Alamofire

class LoginViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet {
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var remberMeBtn: UIButton!

    var isPassTap = false
    var isRememberMeTap = false
    var merchant: Merchant?
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if AppManager.shared.rememberMeEmail != "" {
            emailTextField.text = AppManager.shared.rememberMeEmail
            passwordTextField.text = AppManager.shared.rememberMePassword
            isRememberMeTap = true
            if #available(iOS 13.0, *) {
                remberMeBtn.setImage(UIImage(systemName: "checkmark"), for: .normal)
            }
            remberMeBtn.tintColor = .white
            remberMeBtn.backgroundColor = UIColor(named: "BlueColor")
            remberMeBtn.borderColor = UIColor(named: "BlueColor")
        } else {
            if #available(iOS 13.0, *) {
                remberMeBtn.setImage(UIImage(systemName:""), for: .normal)
                remberMeBtn.tintColor = .systemGray5
                remberMeBtn.backgroundColor = .none
                remberMeBtn.borderColor = .systemGray5
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !isRememberMeTap {
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    }

    //MARK: - Selector -
    
    //Password Toggel Button Action
    @IBAction func passwordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // login password
        isPassTap = !isPassTap
        passwordTextField.isSecureTextEntry = !isPassTap
        sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
    }
    
    //Remember Me Button Action
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
    
    // Forgot Password Button Action
    @IBAction func forgotPasswordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.addChild(popOverConfirmVC)
        popOverConfirmVC.view.frame = self.view.frame
        self.view.center = popOverConfirmVC.view.center
        self.view.addSubview(popOverConfirmVC.view)
        popOverConfirmVC.didMove(toParent: self)
    }
    
    // Login Button Action
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
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
        if isRememberMeTap {
            AppManager.shared.rememberMeEmail = emailTextField.text ?? ""
            AppManager.shared.rememberMePassword = passwordTextField.text ?? ""
        }
        
        self.loginApi()
        
    }
    
    //Facial Recognaition Button Action
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
    
    // SignUp Button Action
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
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

//MARK: - Extensions -

//MARK: Api Call
extension LoginViewController {
    
    //Login Api
    func loginApi() {
        let params: Parameters = [
            "email": "\(emailTextField.text ?? "")",
            "password": "\(passwordTextField.text ?? "")",
            "deviceInfo": [
                "deviceType":"mobile" as String,
                "appVersion":appVersion(),
                "deviceToken":deviceFcmToken,
                "deviceData":"\(UIDevice.modelName)"
            ]
        ]
        showLoading()
        APIHelper.loginUser(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.merchant = Merchant.init(json: data)
                AppManager.shared.token = self.merchant?.access_token ?? ""
                AppManager.shared.merchantUserId = self.merchant?.id ?? ""
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
                myApp.window?.rootViewController?.view.makeToast(response.message)
            }
        }
    }
}

