//
//  ProfileViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import Alamofire
import SDWebImage
import DropDown
import GooglePlaces
import GoogleMaps
import CoreLocation

class ProfileViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var emailTextField: UITextField! {
        didSet {
            emailTextField.delegate = self
        }
    }
    @IBOutlet weak var businessNameTextField: UITextField! {
        didSet {
            businessNameTextField.delegate = self
        }
    }
    @IBOutlet weak var mobileNumberTextField: UITextField!  {
        didSet {
            mobileNumberTextField.delegate = self
        }
    }
    @IBOutlet weak var shopAddressTextField: UITextField!  {
        didSet {
            shopAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var fullAddressTextField: UITextField!  {
        didSet {
            fullAddressTextField.delegate = self
        }
    }
    @IBOutlet weak var shopActNoOrLicenceTextField: UITextField!  {
        didSet {
            shopActNoOrLicenceTextField.delegate = self
        }
    }
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var emailValidationLbl: UILabel!
    @IBOutlet weak var businessNameValidationLbl: UILabel!
    @IBOutlet weak var mobileValidationLbl: UILabel!
    @IBOutlet weak var shopAddressValidationLbl: UILabel!
    @IBOutlet weak var fullAddressValidationLbl: UILabel!
    @IBOutlet weak var shopLicenceValidationLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var countryFlagImgView: UIImageView!
    @IBOutlet weak var emailVerifyBtn: UIButton!
    @IBOutlet weak var mobileVerifyBtn: UIButton!
    
    var countryList : CountryList?
    var countryCode = "+91"
    var countryFlag = ""
    var isEmailVarified = true
    var isMobileVarified = false
    var imagePicker = UIImagePickerController()
    var locationManager = CLLocationManager()
    var geoCoder:GMSGeocoder!
    var userAddress = ""
    var userLat = ""
    var userLong = ""
    var currentLoc: CLLocation?
    private let GOOGLE_API_KEY = "AIzaSyBeoznMh_ffRxbTLA_bsWxZf35NDCaXhC0"
    let addressDropDown = DropDown()
    var arrAddressArray = [String]()
    lazy var dropDowns: [DropDown] = {
        return [
            self.addressDropDown
        ]
    }()
    var arrayPlaceIDs = [String]()
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.emailVarifyFlow()
        self.mobileVerifyButtonFlow()
        self.setUpCountryCodeData()
        self.validationLabelManage()
        self.setMerchantDetailsData()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setMerchantDetailsData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setMerchantDetailsData),name:Notification.Name("setMerchantDetailsData"), object: nil)
        
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
    
    //Back Button Action
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Save Button Action
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if self.profileValidation() {
            self.validationLabelManage()
            self.updateMerchantProfile()
        }
    }
    
    // Edit Image Button Action
    @IBAction func editImageButton(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "ChooseExisting", style: .default) { (action) in
            self.openPhotos()
        }
        let okAction2 = UIAlertAction(title: "TakePhoto", style: .default) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Country Code Button Action
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
    
    // Email Verify And Update Button Action
    @IBAction func emailVerifyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isEmailVarified = !isEmailVarified
        emailVarifyFlow()
        if isEmailVarified {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as? VerifyOtpViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        } else {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController)!
            newVC.isEmailVerify = true
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
    }
    
    // Mobile Number Verify And Update Button Action
    @IBAction func mobileVerifyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        isMobileVarified = !isMobileVarified
        mobileVerifyButtonFlow()
        if isMobileVarified {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyOtpViewController") as? VerifyOtpViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        } else {
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as? VerifyViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Functions -
    
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
    
    // Profile Validation
    func profileValidation() -> Bool {
        var isValidate = true
        if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            emailValidationLbl.textColor = UIColor.red
            emailValidationLbl.text = ValidationManager.shared.emptyEmail
            isValidate = false
        } else if !isValidEmail(emailTextField.text ?? ""){
            emailValidationLbl.textColor = UIColor.red
            emailValidationLbl.text = ValidationManager.shared.validEmail
            isValidate = false
        } else {
            emailVarifyFlow()
        }
        
        if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
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
        
        if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            mobileValidationLbl.textColor = UIColor.red
            mobileValidationLbl.text = ValidationManager.shared.emptyPhone
            isValidate = false
        } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
            mobileValidationLbl.textColor = UIColor.red
            mobileValidationLbl.text = ValidationManager.shared.validPhone
            isValidate = false
        } else {
            mobileVerifyButtonFlow()
        }
        
        if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            shopAddressValidationLbl.isHidden = false
            shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopAddressValidationLbl.isHidden = true
        }
        
        if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            fullAddressValidationLbl.isHidden = false
            fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            fullAddressValidationLbl.isHidden = true
        }
        
        if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            shopLicenceValidationLbl.isHidden = false
            shopLicenceValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            shopLicenceValidationLbl.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        businessNameValidationLbl.isHidden = true
        shopAddressValidationLbl.isHidden = true
        fullAddressValidationLbl.isHidden = true
        shopLicenceValidationLbl.isHidden = true
    }
    
    // Email Verify SetUp
    func emailVarifyFlow() {
        if isEmailVarified {
            emailTextField.isUserInteractionEnabled = false
            emailTextField.textColor = UIColor.darkGray
            emailValidationLbl.text = "Verified"
            emailValidationLbl.textColor = UIColor.init(hexFromString: "2878B6")
            emailVerifyBtn.setTitle("UPDATE", for: .normal)
        } else {
            emailTextField.isUserInteractionEnabled = false
            emailTextField.textColor = UIColor.darkGray
            emailValidationLbl.textColor = UIColor.orange
            emailValidationLbl.text = "Verification Pending"
            emailVerifyBtn.setTitle("Verify", for: .normal)
        }
    }
    
    // Mobile Number Verify SetUp
    func mobileVerifyButtonFlow() {
        if isMobileVarified {
            mobileNumberTextField.isUserInteractionEnabled = false
            mobileNumberTextField.textColor = UIColor .darkGray
            mobileValidationLbl.text = "Verified"
            mobileValidationLbl.textColor = UIColor.init(hexFromString: "2878B6")
            mobileVerifyBtn.setTitle("UPDATE", for: .normal)
        } else {
            mobileNumberTextField.isUserInteractionEnabled = false
            mobileNumberTextField.textColor = UIColor .darkGray
            mobileValidationLbl.text = "Verification Pending"
            mobileValidationLbl.textColor = UIColor.orange
            mobileVerifyBtn.setTitle("Verify", for: .normal)
        }
    }
    
    //Set Merchant Details Data
    @objc func setMerchantDetailsData() {
        businessNameLabel.text = merchantDetails?.businessName
        emailTextField.text = merchantDetails?.email
        businessNameTextField.text = merchantDetails?.businessName
        mobileNumberTextField.text = merchantDetails?.contactNumber
        shopAddressTextField.text = merchantDetails?.shopAddress
        fullAddressTextField.text = merchantDetails?.fullAddress
        shopActNoOrLicenceTextField.text = merchantDetails?.licenceNumber
        profileImgView.sd_setImage(with: URL(string: merchantDetails?.profilePicture ?? ""), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
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
    
    // Open Photo Gallary
    func openPhotos(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Open Camera
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "Camera Not Supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

//MARK:- Extensions -

//MARK: Api Call
extension ProfileViewController {
    
    // Update Profile Api
    func updateMerchantProfile() {
        let params: Parameters = [
            "id":AppManager.shared.merchantUserId,
            "email":emailTextField.text ?? "",
            "extensionNumber":countryCode,
            "contactNumber":mobileNumberTextField.text ?? "",
            "shopAddress":shopAddressTextField.text ?? "",
            "fullAddress":fullAddressTextField.text ?? "",
            "businessName":businessNameTextField.text ?? "",
            "licenceNumber":shopActNoOrLicenceTextField.text ?? ""
        ]
        showLoading()
        APIHelper.updateMerchantDetails(params: params) { (success,response)  in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:Notification.Name("getMerchantDetailsByIdApi"), object: self)
            }
        } 
    }
    
}

//MARK: TextField Delegate Methods
extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            if emailTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                emailValidationLbl.textColor = UIColor.red
                emailValidationLbl.text = ValidationManager.shared.emptyEmail
            } else if !isValidEmail(emailTextField.text ?? ""){
                emailValidationLbl.textColor = UIColor.red
                emailValidationLbl.text = ValidationManager.shared.validEmail
            } else {
                emailValidationLbl.textColor = UIColor.orange
                emailValidationLbl.text = "Varification Pending"
            }
        case businessNameTextField:
            if businessNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                businessNameValidationLbl.isHidden = false
                businessNameValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                businessNameValidationLbl.isHidden = true
            }
        case mobileNumberTextField:
            if mobileNumberTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                mobileValidationLbl.textColor = UIColor.red
                mobileValidationLbl.text = ValidationManager.shared.emptyPhone
            } else if !isValidMobileNumber(mobileNumber: mobileNumberTextField.text ?? "") {
                mobileValidationLbl.textColor = UIColor.red
                mobileValidationLbl.text = ValidationManager.shared.validPhone
            } else {
                mobileValidationLbl.textColor = UIColor.orange
                mobileValidationLbl.text = "Varification Pending"
            }
        case shopAddressTextField:
            if shopAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                shopAddressValidationLbl.isHidden = false
                shopAddressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                shopAddressValidationLbl.isHidden = true
            }
        case fullAddressTextField:
            if fullAddressTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
                fullAddressValidationLbl.isHidden = false
                fullAddressValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                fullAddressValidationLbl.isHidden = true
            }
        case shopActNoOrLicenceTextField:
            if shopActNoOrLicenceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
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

//MARK: Image Picker Delegate Methods
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            profileImgView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
}

//MARK: CLLocationManagerDelegate Methods
extension ProfileViewController: CLLocationManagerDelegate {
    
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

