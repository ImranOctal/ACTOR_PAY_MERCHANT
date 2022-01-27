//
//  NewSubAdminViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import SDWebImage
import DropDown
import Alamofire

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
    @IBOutlet weak var dobTextField: UITextField! {
        didSet {
            dobTextField.delegate = self
        }
    }
    @IBOutlet weak var genderTextField: UITextField!  {
        didSet {
            genderTextField.delegate = self
        }
    }
    @IBOutlet weak var emailTextField: UITextField!  {
        didSet {
            emailTextField.delegate = self
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
    @IBOutlet weak var roleTextField: UITextField!
    @IBOutlet weak var firstNameValidationLbl: UILabel!
    @IBOutlet weak var lastNameValidationLbl: UILabel!
    @IBOutlet weak var genderValidationLbl: UILabel!
    @IBOutlet weak var dobValidationLbl: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var passwordValidationLbl: UILabel!
    @IBOutlet weak var roleValidationLbl: UILabel!
    @IBOutlet weak var contactNoValidationLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    
    var isPassTap = false
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    let genderDropDown = DropDown()
    var roleList: RoleList?
    
    //MARK:- life Cycle Function -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.validationLabelManage()
        self.setupGenderDropDown()
        self.setUpCountryCodeData()
        self.getRoleListApi()
    }
    
    //MARK:- Selectors -

    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //Gender Button Action
    @IBAction func genderButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        genderDropDown.show()
    }
    
    // Password Toggle Button Action
    @IBAction func passwordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isPassTap = !isPassTap
        passwordTextField.isSecureTextEntry = !isPassTap
        sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
    }
    
    // Country Code Button Action
    @IBAction func phoneCodeButtonAction(_ sender: UIButton) {
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
    
    // Role Button Action
    @IBAction func roleButtonAction(_ sender: UIButton) {
        
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
        
        if genderTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            genderValidationLbl.isHidden = false
            genderValidationLbl.text = ValidationManager.shared.sGender
            isValidate = false
        } else {
            genderValidationLbl.isHidden = true
        }
        
        if dobTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            dobValidationLbl.isHidden = false
            dobValidationLbl.text = ValidationManager.shared.sDateOfBirth
            isValidate = false
        } else {
            dobValidationLbl.isHidden = true
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
        
        if countryCodeLbl.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select Country Code.")
            isValidate = false
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
        
        return isValidate
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        firstNameValidationLbl.isHidden = true
        lastNameValidationLbl.isHidden = true
        dobValidationLbl.isHidden = true
        genderValidationLbl.isHidden = true
        emailValidationLbl.isHidden = true
        passwordValidationLbl.isHidden = true
        roleValidationLbl.isHidden = true
        contactNoValidationLbl.isHidden = true
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
    
    // SetUp Gender Drop Down
    func setupGenderDropDown()  {
        genderDropDown.anchorView = genderTextField
        genderDropDown.dataSource = ["Female","Male","Other"]
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.genderTextField.text = item
            self.view.endEditing(true)
            self.genderDropDown.hide()
        }
        genderDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        genderDropDown.width = genderTextField.frame.width + 70
        genderDropDown.direction = .bottom
    }

}

//MARK: - Extensions -

//MARK: Api Call
extension NewSubAdminViewController {
    
    // Get Role List Api
    func getRoleListApi() {
        let params: Parameters = [
            "pageNo": 0,
            "pageSize": 5,
            "sortBy": "createdAt",
            "asc":"true"
        ]
        showLoading()
        APIHelper.getRoleListApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            } else {
                dissmissLoader()
                let data = response.response["data"]
                print(data)
                self.roleList = RoleList.init(json: data)
                let message = response.message
                print(message)
            }
        }
    }
    
}

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
        default:
            break
        }
    }
    
}
