//
//  AddProductViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 11/12/21.
//

import UIKit
import Alamofire
import SDWebImage


class AddProductViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productNameTextField: UITextField! {
        didSet {
            productNameTextField.delegate = self
            productNameTextField.becomeFirstResponder()
        }
    }
    @IBOutlet weak var categoryDropDownTextField: CustomDropDown!
    @IBOutlet weak var subCategoryDropDownTextField: CustomDropDown!
    @IBOutlet weak var actualPriceTextField: UITextField! {
        didSet{
            actualPriceTextField.delegate = self
        }
    }
    @IBOutlet weak var dealPriceTextField: UITextField! {
        didSet{
            dealPriceTextField.delegate = self
        }
    }
    @IBOutlet weak var quantityTextField: UITextField! {
        didSet{
            quantityTextField.delegate = self
        }
    }
    @IBOutlet weak var taxDropDownTextField: CustomDropDown!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addAndUpdateProductBtn: UIButton!
    @IBOutlet weak var productNameValidationLbl: UILabel!
    @IBOutlet weak var categoryValidationLbl: UILabel!
    @IBOutlet weak var subcategoryValidationLbl: UILabel!
    @IBOutlet weak var actualPriceValidationLbl: UILabel!
    @IBOutlet weak var dealPriceValidationLbl: UILabel!
    @IBOutlet weak var taxationValidationLbl: UILabel!
    @IBOutlet weak var quantityValidationLbl: UILabel!
    @IBOutlet weak var descriptionValidationLbl: UILabel!
    
    
    var imagePicker = UIImagePickerController()
    var titleLabel = ""
    var categoryList: CategoryList?
    var categoryListItems: [CategoryItems]?
    var subCategoryList : SubCategoryList?
    var categoryData:[String] = []
    var subCategoryData:[String] = []
    var taxData: [String] = []
    var pageSize: Int = 10
    var isUpdate = false
    var productItem: Items?
    var subCategoryByCategory: [SubCategoryItem]?
    var categoryId : String?
    var subCategoryId: String?
    var taxID: String?
    var productImage: UIImage?
    var taxList: [TaxList]?
    var placeHolder = ""
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.validationLabelManage()
        headerLabel.text = titleLabel
        placeHolder = "Type Here"
        descriptionTextView.delegate = self
        descriptionTextView.text = placeHolder
        if descriptionTextView.text == placeHolder {
            descriptionTextView.textColor = .lightGray
        } else {
            descriptionTextView.textColor = .black
        }
        self.addAndUpdateProductBtn.setTitle(isUpdate == true ? "UPDATE PRODUCT" : "ADD PRODUCT", for: .normal)
        imagePicker.delegate = self
//        self.getAllActiveTaxApi()
//        getAllCategories(pageSize: pageSize)
        self.getInTaxDropDownApi()
        self.getInCategoryDropdownApi()
        getSubCategories()
        if isUpdate {
            setProductData()
        }
    }
    
    //MARK:- Selectors -
    
    //Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //Upload Image Button Action
    @IBAction func uploadImageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title:"", message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title:"Choose Existing", style: .default) { (action) in
            self.openPhotos()
        }
        let okAction2 = UIAlertAction(title:"Take Photo", style: .default) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Add ProductButton Action
    @IBAction func addProductButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.addProductValidation() {
            if isUpdate == false {
                if productImage == nil {
                    self.alertViewController(message: "Please Select Product Image")
                    return
                }
            }
            self.validationLabelManage()
            isUpdate == true ? self.updateProductApi() : self.addNewProductApi()
        }
        
    }
    
    //    MARK: - helper Functions -
    
    // Add Product Validation
    func addProductValidation() -> Bool {
        var isValidate = true
        if productNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            productNameValidationLbl.isHidden = false
            productNameValidationLbl.text =  ValidationManager.shared.emptyProductName
            isValidate = false
            
        } else if productNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
            productNameValidationLbl.isHidden = false
            productNameValidationLbl.text =  ValidationManager.shared.productNameLength
            isValidate = false
        } else {
            productNameValidationLbl.isHidden = true
        }
        
        if categoryDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            categoryValidationLbl.isHidden = false
            categoryValidationLbl.text = ValidationManager.shared.selectCategory
            isValidate = false
        } else {
            categoryValidationLbl.isHidden = true
        }
        
        if subCategoryDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            subcategoryValidationLbl.isHidden = false
            subcategoryValidationLbl.text = ValidationManager.shared.selectSubCategory
            isValidate = false
        } else {
            subcategoryValidationLbl.isHidden = true
        }
        
        if actualPriceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 || actualPriceTextField.text == "0" {
            actualPriceValidationLbl.isHidden = false
            actualPriceValidationLbl.text = ValidationManager.shared.emptyActualPrice
            isValidate = false
        } else {
            actualPriceValidationLbl.isHidden = true
        }
    
        if dealPriceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 || dealPriceTextField.text == "0" {
            dealPriceValidationLbl.isHidden = false
            dealPriceValidationLbl.text = ValidationManager.shared.emptyDealprice
            isValidate = false
        } else {
            dealPriceValidationLbl.isHidden = true
        }
        
        if taxDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            taxationValidationLbl.isHidden = false
            taxationValidationLbl.text = ValidationManager.shared.chooseTax
            isValidate = false
        } else {
            taxationValidationLbl.isHidden = true
        }
        
        if quantityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 || quantityTextField.text == "0"{
            quantityValidationLbl.isHidden = false
            quantityValidationLbl.text = ValidationManager.shared.emptyQuantity
            isValidate = false
        } else {
            quantityValidationLbl.isHidden = true
        }
        
        if descriptionTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || descriptionTextView.text == placeHolder {
            descriptionValidationLbl.isHidden = false
            descriptionValidationLbl.text = ValidationManager.shared.emptyProductDescription
            isValidate = false
        } else {
            descriptionValidationLbl.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Validation Label Manage
    func validationLabelManage() {
        productNameValidationLbl.isHidden = true
        categoryValidationLbl.isHidden = true
        subcategoryValidationLbl.isHidden = true
        actualPriceValidationLbl.isHidden = true
        dealPriceValidationLbl.isHidden = true
        taxationValidationLbl.isHidden = true
        quantityValidationLbl.isHidden = true
        descriptionValidationLbl.isHidden = true
    }
    
    //Set Product Data
    func setProductData() {
        productImageView.sd_setImage(with: URL(string: productItem?.image ?? ""), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        productNameTextField.text = productItem?.name
        actualPriceTextField.text = "\(productItem?.actualPrice ?? 0.0)"
        quantityTextField.text = "\(productItem?.stockCount ?? 0)"
        dealPriceTextField.text = "\(productItem?.dealPrice ?? 0.0)"
        descriptionTextView.text = productItem?.description
        if descriptionTextView.text == placeHolder {
            descriptionTextView.textColor = .lightGray
        } else {
            descriptionTextView.textColor = .black
        }
    }
    
    // SetUp Category Drop Down
    func setUpCategoryDropDown() {
        categoryDropDownTextField.optionArray = categoryData
        categoryDropDownTextField.checkMarkEnabled = false
        categoryDropDownTextField.didSelect{(selectedText , index , id) in
            for i in self.categoryListItems ?? [] {
                if i.name == selectedText {
                    self.categoryId = i.id
                    self.getSubcategoryByCategoryApi(i.id ?? "")
                }
            }
        }
        categoryDropDownTextField.isSearchEnable = true
        categoryDropDownTextField.arrow.isHidden = true
        categoryDropDownTextField.arrowSize = 0
        categoryDropDownTextField.listDidDisappear {
            if self.categoryDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                self.categoryValidationLbl.isHidden = false
                self.categoryValidationLbl.text = ValidationManager.shared.selectCategory
            } else {
                self.categoryValidationLbl.isHidden = true
            }
        }
    }
    
    // SetUp SubCategory Drop Down
    func setUpSubCategoryDropDown() {
        subCategoryDropDownTextField.optionArray = subCategoryData
        subCategoryDropDownTextField.checkMarkEnabled = false
        subCategoryDropDownTextField.didSelect{(selectedText , index , id) in
            for i in self.subCategoryList?.items ?? [] {
                if i.name == selectedText {
                    self.subCategoryId = i.id
                }
            }
        }
        subCategoryDropDownTextField.arrowSize = 0
        subCategoryDropDownTextField.isSearchEnable = true
        subCategoryDropDownTextField.arrow.isHidden = true
        subCategoryDropDownTextField.listDidDisappear {
            if self.subCategoryDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                self.subcategoryValidationLbl.isHidden = false
                self.subcategoryValidationLbl.text = ValidationManager.shared.selectSubCategory
            } else {
                self.subcategoryValidationLbl.isHidden = true
            }
        }
    }
    
    // SetUp Tax Drop Down
    func setUpTaxDropDown() {
        taxDropDownTextField.optionArray = taxData
        taxDropDownTextField.checkMarkEnabled = false
        taxDropDownTextField.didSelect{(selectedText , index , id) in
            for i in self.taxList ?? [] {
                if "\(i.hsnCode ?? "") - \(i.taxPercentage ?? 0.0)%" == selectedText {
                    self.taxID = i.id
                    return
                }
            }
        }
        taxDropDownTextField.arrowSize = 0
        taxDropDownTextField.isSearchEnable = true
        taxDropDownTextField.arrow.isHidden = true
        taxDropDownTextField.listDidDisappear {
            if self.taxDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                self.taxationValidationLbl.isHidden = false
                self.taxationValidationLbl.text = ValidationManager.shared.chooseTax
            } else {
                self.taxationValidationLbl.isHidden = true
            }
        }
    }
    
    //Open Camera
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
    
    //Open Image Gallary
    func openPhotos(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Extensions -

//MARK: Api Call
extension AddProductViewController {
    
    // Get All Active Tax
    func getAllActiveTaxApi() {
        showLoading()
        APIHelper.getAllActiveTax(parameters: [:]) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.taxList = data.arrayValue.map({(TaxList(json: $0))})
                self.taxData.removeAll()
                for item in self.taxList ?? [] {
                    self.taxData.append("\(item.taxPercentage ?? 0.0)")
                }
                print(self.taxData)
                self.setUpTaxDropDown()
                if self.isUpdate {
                    self.taxID = self.productItem?.taxId
                    for(_, item) in (self.taxList ?? []).enumerated() {
                        if item.id == self.productItem?.taxId {
                            self.taxDropDownTextField.text = "\(item.taxPercentage ?? 0.0)"
                        }
                    }
                }
                let message = response.message
                print(message)
            }
        }
    }
    
    
    // Get In Tax Drop Down Api
    func getInTaxDropDownApi() {
        let params: Parameters = [
            "asc":"true",
            "sortBy":"hsnCode",
            "isActive":"true"
        ]
        showLoading()
        APIHelper.getInTaxDropDownApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.taxList = data.arrayValue.map({(TaxList(json: $0))})
                self.taxData.removeAll()
                for item in self.taxList ?? [] {
                    self.taxData.append("\(item.hsnCode ?? "") - \(item.taxPercentage ?? 0.0)%")
                }
                print(self.taxData)
                self.setUpTaxDropDown()
                if self.isUpdate {
                    self.taxID = self.productItem?.taxId
                    for(_, item) in (self.taxList ?? []).enumerated() {
                        if item.id == self.productItem?.taxId {
                            self.taxDropDownTextField.text = "\(item.hsnCode ?? "") - \(item.taxPercentage ?? 0.0)%"
                        }
                    }
                }
                let message = response.message
                print(message)
            }
        }
    }
    
    // Get All Category Api
    func getAllCategories(pageSize: Int) {
        showLoading()
        let params: Parameters = [
            "pageSize":pageSize,
            "filterByIsActive":true,
            "sortBy":"name",
            "asc":true
            
        ]
        APIHelper.getAllCategoriesAPI(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.categoryList = CategoryList.init(json: data)
                self.categoryData.removeAll()
                for item in self.categoryList?.items ?? [] {
                    self.categoryData.append(item.name ?? "")
                }
                print(self.categoryData)
                self.pageSize = self.categoryList?.totalItems ?? 0
                self.setUpCategoryDropDown()
                if self.isUpdate {
                    self.categoryId = self.productItem?.categoryId
                    for (_, item) in (self.categoryList?.items ?? []).enumerated() {
                        if item.id == self.productItem?.categoryId {
                            self.categoryDropDownTextField.text = item.name
                        }
                    }
                }
                let message = response.message
                print(message)
            }
        }
    }
    
    // Get All Category Api
    func getInCategoryDropdownApi() {
        showLoading()
        let params: Parameters = [
            "isActive":true,
            "sortBy":"name",
            "asc":true
        ]
        APIHelper.getInCategoryDropdownApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.categoryListItems = data.arrayValue.map({(CategoryItems(json: $0))})
                self.categoryData.removeAll()
                for item in self.categoryListItems ?? [] {
                    self.categoryData.append(item.name ?? "")
                }
                print(self.categoryData)
                
                self.setUpCategoryDropDown()
                if self.isUpdate {
                    self.categoryId = self.productItem?.categoryId
                    for (_, item) in (self.categoryListItems ?? []).enumerated() {
                        if item.id == self.productItem?.categoryId {
                            self.categoryDropDownTextField.text = item.name
                        }
                    }
                }
                let message = response.message
                print(message)
            }
        }
    }
    
    // Get All Sub Category Api
    func getSubCategories() {
        let params: Parameters = [
            "pageSize":pageSize,
            "filterByIsActive":true,
            "sortBy":"name",
            "asc":true
        ]
        showLoading()
        APIHelper.getSubCategoriesApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.subCategoryList = SubCategoryList.init(json: data)
                self.subCategoryData.removeAll()
                for item in self.subCategoryList?.items ?? [] {
                    self.subCategoryData.append(item.name ?? "")
                }
                print(self.subCategoryData)
                self.setUpSubCategoryDropDown()
                if self.isUpdate {
                    self.subCategoryId = self.productItem?.subCategoryId
                    for (_, item) in (self.subCategoryList?.items ?? []).enumerated() {
                        if item.id == self.productItem?.subCategoryId {
                            self.subCategoryDropDownTextField.text = item.name
                        }
                    }
                }
                let message = response.message
                print(message)
            }
        }
    }
    
    // Get SubCategory By Category
    func getSubcategoryByCategoryApi(_ id: String) {
        let params: Parameters = [
            "categoryId":id,
            "filterByIsActive":true,
            "sortBy":"name",
            "asc":true
        ]
        showLoading()
        APIHelper.getSubCategoriesByCategoryApi(parameters:params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.subCategoryByCategory = data.arrayValue.map({(SubCategoryItem(json: $0))})
                self.subCategoryData.removeAll()
                for item in self.subCategoryByCategory ?? [] {
                    self.subCategoryData.append(item.name ?? "")
                }
                print(self.subCategoryData)
                self.setUpSubCategoryDropDown()
                let message = response.message
                print(message)
            }
        }
    }
    
    // Update Product Api
    func updateProductApi() {
        var imgData: Data?
        let bodyParams: Parameters = [
            "product": [
                "productId":"\(productItem?.productId ?? "")",
                "name": "\(productNameTextField.text ?? "")",
                "description": "\(descriptionTextView.text ?? "")",
                "categoryId": "\(categoryId ?? "")",
                "subCategoryId": "\(subCategoryId ?? "")",
                "actualPrice": "\(actualPriceTextField.text ?? "")",
                "dealPrice": "\(dealPriceTextField.text ?? "")",
                "taxId": taxID ?? "",
                "stockCount": quantityTextField.text ?? "",
                "merchantId": "\(AppManager.shared.merchantId)"
            ]
        ]
        showLoading()
        if productImage != nil {
            imgData = self.productImage?.jpegData(compressionQuality: 0.1)
        }
        
        showLoading()
        APIHelper.updateProductDetails(urlParams: [:], bodyParams:bodyParams, imgData: imgData, imageKey: "file") { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                NotificationCenter.default.post(name:Notification.Name("reloadGetProductListApi"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
        
    // Add New Product Api
    func addNewProductApi() {
        var imgData: Data?
        let bodyParams: Parameters = [
            "product": [
                "name": productNameTextField.text ?? "",
                "description": descriptionTextView.text ?? "",
                "categoryId": categoryId ?? "",
                "subCategoryId": subCategoryId ?? "",
                "actualPrice": actualPriceTextField.text ?? "",
                "dealPrice":  dealPriceTextField.text ?? "",
                "merchantId": AppManager.shared.merchantId,
                "stockCount": quantityTextField.text ?? "",
                "taxId": taxID ?? ""
            ]
        ]
        if productImage != nil {
            imgData = self.productImage?.jpegData(compressionQuality: 0.1)
        }
        showLoading()
        APIHelper.addNewProductApi(urlParams: [:], bodyParams: bodyParams, imgData: imgData, imageKey: "file") { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                  myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:Notification.Name("reloadGetProductListApi"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK: Image Picker Delegate Methods
extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            self.productImage = image
            productImageView.contentMode = .scaleAspectFill
            productImageView.image = self.productImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: TextView Delegate Methods
extension AddProductViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeHolder {
            textView.text = ""
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.text = nil
            
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.isSelectable = true
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        } else {
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
            descriptionValidationLbl.isHidden = false
            descriptionValidationLbl.text = ValidationManager.shared.emptyProductDescription
        } else {
            textView.isSelectable = true
            descriptionValidationLbl.isHidden = true
        }
    }
    
}

//MARK: UITextField Delegate Methods
extension AddProductViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case productNameTextField:
            if productNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                productNameValidationLbl.isHidden = false
                productNameValidationLbl.text =  ValidationManager.shared.emptyProductName
            } else if productNameTextField.text?.trimmingCharacters(in: .whitespaces).count ?? 0 < 3 {
                productNameValidationLbl.isHidden = false
                productNameValidationLbl.text =  ValidationManager.shared.productNameLength
            } else {
                productNameValidationLbl.isHidden = true
            }
        case categoryDropDownTextField:
            if categoryDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                categoryValidationLbl.isHidden = false
                categoryValidationLbl.text = ValidationManager.shared.selectCategory
            } else {
                categoryValidationLbl.isHidden = true
            }
        case subCategoryDropDownTextField:
            if subCategoryDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                subcategoryValidationLbl.isHidden = false
                subcategoryValidationLbl.text = ValidationManager.shared.selectSubCategory
            } else {
                subcategoryValidationLbl.isHidden = true
            }
        case actualPriceTextField:
            if actualPriceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 || actualPriceTextField.text == "0" {
                actualPriceValidationLbl.isHidden = false
                actualPriceValidationLbl.text = ValidationManager.shared.emptyActualPrice
            } else {
                actualPriceValidationLbl.isHidden = true
            }
        case dealPriceTextField:
            if dealPriceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 || dealPriceTextField.text == "0" {
                dealPriceValidationLbl.isHidden = false
                dealPriceValidationLbl.text = ValidationManager.shared.emptyDealprice
            } else {
                dealPriceValidationLbl.isHidden = true
            }
        case taxDropDownTextField:
            if taxDropDownTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                taxationValidationLbl.isHidden = false
                taxationValidationLbl.text = ValidationManager.shared.chooseTax
            } else {
                taxationValidationLbl.isHidden = true
            }
        case quantityTextField:
            if quantityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 || quantityTextField.text == "0"{
                quantityValidationLbl.isHidden = false
                quantityValidationLbl.text = ValidationManager.shared.emptyQuantity
            } else {
                quantityValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
}
