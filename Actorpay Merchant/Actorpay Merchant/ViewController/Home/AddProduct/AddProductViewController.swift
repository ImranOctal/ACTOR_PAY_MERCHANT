//
//  AddProductViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 11/12/21.
//

import UIKit
import DropDown
import Alamofire

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
    
    var imagePicker = UIImagePickerController()
    var categoryDropDown = DropDown()
    var subCategoryDropDown = DropDown()
    var titleLabel = ""
    var categoryData: ProductList?
    var categoryList:[String] = []
    var subCategoryList:[String] = []
    var pageSize: Int = 10
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.text = titleLabel
        descriptionTextView.placeholder = "Description"
        imagePicker.delegate = self
        setupCategoryDropDown()
        subCategoryDropDownSetup()
        getAllCategories(pageSize: pageSize)
    }
    
    //MARK:- Selectors -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func productCategoryDropDown(_ sender: UIButton) {
        self.view.endEditing(true)
        if sender.tag == 1001 {
            getAllCategories(pageSize: pageSize)
            categoryDropDown.show()
        }else {
            subCategoryDropDown.show()
        }
    }
    
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
    
    @IBAction func addProductButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        // Validation
        if productNameTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an Product name.")
            return
        }
        if chooseProductCategoryTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please select a choose Product Category.")
            return
        }
        if actualPriceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter an Actual Price.")
            return
        }
        if dealPriceTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a Deal Price.")
            return
        }
        if quantityTextField.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a Quantity.")
            return
        }
        if descriptionTextView.text?.trimmingCharacters(in: .whitespaces).count == 0{
            self.alertViewController(message: "Please Enter a Product Description.")
            return
        }
        /// Add Product
    }
    
    //    MARK: - helper Functions -
    
    func getAllCategories(pageSize: Int) {
        startAnimationLoader()
        let params: Parameters = [
            "pageSize":pageSize
        ]
        APIHelper.getAllCategoriesAPI(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.categoryData = ProductList.init(json: data)
                self.categoryList.removeAll()
                for item in self.categoryData?.items ?? [] {
                    self.categoryList.append(item.name ?? "")
                }
                print(self.categoryList)
                self.pageSize = self.categoryData?.totalItems ?? 0
                self.setupCategoryDropDown()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
    
    func getSubCategories(id: String) {
        let params: Parameters = [
            "categoryId":id
        ]
        startAnimationLoader()
        APIHelper.getSubCategoriesAPI(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                self.subCategoryList.removeAll()
                self.subCategoryList = data.arrayValue.map({(Items(json: $0).name ?? "")})
                print(self.subCategoryList)
                self.subCategoryDropDownSetup()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
    
    func setupCategoryDropDown(){
        // Category Drop Down
        categoryDropDown.anchorView = chooseProductCategoryTextField
        categoryDropDown.dataSource = categoryList
        categoryDropDown.backgroundColor = .white
        categoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.chooseProductCategoryTextField.text = item
            self.chooseProductSubCategoryTextField.text = nil
            for i in self.categoryData?.items ?? [] {
                if i.name == item {
                    getSubCategories(id: i.id ?? "")
                }
            }
            self.view.endEditing(true)
            self.categoryDropDown.hide()
        }
        categoryDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        categoryDropDown.direction = .bottom
    }
    func subCategoryDropDownSetup(){
        // Sub Category Drop Down
        subCategoryDropDown.anchorView = chooseProductSubCategoryTextField
        subCategoryDropDown.dataSource = self.subCategoryList
        subCategoryDropDown.backgroundColor = .white
        subCategoryDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.chooseProductSubCategoryTextField.text = item
            self.view.endEditing(true)
            self.subCategoryDropDown.hide()
        }
        subCategoryDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        subCategoryDropDown.direction = .bottom
    }
    
    func openCamera(){
        /// Open Camera
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
    
    func openPhotos(){
        ///Open Photo Gallary
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - Extensions -

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            productImageView.image = image
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
