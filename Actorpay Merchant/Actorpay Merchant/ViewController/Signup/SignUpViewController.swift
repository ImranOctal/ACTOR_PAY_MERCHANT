//
//  SignUpViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown
import GooglePlaces
import GoogleMaps
import CoreLocation


class SignUpViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField! {
        didSet {
            firstNameTextField.delegate = self
            firstNameTextField.becomeFirstResponder()
        }
    }
    
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var businessNameTextField: UITextField! {
        didSet {
            businessNameTextField.delegate = self
        }
    }
    @IBOutlet weak var mobileNumberTextField: UITextField! {
        didSet {
            mobileNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var shopAddressTextField: UITextField! {
        didSet {
            shopAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var fullAddressTextField: UITextField! {
        didSet {
            fullAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var shopActNoOrLicenceTextField: UITextField! {
        didSet {
            shopActNoOrLicenceTextField.delegate = self
        }
    }
    @IBOutlet weak var termsAndPrivacyLabel: UILabel!
    @IBOutlet weak var firstNameValidationLbl: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var passwordValidationLbl: UILabel!
    @IBOutlet weak var phoneValidationLbl: UILabel!
    @IBOutlet weak var businessNameValidationLbl: UILabel!
    @IBOutlet weak var shopAddressValidationLbl: UILabel!
    @IBOutlet weak var fullAddressValidationLbl: UILabel!
    @IBOutlet weak var shopLicenceValidationLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var termsValidationLbl: UILabel!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    
    var isPassTap = false
    var isRememberMeTap = false
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    var locationManager = CLLocationManager()
    var geoCoder:GMSGeocoder!
    var userAddress = ""
    var userLat = ""
    var userLong = ""
    var currentLoc: CLLocation?
    private let GOOGLE_API_KEY = "AIzaSyDhMau_8Eah9KaloP_NWaBhDjvryMlzcD0"
    let addressDropDown = DropDown()
    var arrAddressArray = [String]()
    lazy var dropDowns: [DropDown] = {
        return [
            self.addressDropDown
        ]
    }()
    var arrayPlaceIDs = [String]()
    
    //MARK: - Life Cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpCountryCodeData()
        self.validationLabelManage()
        topCorner(bgView: mainView, maskToBounds: true)
        setupMultipleTapLabel()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        self.geoCoder = GMSGeocoder()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways) {
            currentLoc = locationManager.location
            if currentLoc != nil{
                self.userLat = "\(currentLoc!.coordinate.latitude)"
                self.userLong = "\(currentLoc!.coordinate.longitude)"
            }
        }
        
        GMSPlacesClient.provideAPIKey(GOOGLE_API_KEY)
        GMSServices.provideAPIKey(GOOGLE_API_KEY)
        setUpDropDown()
    }
    
    //MARK: - Selectors -
    
    // Password Toggle Button Action
    @IBAction func passwordButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isPassTap = !isPassTap
        passwordTextField.isSecureTextEntry = !isPassTap
        sender.setImage(UIImage(named: isPassTap ? "hide" : "show"), for: .normal)
    }
    
    // Country Code Button Action
    @IBAction func phoneCodeButtonAction(_ sender: UIButton) {
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
    
    // Remember Me Button Action
    @IBAction func rememberMeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isRememberMeTap = !isRememberMeTap
        if #available(iOS 13.0, *) {
            sender.setImage(UIImage(systemName: isRememberMeTap ? "checkmark" : ""), for: .normal)
            sender.tintColor = isRememberMeTap ? .white : .systemGray5
            sender.backgroundColor = isRememberMeTap ? UIColor(named: "BlueColor") : .none
            sender.borderColor = isRememberMeTap ? UIColor(named: "BlueColor") : .systemGray5
        }
        if !isRememberMeTap {
            termsValidationLbl.isHidden = false
            termsValidationLbl.text = ValidationManager.shared.acceptTerms
        } else {
            termsValidationLbl.isHidden = true
        }
    }
    
    // SignUp Button Action
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.signUpValidation() {
            self.validationLabelManage()
            self.signUpApi()
        }
    }
    
    // Login Button Action
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Terms and privacy Tab Label Action
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Terms of Use") {
            print("Terms of Use")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
            newVC.titleLabel = "TERM & CONDITIONS"
            newVC.type = 3
            self.navigationController?.pushViewController(newVC, animated: true)
        } else if gesture.didTapAttributedTextInLabel(label: termsAndPrivacyLabel, targetText: "Privacy Policy") {
            print("Privacy Policy")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
            newVC.titleLabel = "PRIVACY POLICY"
            newVC.type = 2
            self.navigationController?.pushViewController(newVC, animated: true)
        }
    }
    
    //MARK: - helper Functions -
    
    // Set Up Drop Down
    func setUpDropDown(){
        
        let appearance = DropDown.appearance()
        
        appearance.cellHeight = 50
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        
        self.addressDropDown.direction = .top
        
        self.addressDropDown.anchorView = self.shopAddressTextField
        self.addressDropDown.topOffset = CGPoint(x: 0, y: -40)
        self.addressDropDown.dataSource = self.arrAddressArray
        
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "DropDownCell", bundle: Bundle(for: DropDownCell.self))
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                if self.arrAddressArray.count > index {
                    cell.optionLabel.text = self.arrAddressArray[index]
                }
            }
        }
        
        // Action triggered on selection
        self.addressDropDown.selectionAction = { [unowned self] (index, item) in
            
            self.shopAddressTextField.text = self.arrAddressArray[index]
            DispatchQueue.main.async {
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(self.arrAddressArray[index]) {
                    placemarks, error in
                    let placemark = placemarks?.first
                    self.userLat = "\(placemark?.location?.coordinate.latitude ?? 0)"
                    self.userLong = "\(placemark?.location?.coordinate.longitude ?? 0)"
                    print("Lat: \(self.userLat), Lon: \(self.userLong)")
                }
                self.view.endEditing(true)
                /*if self.arrAddressArray.count > 0 && self.arrayPlaceIDs.count > 0 {
                 print(self.arrayPlaceIDs[index])
                 let placeID = self.arrayPlaceIDs[index]
                 //Get address parameters from google place API call
                 self.APICallGooglePlaceDetails(placeID)
                 
                 //self.tableSerachResult.isHidden = true
                 //print(self.selectedAddressString)
                 }*/
            }
        }
    }
    
    // Get All Address Suggestions
    func getAllAddressSuggestions(_ searchString : String){
        
        let placesClient = GMSPlacesClient()
        
        placesClient.findAutocompletePredictions(fromQuery: searchString, filter: nil, sessionToken: nil) { (results, error) in
            self.arrAddressArray.removeAll()
            self.arrayPlaceIDs.removeAll()
            
            if results == nil {
                return
            }
            
            for result in results!{
                if let result = result as? GMSAutocompletePrediction {
                    self.arrAddressArray.append(result.attributedFullText.string)
                    self.arrayPlaceIDs.append(result.placeID)
                }
            }
            
            DispatchQueue.main.async {
                self.addressDropDown.anchorView = self.shopAddressTextField
                self.addressDropDown.bottomOffset = CGPoint(x: 0, y:(self.addressDropDown.anchorView?.plainView.bounds.height)!)
                self.addressDropDown.dataSource = self.arrAddressArray
                self.addressDropDown.show()
            }
        }
    }
    
    // SignUp Validation
    func signUpValidation() -> Bool {
        var isValidate = true
        if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            firstNameValidationLbl.isHidden = false
            firstNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            firstNameValidationLbl.isHidden = true
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
        
        if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            businessNameValidationLbl.isHidden = false
            businessNameValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            businessNameValidationLbl.isHidden = true
        }
        
        if countryCodeLbl.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Select Country Code.")
            isValidate = false
        }
        
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            phoneValidationLbl.isHidden = false
            phoneValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
            phoneValidationLbl.isHidden = false
            phoneValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            phoneValidationLbl.isHidden = true
        }
        
        if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            shopAddressValidationLbl.isHidden = false
            shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopAddressValidationLbl.isHidden = true
        }
        
        if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            fullAddressValidationLbl.isHidden = false
            fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            fullAddressValidationLbl.isHidden = true
        }
        
        if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            shopLicenceValidationLbl.isHidden = false
            shopLicenceValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopLicenceValidationLbl.isHidden = true
        }
        
        if !isRememberMeTap {
            termsValidationLbl.isHidden = false
            termsValidationLbl.text = ValidationManager.shared.acceptTerms
            isValidate = false
        } else {
            termsValidationLbl.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        emailValidationLbl.isHidden = true
        phoneValidationLbl.isHidden = true
        passwordValidationLbl.isHidden = true
        firstNameValidationLbl.isHidden = true
        shopAddressValidationLbl.isHidden = true
        fullAddressValidationLbl.isHidden = true
        shopLicenceValidationLbl.isHidden = true
        businessNameValidationLbl.isHidden = true
        termsValidationLbl.isHidden = true
    }
    
    // Setup Terms and Privacy Tap Label
    func setupMultipleTapLabel() {
        termsAndPrivacyLabel.text = "By Signing up you are agreeing to our Terms of Use and Privacy Policy"
        termsAndPrivacyLabel.textAlignment = .left
        let text = (termsAndPrivacyLabel.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let termsRange = (text as NSString).range(of: "Terms of Use")
        let privacyRange = (text as NSString).range(of: "Privacy Policy")
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.init(hexFromString: "#009EEF"), range: termsRange)
        underlineAttriString.addAttribute(.foregroundColor, value: UIColor.init(hexFromString: "#009EEF"), range: privacyRange)
        termsAndPrivacyLabel.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        termsAndPrivacyLabel.isUserInteractionEnabled = true
        termsAndPrivacyLabel.addGestureRecognizer(tapAction)
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

//MARK:- Extensions -

//MARK: Api Call
extension SignUpViewController {
    
    // SignUp Api
    func signUpApi(){
        let params: Parameters = [
            "email":"\(emailTextField.text ?? "")",
            "extensionNumber":countryCode,
            "contactNumber":"\(mobileNumberTextField.text ?? "")",
            "password":"\(passwordTextField.text ?? "")",
            "firstName":"\(firstNameTextField.text ?? "")",
            "shopAddress": "\(shopAddressTextField.text ?? "")",
            "fullAddress": "\(fullAddressTextField.text ?? "")",
            "businessName": "\(businessNameTextField.text ?? "")",
            "licenceNumber": "\(shopActNoOrLicenceTextField.text ?? "")",
            "fcmToken": "\(deviceFcmToken)",
            "deviceInfo": [
                "deviceType":"iPhone",
                "appVersion":appVersion(),
                "deviceToken":deviceFcmToken,
                "deviceData":"\(UIDevice.modelName)"
            ]
        ]
        print(params)
        showLoading()
        APIHelper.registerUser(bodyParameter: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let newVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
                myApp.window?.rootViewController = newVC
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
}

//MARK: SetUp TapGesture Recognizer
extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, targetText: String) -> Bool {
        guard let attributedString = label.attributedText, let lblText = label.text else { return false }
        let targetRange = (lblText as NSString).range(of: targetText)
        //IMPORTANT label correct font for NSTextStorage needed
        let mutableAttribString = NSMutableAttributedString(attributedString: attributedString)
        mutableAttribString.addAttributes(
            [NSAttributedString.Key.font: label.font ?? UIFont.smallSystemFontSize],
            range: NSRange(location: 0, length: attributedString.length)
        )
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: mutableAttribString)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                          y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y:
                                                        locationOfTouchInLabel.y - textContainerOffset.y);
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
}

//MARK: TextField Delegate Methods
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case firstNameTextField:
            if firstNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                firstNameValidationLbl.isHidden = false
                firstNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                firstNameValidationLbl.isHidden = true
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
        case businessNameTextField:
            if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                businessNameValidationLbl.isHidden = false
                businessNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                businessNameValidationLbl.isHidden = true
            }
        case mobileNumberTextField:
            if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                phoneValidationLbl.isHidden = false
                phoneValidationLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
                phoneValidationLbl.isHidden = false
                phoneValidationLbl.text = ValidationManager.shared.validPhone
            } else {
                phoneValidationLbl.isHidden = true
            }
        case shopAddressTextField:
            if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                shopAddressValidationLbl.isHidden = false
                shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                shopAddressValidationLbl.isHidden = true
            }
        case fullAddressTextField:
            if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                fullAddressValidationLbl.isHidden = false
                fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                fullAddressValidationLbl.isHidden = true
            }
        case shopActNoOrLicenceTextField:
            if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                shopLicenceValidationLbl.isHidden = false
                shopLicenceValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                shopLicenceValidationLbl.isHidden = true
            }
        default:
            break
        }
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if shopAddressTextField == textField{
            return true
        } else{
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.shopAddressTextField {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            print(newString)
            if newString.count == 0 {
                self.arrAddressArray.removeAll()
                self.arrayPlaceIDs.removeAll()
                self.addressDropDown.hide()
            }else{
                DispatchQueue.main.async {
                    self.getAllAddressSuggestions(newString)
                }
            }
        }
        return true
    }
}

//MARK: CLLocationManagerDelegate Methods
extension SignUpViewController: CLLocationManagerDelegate {
    
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {(placemarks, error) in
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        if placemarks == nil {
                                            return
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            var addressString : String = ""
                                            if pm.subLocality != nil {
                                                addressString = addressString + pm.subLocality! + ", "
                                            }
                                            if pm.thoroughfare != nil {
                                                addressString = addressString + pm.thoroughfare! + ", "
                                            }
                                            if pm.locality != nil {
                                                addressString = addressString + pm.locality! + ", "
                                            }
                                            if pm.country != nil {
                                                addressString = addressString + pm.country! + ", "
                                            }
                                            if pm.postalCode != nil {
                                                addressString = addressString + pm.postalCode! + " "
                                            }
                                            
                                            self.userAddress = addressString
                                            print(addressString)
                                            self.shopAddressTextField.text = addressString
                                        }
                                    })
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function)
        if let location = locations.first {
            currentLoc = location
            self.userLat = "\(location.coordinate.latitude)"
            self.userLong = "\(location.coordinate.longitude)"
            manager.stopUpdatingLocation()
            
        }
    }
    
}
