//
//  AddProductViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 11/12/21.
//

import UIKit
import DropDown
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
    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var chooseProductCategoryTextField: UITextField!
    @IBOutlet weak var chooseProductSubCategoryTextField: UITextField!
    @IBOutlet weak var actualPriceTextField: UITextField!
    @IBOutlet weak var dealPriceTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var addAndUpdateProductBtn: UIButton!
    @IBOutlet weak var taxationTextField: UITextField!
    @IBOutlet weak var productNameValidationLbl: UILabel!
    @IBOutlet weak var categoryValidationLbl: UILabel!
    @IBOutlet weak var subcategoryValidationLbl: UILabel!
    @IBOutlet weak var actualPriceValidationLbl: UILabel!
    @IBOutlet weak var dealPriceValidationLbl: UILabel!
    @IBOutlet weak var taxationValidationLbl: UILabel!
    @IBOutlet weak var quantityValidationLbl: UILabel!
    @IBOutlet weak var descriptionValidationLbl: UILabel!
    
    var imagePicker = UIImagePickerController()
    var categoryDropDown = DropDown()
    var subCategoryDropDown = DropDown()
    var taxDropDown = DropDown()
    var titleLabel = ""
    var categoryList: CategoryList?
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
        self.getAllActiveTaxApi()
        getAllCategories(pageSize: pageSize)
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
    
    //Product Category DropDown
    @IBAction func productCategoryDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001 {
            categoryDropDown.show()
        }else {
            subCategoryDropDown.show()
        }
    }
    
    @IBAction func taxDataDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        taxDropDown.show()
    }
    
    //Upload Image Button Action
    @IBAction func uploadImageButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title:NSLocalizedString("title", comment: ""), message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: NSLocalizedString("ChooseExisting", comment: ""), style: .default) { (action) in
            self.openPhotos()
        }
        let okAction2 = UIAlertAction(title: NSLocalizedString("TakePhoto", comment: ""), style: .default) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
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
        
        if chooseProductCategoryTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            categoryValidationLbl.isHidden = false
            categoryValidationLbl.text = ValidationManager.shared.selectCategory
            isValidate = false
        } else {
            categoryValidationLbl.isHidden = true
        }
        
        if chooseProductSubCategoryTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
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
        
        if taxationTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
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
    
    // SetUp Category Drop Down
    func setupCategoryDropDown() {
        categoryDropDown.anchorView = chooseProductCategoryTextField
        categoryDropDown.dataSource = categoryData
        categoryDropDown.backgroundColor = .white
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.chooseProductCategoryTextField.text = item
            self.chooseProductSubCategoryTextField.text = nil
            for i in self.categoryList?.items ?? [] {
                if i.name == item {
                    categoryId = i.id
                    getSubcategoryByCategoryApi(i.id ?? "")
                }
            }
            self.view.endEditing(true)
            self.categoryDropDown.hide()
        }
        categoryDropDown.bottomOffset = CGPoint(x: -10, y: 50)
        categoryDropDown.width = chooseProductCategoryTextField.frame.width + 60
        categoryDropDown.direction = .bottom
    }
    
    // Setup Tax Data Drop Down
    func setUpTaxDataDropDown() {
        taxDropDown.anchorView = taxationTextField
        taxDropDown.dataSource = taxData
        taxDropDown.backgroundColor = .white
        taxDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.taxationTextField.text = item
            for i in self.taxList ?? [] {
                if "\(i.taxPercentage ?? 0.0)" == item {
                    taxID = i.id
                    return
                }
            }
            self.view.endEditing(true)
            self.taxDropDown.hide()
        }
        taxDropDown.bottomOffset = CGPoint(x: -10, y: 50)
        taxDropDown.width = taxationTextField.frame.width + 20
        taxDropDown.direction = .bottom
    }
    
    // SetUp Sub Category Drop Down
    func subCategoryDropDownSetup() {
        subCategoryDropDown.anchorView = chooseProductSubCategoryTextField
        subCategoryDropDown.dataSource = self.subCategoryData
        subCategoryDropDown.backgroundColor = .white
        subCategoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.chooseProductSubCategoryTextField.text = item
            for i in self.subCategoryList?.items ?? [] {
                if i.name == item {
                    subCategoryId = i.id
                }
            }
            self.view.endEditing(true)
            self.subCategoryDropDown.hide()
        }
        subCategoryDropDown.bottomOffset = CGPoint(x: -10, y: 50)
        subCategoryDropDown.width = chooseProductSubCategoryTextField.frame.width + 60
        subCategoryDropDown.direction = .bottom
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
                self.setUpTaxDataDropDown()
                if self.isUpdate {
                    self.taxID = self.productItem?.taxId
                    for(_, item) in (self.taxList ?? []).enumerated() {
                        if item.id == self.productItem?.taxId {
                            self.taxationTextField.text = "\(item.taxPercentage ?? 0.0)"
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
            "filterByIsActive":true
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
                self.setupCategoryDropDown()
                if self.isUpdate {
                    self.categoryId = self.productItem?.categoryId
                    for (_, item) in (self.categoryList?.items ?? []).enumerated() {
                        if item.id == self.productItem?.categoryId {
                            self.chooseProductCategoryTextField.text = item.name
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
            "filterByIsActive":true
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
                self.subCategoryDropDownSetup()
                if self.isUpdate {
                    self.subCategoryId = self.productItem?.subCategoryId
                    for (_, item) in (self.subCategoryList?.items ?? []).enumerated() {
                        if item.id == self.productItem?.subCategoryId {
                            self.chooseProductSubCategoryTextField.text = item.name
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
            "categoryId":id
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
                self.subCategoryDropDownSetup()
                let message = response.message
                print(message)
            }
        }
    }
    
    // Update Product Api
    func updateProductApi() {
        var imgData: Data?
        let params: Parameters = [
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
        APIHelper.updateProductDetails(params: params, imgData: imgData, imageKey: "file") { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
        
    // Add New Product Api
    func addNewProductApi() {
        var imgData: Data?
        let params: Parameters = [
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
        APIHelper.addNewProductApi(params: params, imgData: imgData, imageKey: "file") { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                  myApp.window?.rootViewController?.view.makeToast(message)
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
        
        return true
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
        } else {
            textView.isSelectable = true
        }
    }
    
}
