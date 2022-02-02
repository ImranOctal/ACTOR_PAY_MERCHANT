//
//  FilterOrderViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 12/01/22.
//

import UIKit
import Alamofire
import DropDown

class FilterOrderViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var orderNoTextField: UITextField!
    @IBOutlet weak var customerEmailTextField: UITextField!
    @IBOutlet weak var priceFromTextField: UITextField!
    @IBOutlet weak var priceToTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    typealias comp = (_ params: Parameters?) -> Void
    var completion:comp?
    var orderStatusDropDown =  DropDown()
    var statusData: [String] = []
    var filterOrderParm: Parameters?

    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statusData = ["ALL","SUCCESS","READY","CANCELLED","PARTIALLY_CANCELLED","DISPATCHED","RETURNING","PARTIALLY_RETURNING","RETURNED","PARTIALLY_RETURNED","DELIVERED","PENDING","FAILED"]
        topCorner(bgView: filterView, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        setStartDatePicker()
        setEndDatePicker()
        setupCategoryDropDown()
        self.setFilterData()
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        removeAnimate()
        if let codeCompletion = completion {
            codeCompletion(filterOrderParm)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Reset Button Action
    @IBAction func resetButtonAction(_ sender: UIButton) {
        orderNoTextField.text = ""
        customerEmailTextField.text = ""
        priceFromTextField.text = ""
        priceToTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        statusTextField.text = ""
        filterOrderParm = nil
    }
    
    // Apply Button Action
    @IBAction func applyButtonAction(_ sender: UIButton) {
        let param : Parameters = [
            "totalPrice":"",
            "merchantId":AppManager.shared.merchantId,
            "customeremail":customerEmailTextField.text ?? "",
            "status":"true",
            "startDate":startDateTextField.text ?? "",
            "endData":endDateTextField.text ?? "",
            "priceRangeFrom": priceFromTextField.text ?? "",
            "priceRangeTo": priceToTextField.text ?? "",
            "orderNo":orderNoTextField.text ?? "",
            "orderId":"",
            "orderStatus": statusTextField.text ?? "" == "ALL" ? "" : statusTextField.text ?? ""
        ]
        if let codeCompletion = completion {
            codeCompletion(param)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Status Button Acction
    @IBAction func statusButtonAction(_ sender: UIButton) {
        orderStatusDropDown.show()
    }
    
    //MARK: - Helper Functions -
    
    // Set Filter Data
    func setFilterData() {
        orderNoTextField.text = filterOrderParm?["orderNo"] as? String
        customerEmailTextField.text = filterOrderParm?["customeremail"] as? String
        priceFromTextField.text = filterOrderParm?["priceRangeFrom"] as? String
        priceToTextField.text = filterOrderParm?["priceRangeTo"] as? String
        startDateTextField.text = filterOrderParm?["startDate"] as? String
        endDateTextField.text = filterOrderParm?["endData"] as? String
        statusTextField.text = filterOrderParm?["orderStatus"] as? String
    }
    
    // SetUp Category Drop Down
    func setupCategoryDropDown() {
        orderStatusDropDown.anchorView = statusTextField
        orderStatusDropDown.dataSource = statusData
        orderStatusDropDown.backgroundColor = .white
        orderStatusDropDown.width = statusTextField.frame.width + 60
        orderStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.statusTextField.text = item
            self.view.endEditing(true)
            self.orderStatusDropDown.hide()
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

