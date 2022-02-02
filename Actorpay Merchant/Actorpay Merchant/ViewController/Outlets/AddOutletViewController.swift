//
//  AddOutletViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 31/01/22.
//

import UIKit
import SDWebImage
import Alamofire

class AddOutletViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            titleTextField.delegate = self
            titleTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var resourceTypeTextField: UITextField! {
        didSet {
            resourceTypeTextField.delegate = self
        }
    }
    @IBOutlet weak var licenceNumberTextField: UITextField! {
        didSet {
            licenceNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var phoneNumberTextField: UITextField! {
        didSet {
            phoneNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var addressLine1TextField: UITextField! {
        didSet {
            addressLine1TextField.delegate = self
        }
    }
    @IBOutlet weak var addressLine2TextField: UITextField! {
        didSet {
            addressLine2TextField.delegate = self
        }
    }
    @IBOutlet weak var zipCodeTextField: UITextField! {
        didSet {
            zipCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var cityTextField: UITextField! {
        didSet {
            cityTextField.delegate = self
        }
    }
    @IBOutlet weak var stateTextField: UITextField! {
        didSet {
            stateTextField.delegate = self
        }
    }
    @IBOutlet weak var countryTextField: UITextField! {
        didSet {
            countryTextField.delegate = self
        }
    }
    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            descriptionTextField.delegate = self
        }
    }
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var titleValidationLbl: UILabel!
    @IBOutlet weak var resourceTypeValidationLbl: UILabel!
    @IBOutlet weak var licenceNumberValidationLbl: UILabel!
    @IBOutlet weak var phoneNumberValidationLbl: UILabel!
    @IBOutlet weak var addressLine1ValidationLbl: UILabel!
    @IBOutlet weak var addressLine2ValidationLbl: UILabel!
    @IBOutlet weak var zipCodeValidationLbl: UILabel!
    @IBOutlet weak var cityValidationLbl: UILabel!
    @IBOutlet weak var stateValidationLbl: UILabel!
    @IBOutlet weak var countryValidationLbl: UILabel!
    @IBOutlet weak var descriptionValidationLbl: UILabel!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    var isUpdateOutlet = false
    var outletItem: OutletItems?
    var outletId: String?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpCountryCodeData()
        self.validationLabelManage()
        if isUpdateOutlet {
            headerTitleLbl.text = "UPDATE OUTLET"
            self.getOutletDetailsByIdApi(outletId: outletId ?? "")
        } else {
            headerTitleLbl.text = "ADD OUTLET"
        }
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
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
    
    // Add Outlet And Update Outlet Button Action
    @IBAction func addOutletBtnAction(_ sender: UIButton) {
        if outletValidation() {
            self.validationLabelManage()
            if isUpdateOutlet {
                updateOutletApi()
            } else {
                createOutletApi()
            }
        }
    }
    
    //MARK: - Helper Functions -
    
    // Validation Label Manage
    func validationLabelManage() {
        self.titleValidationLbl.isHidden = true
        self.resourceTypeValidationLbl.isHidden = true
        self.licenceNumberValidationLbl.isHidden = true
        self.phoneNumberValidationLbl.isHidden = true
        self.addressLine1ValidationLbl.isHidden = true
        self.addressLine2ValidationLbl.isHidden = true
        self.zipCodeValidationLbl.isHidden = true
        self.cityValidationLbl.isHidden = true
        self.stateValidationLbl.isHidden = true
        self.countryValidationLbl.isHidden = true
        self.descriptionValidationLbl.isHidden = true
    }
    
    // Outlet Validation
    func outletValidation() -> Bool {
        var isValidate = true
        
        if titleTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            titleValidationLbl.isHidden = false
            titleValidationLbl.text = ValidationManager.shared.outletTitleValidationMsg
            isValidate = false
        } else {
            titleValidationLbl.isHidden = true
        }
        
        if resourceTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            resourceTypeValidationLbl.isHidden = false
            resourceTypeValidationLbl.text = ValidationManager.shared.outletResourcesValidationMsg
            isValidate = false
        } else {
            resourceTypeValidationLbl.isHidden = true
        }
        
        if licenceNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            licenceNumberValidationLbl.isHidden = false
            licenceNumberValidationLbl.text = ValidationManager.shared.outletLicenceValidationMsg
            isValidate = false
        } else {
            licenceNumberValidationLbl.isHidden = true
        }
        
        if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            phoneNumberValidationLbl.isHidden = false
            phoneNumberValidationLbl.text = ValidationManager.shared.outletMobileValidationMsg
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
            phoneNumberValidationLbl.isHidden = false
            phoneNumberValidationLbl.text = ValidationManager.shared.outletValidMobileValidationMsg
            isValidate = false
        } else {
            phoneNumberValidationLbl.isHidden = true
        }
        
        if countryCodeLbl.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select Country Code.")
            isValidate = false
        }
        
        if addressLine1TextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            addressLine1ValidationLbl.isHidden = false
            addressLine1ValidationLbl.text = ValidationManager.shared.outletAddressValidationMsg
            isValidate = false
        } else {
            addressLine1ValidationLbl.isHidden = true
        }
        
        if addressLine2TextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            addressLine2ValidationLbl.isHidden = false
            addressLine2ValidationLbl.text = ValidationManager.shared.outletAddressValidationMsg
            isValidate = false
        } else {
            addressLine2ValidationLbl.isHidden = true
        }
        
        if zipCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            zipCodeValidationLbl.isHidden = false
            zipCodeValidationLbl.text = ValidationManager.shared.outletZipcodeValidationMsg
            isValidate = false
        } else {
            zipCodeValidationLbl.isHidden = true
        }
        
        if cityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            cityValidationLbl.isHidden = false
            cityValidationLbl.text = ValidationManager.shared.outletCityValidationMsg
            isValidate = false
        } else {
            cityValidationLbl.isHidden = true
        }
        
        if stateTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            stateValidationLbl.isHidden = false
            stateValidationLbl.text = ValidationManager.shared.outletStateValidationMsg
            isValidate = false
        } else {
            stateValidationLbl.isHidden = true
        }
        
        if countryTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            countryValidationLbl.isHidden = false
            countryValidationLbl.text = ValidationManager.shared.outletCountryValidationMsg
            isValidate = false
        } else {
            countryValidationLbl.isHidden = true
        }
        
        if descriptionTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            descriptionValidationLbl.isHidden = false
            descriptionValidationLbl.text = ValidationManager.shared.outletDescValidationMsg
            isValidate = false
        } else {
            descriptionValidationLbl.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Set Update Outlet Data
    func setupUpdateOutletData() {
        self.titleTextField.text = outletItem?.title
        self.resourceTypeTextField.text = outletItem?.resourceType
        self.licenceNumberTextField.text = outletItem?.licenceNumber
        self.phoneNumberTextField.text = outletItem?.contactNumber
        self.countryCodeLbl.text = outletItem?.extensionNumber
        self.addressLine1TextField.text = outletItem?.addressLine1
        self.addressLine2TextField.text = outletItem?.addressLine2
        self.zipCodeTextField.text = outletItem?.zipCode
        self.cityTextField.text = outletItem?.city
        self.stateTextField.text = outletItem?.state
        self.countryTextField.text = outletItem?.country
        self.descriptionTextField.text = outletItem?.description
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
    
}

//MARK: - Extensions -

//MARK: Api Call
extension AddOutletViewController {
    
    // get Outlet Details Api
    @objc func getOutletDetailsByIdApi(outletId : String) {
        showLoading()
        APIHelper.getOutletDetailsByIdApi(outletId:outletId ) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                let data = response.response["data"]
                self.outletItem = OutletItems.init(json: data)
                if self.isUpdateOutlet {
                    self.setupUpdateOutletData()
                }
            }
        }
    }
    
    // Create Role Api
    func createOutletApi() {
        let params: Parameters = [
            "resourceType": resourceTypeTextField.text ?? "",
            "licenceNumber": licenceNumberTextField.text ?? "",
            "title": titleTextField.text ?? "",
            "description": descriptionTextField.text ?? "",
            "extensionNumber": countryCodeLbl.text ?? "",
            "contactNumber": phoneNumberTextField.text ?? "",
            "addressLine1": addressLine1TextField.text ?? "",
            "addressLine2": addressLine2TextField.text ?? "",
            "zipCode": zipCodeTextField.text ?? "",
            "city": cityTextField.text ?? "",
            "state": stateTextField.text ?? "",
            "country": countryTextField.text ?? "",
            "latitude": "23234343",
            "longitude": "3333333"
        ]
        showLoading()
        APIHelper.createOutletApi(params: [:], bodyParameter: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                NotificationCenter.default.post(name: Notification.Name("reloadOutletListApi"), object: self)
                myApp.window?.rootViewController?.view.makeToast(message)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Update Sub Merchant Api
    func updateOutletApi() {
        let params: Parameters = [
            "id": outletId ?? "",
            "resourceType": resourceTypeTextField.text ?? "",
            "licenceNumber": licenceNumberTextField.text ?? "",
            "title": titleTextField.text ?? "",
            "description": descriptionTextField.text ?? "",
            "extensionNumber": countryCodeLbl.text ?? "",
            "contactNumber": phoneNumberTextField.text ?? "",
            "addressLine1": addressLine1TextField.text ?? "",
            "addressLine2": addressLine2TextField.text ?? "",
            "zipCode": zipCodeTextField.text ?? "",
            "city": cityTextField.text ?? "",
            "state": stateTextField.text ?? "",
            "country": countryTextField.text ?? "",
            "latitude": "23234343",
            "longitude": "3333333"
        ]
        showLoading()
        APIHelper.updateOutletApi(params: [:], bodyParameter: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:  Notification.Name("reloadOutletListApi"), object: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK: Text Field Delegate Methods
extension AddOutletViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            if titleTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                titleValidationLbl.isHidden = false
                titleValidationLbl.text = ValidationManager.shared.outletTitleValidationMsg
            } else {
                titleValidationLbl.isHidden = true
            }
        case resourceTypeTextField:
            if resourceTypeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                resourceTypeValidationLbl.isHidden = false
                resourceTypeValidationLbl.text = ValidationManager.shared.outletResourcesValidationMsg
            } else {
                resourceTypeValidationLbl.isHidden = true
            }
        case licenceNumberTextField:
            if licenceNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                licenceNumberValidationLbl.isHidden = false
                licenceNumberValidationLbl.text = ValidationManager.shared.outletLicenceValidationMsg
            } else {
                licenceNumberValidationLbl.isHidden = true
            }
        case phoneNumberTextField:
            if phoneNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                phoneNumberValidationLbl.isHidden = false
                phoneNumberValidationLbl.text = ValidationManager.shared.outletMobileValidationMsg
            } else if !isValidMobileNumber(mobileNumber: phoneNumberTextField.text ?? "") {
                phoneNumberValidationLbl.isHidden = false
                phoneNumberValidationLbl.text = ValidationManager.shared.outletValidMobileValidationMsg
            } else {
                phoneNumberValidationLbl.isHidden = true
            }
        case addressLine1TextField:
            if addressLine1TextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                addressLine1ValidationLbl.isHidden = false
                addressLine1ValidationLbl.text = ValidationManager.shared.outletAddressValidationMsg
            } else {
                addressLine1ValidationLbl.isHidden = true
            }
        case addressLine2TextField:
            if addressLine2TextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                addressLine2ValidationLbl.isHidden = false
                addressLine2ValidationLbl.text = ValidationManager.shared.outletAddressValidationMsg
            } else {
                addressLine2ValidationLbl.isHidden = true
            }
        case zipCodeTextField:
            if zipCodeTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                zipCodeValidationLbl.isHidden = false
                zipCodeValidationLbl.text = ValidationManager.shared.outletZipcodeValidationMsg
            } else {
                zipCodeValidationLbl.isHidden = true
            }
        case cityTextField:
            if cityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                cityValidationLbl.isHidden = false
                cityValidationLbl.text = ValidationManager.shared.outletCityValidationMsg
            } else {
                cityValidationLbl.isHidden = true
            }
        case stateTextField:
            if stateTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                stateValidationLbl.isHidden = false
                stateValidationLbl.text = ValidationManager.shared.outletStateValidationMsg
            } else {
                stateValidationLbl.isHidden = true
            }
        case countryTextField:
            if countryTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                countryValidationLbl.isHidden = false
                countryValidationLbl.text = ValidationManager.shared.outletCountryValidationMsg
            } else {
                countryValidationLbl.isHidden = true
            }
        case descriptionTextField:
            if descriptionTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                descriptionValidationLbl.isHidden = false
                descriptionValidationLbl.text = ValidationManager.shared.outletDescValidationMsg
            } else {
                descriptionValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
}

