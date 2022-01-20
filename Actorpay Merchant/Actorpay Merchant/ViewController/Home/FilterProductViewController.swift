//
//  FilterProductViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 12/01/22.
//

import UIKit
import Alamofire

class FilterProductViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var categoryDropDownTextField: CustomDropDown!
    @IBOutlet weak var subCategoryDropDownTextField: CustomDropDown!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    typealias comp = (_ params: Parameters?) -> Void
    var completion:comp?
    var categoryData:[String] = []
    var subCategoryData:[String] = []
    var filterparm: Parameters?
    var categoryList: CategoryList?
    var subCategoryList : SubCategoryList?
    var pageSize: Int = 10
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topCorner(bgView: filterView, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        setStartDatePicker()
        setEndDatePicker()
        self.setFilterData()
        getAllCategories(pageSize: pageSize)
        getSubCategories()
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        removeAnimate()
        if let codeCompletion = completion {
            codeCompletion(filterparm)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Apply Button Action
    @IBAction func applyButtonAction(_ sender: UIButton) {
        let param : Parameters = [
            "categoryName":categoryDropDownTextField.text ?? "",
            "status": true,
            "startDate":startDateTextField.text ?? "",
            "endDate":endDateTextField.text ?? "",
            "subcategoryName":subCategoryDropDownTextField.text ?? "",
            "merchantId":AppManager.shared.merchantId
        ]
        if let codeCompletion = completion {
            codeCompletion(param)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Reset Button Action
    @IBAction func resetButtonAction(_ sender: UIButton) {
        categoryDropDownTextField.text = ""
        subCategoryDropDownTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        filterparm = nil
        
    }
    
    //MARK: - Helper Functions -
    
    
    // Set Filter Data
    func setFilterData() {
        categoryDropDownTextField.text = filterparm?["categoryName"] as? String
        subCategoryDropDownTextField.text = filterparm?["subcategoryName"] as? String
        startDateTextField.text = filterparm?["startDate"] as? String
        endDateTextField.text = filterparm?["endDate"] as? String
    }
    
    // SetUp Category Drop Down
    func setUpCategoryDropDown() {
        categoryDropDownTextField.optionArray = categoryData
        categoryDropDownTextField.checkMarkEnabled = false
        categoryDropDownTextField.didSelect{(selectedText , index , id) in

        }
        categoryDropDownTextField.isSearchEnable = true
        categoryDropDownTextField.arrow.isHidden = true
        categoryDropDownTextField.arrowSize = 0
        
    }
    
    // SetUp SubCategory Drop Down
    func setUpSubCategoryDropDown() {
        subCategoryDropDownTextField.optionArray = subCategoryData
        subCategoryDropDownTextField.checkMarkEnabled = false
        subCategoryDropDownTextField.didSelect{(selectedText , index , id) in
        }
        subCategoryDropDownTextField.arrowSize = 0
        subCategoryDropDownTextField.isSearchEnable = true
        subCategoryDropDownTextField.arrow.isHidden = true
    }
    
    // Set Date Picker To FromTextField
    func setStartDatePicker(){
        startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(fromTxtFieldDoneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = startDatePicker
    }
    
    // Set Date Picker To ToTextField
    func setEndDatePicker(){
        endDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            endDatePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(toTxtFieldDoneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = endDatePicker
    }
    
    // FromTextField DatePicker Done Button Action
    @objc func fromTxtFieldDoneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        startDateTextField.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    // ToTextField DatePicker Done Button Action
    @objc func toTxtFieldDoneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        endDateTextField.text = formatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }
    
    // Date Picker Cancel Button Action
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if !(filterView.frame.contains(currentPoint)) {
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

//MARK: - Extension -

//MARK: Api Call
extension FilterProductViewController {
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
                let message = response.message
                print(message)
            }
        }
    }
}
