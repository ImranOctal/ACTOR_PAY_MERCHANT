//
//  FilterCommissionViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 01/02/22.
//

import UIKit
import DropDown
import Alamofire

class FilterCommissionViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var orderNoTextField: UITextField!
    @IBOutlet weak var merchantNameTextField: UITextField!
    @IBOutlet weak var earningFromTextField: UITextField!
    @IBOutlet weak var earningToTextField: UITextField!
    @IBOutlet weak var commissionFromTextField: UITextField!
    @IBOutlet weak var commissionToTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var commissionStatusTextField: UITextField!
    @IBOutlet weak var orderStatusTextField: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    var orderStatusDropDown =  DropDown()
    var orderStatusData: [String] = []
    var commissionStatusDropDown = DropDown()
    var commissionStatusData: [String] = []
    typealias comp = (_ params: Parameters?) -> Void
    var completion:comp?
    var filterCommissionParm: Parameters?
    
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        orderStatusData = ["Select Status","ALL","SUCCESS","READY","CANCELLED","PARTIALLY_CANCELLED","DISPATCHED","RETURNING","PARTIALLY_RETURNING","RETURNED","PARTIALLY_RETURNED","DELIVERED","PENDING","FAILED"]
        commissionStatusData = ["Select Status","PENDING","SETTLED"]
        topCorners(bgView: filterView, cornerRadius: 20, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        self.setStartDatePicker()
        self.setEndDatePicker()
        self.setupOrderStatusDropDown()
        self.setupCommissionStatusDropDown()
        self.setFilterData()
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        if let codeCompletion = completion {
            codeCompletion(filterCommissionParm)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Order Status Drop Down Button Action
    @IBAction func orderStatusDropDownBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.orderStatusDropDown.show()
    }
    
    // Commission Status Drop Down Button Action
    @IBAction func commissionStatusDropDownBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.commissionStatusDropDown.show()
    }
    
    // Reset Button Action
    @IBAction func resetButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.orderNoTextField.text = ""
        self.merchantNameTextField.text = ""
        self.earningFromTextField.text = ""
        self.earningToTextField.text = ""
        self.commissionFromTextField.text = ""
        self.commissionToTextField.text = ""
        self.startDateTextField.text = ""
        self.endDateTextField.text = ""
        self.commissionStatusTextField.text = ""
        self.orderStatusTextField.text = ""
        self.filterCommissionParm = nil
    }
    
    // Apply Button Action
    @IBAction func applyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let param : Parameters = [
            "productName": "",
            "merchantName": merchantNameTextField.text ?? "",
            "orderNo": orderNoTextField.text ?? "",
            "orderStatus": orderStatusTextField.text ?? "" == "ALL" ? "" : orderStatusTextField.text ?? "",
            "settlementStatus": commissionStatusTextField.text ?? "",
            "startDate": startDateTextField.text ?? "",
            "endDate": endDateTextField.text ?? "",
            "merchantEarnings": "",
            "merchantEarningsRangeFrom": earningFromTextField.text ?? "",
            "merchantEarningsRangeTo": earningToTextField.text ?? "",
            "actorCommissionAmtRangeFrom": commissionFromTextField.text ?? "",
            "actorCommissionAmtRangeTo": commissionToTextField.text ?? ""
        ]
        if let codeCompletion = completion {
            codeCompletion(param)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - Helper Functions -
    
    // Set Filter Data
    func setFilterData() {
        self.orderNoTextField.text = filterCommissionParm?["orderNo"] as? String
        self.merchantNameTextField.text = filterCommissionParm?["merchantName"] as? String
        self.earningFromTextField.text = filterCommissionParm?["merchantEarningsRangeFrom"] as? String
        self.earningToTextField.text = filterCommissionParm?["merchantEarningsRangeTo"] as? String
        self.commissionFromTextField.text = filterCommissionParm?["actorCommissionAmtRangeFrom"] as? String
        self.commissionToTextField.text = filterCommissionParm?["actorCommissionAmtRangeTo"] as? String
        self.startDateTextField.text = filterCommissionParm?["startDate"] as? String
        self.endDateTextField.text = filterCommissionParm?["endDate"] as? String
        self.commissionStatusTextField.text = filterCommissionParm?["settlementStatus"] as? String
        self.orderStatusTextField.text = filterCommissionParm?["orderStatus"] as? String
    }
    
    // SetUp Order Status Drop Down
    func setupOrderStatusDropDown() {
        orderStatusDropDown.anchorView = orderStatusTextField
        orderStatusDropDown.dataSource = orderStatusData
        orderStatusDropDown.backgroundColor = .white
        orderStatusDropDown.width = orderStatusTextField.frame.width + 60
        orderStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Select Status" {
                self.orderStatusTextField.text = ""
            } else {
                self.orderStatusTextField.text = item
            }
            self.view.endEditing(true)
            self.orderStatusDropDown.hide()
        }
    }
    
    // SetUp Commission Status Drop Down
    func setupCommissionStatusDropDown() {
        commissionStatusDropDown.anchorView = commissionStatusTextField
        commissionStatusDropDown.dataSource = commissionStatusData
        commissionStatusDropDown.backgroundColor = .white
        commissionStatusDropDown.width = commissionStatusTextField.frame.width + 60
        commissionStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Select Status" {
                self.commissionStatusTextField.text = ""
            } else {
                self.commissionStatusTextField.text = item
            }
            self.view.endEditing(true)
            self.commissionStatusDropDown.hide()
        }
    }
    
    // Set Date Picker To FromTextField
    func setStartDatePicker(){
        startDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
        }
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(startDateTextFieldDoneDatePicker))
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
        let doneButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(endDateTextFieldDoneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = endDatePicker
    }
    
    // FromTextField DatePicker Done Button Action
    @objc func startDateTextFieldDoneDatePicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        startDateTextField.text = formatter.string(from: startDatePicker.date)
        self.view.endEditing(true)
    }
    
    // ToTextField DatePicker Done Button Action
    @objc func endDateTextFieldDoneDatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        endDateTextField.text = formatter.string(from: endDatePicker.date)
        self.view.endEditing(true)
    }
    
    // Date Picker Cancel Button Action
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    // Present View With Animation
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
    func removeAnimate() {
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

