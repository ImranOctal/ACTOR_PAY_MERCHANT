//
//  FilterDisputesViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 17/02/22.
//

import UIKit
import Alamofire
import DropDown

class FilterDisputesViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var disputeCodeTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var disputeStatusTextField: UITextField!
    
    var startDatePicker = UIDatePicker()
    var endDatePicker = UIDatePicker()
    typealias comp = (_ params: Parameters?) -> Void
    var completion:comp?
    var disputeStatusDropDown =  DropDown()
    var DisputeStatus: String = ""
    var statusData: [String] = []
    var filterDisputeParm: Parameters?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statusData = ["PENDING","OPEN"]
        topCorner(bgView: filterView, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
        self.setStartDatePicker()
        self.setEndDatePicker()
        self.setUpDisputeStatusDropDown()
        self.setFilterData()
        
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        if let codeCompletion = completion {
            codeCompletion(filterDisputeParm)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Reset Button Action
    @IBAction func resetButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        disputeCodeTextField.text = ""
        startDateTextField.text = ""
        endDateTextField.text = ""
        disputeStatusTextField.text = ""
        filterDisputeParm = nil
    }
    
    // Apply Button Action
    @IBAction func applyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let param : Parameters = [
            "startDate":startDateTextField.text ?? "",
            "endData":endDateTextField.text ?? "",
            "disputeCode":disputeCodeTextField.text ?? "",
            "status":disputeStatusTextField.text ?? ""
        ]
        if let codeCompletion = completion {
            codeCompletion(param)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // Status Button Acction
    @IBAction func statusButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        disputeStatusDropDown.show()
    }
    
    //MARK: - Helper Functions -
    
    // Set Filter Data
    func setFilterData() {
        disputeCodeTextField.text = filterDisputeParm?["disputeCode"] as? String
        startDateTextField.text = filterDisputeParm?["startDate"] as? String
        endDateTextField.text = filterDisputeParm?["endData"] as? String
        disputeStatusTextField.text = filterDisputeParm?["status"] as? String
    }
    
    // SetUp Order Status Drop Down
    func setUpDisputeStatusDropDown() {
        disputeStatusDropDown.anchorView = disputeStatusTextField
        disputeStatusDropDown.dataSource = statusData.map({$0.replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)})
        disputeStatusDropDown.backgroundColor = .white
        disputeStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.disputeStatusTextField.text = item
            self.view.endEditing(true)
            self.disputeStatusDropDown.hide()
        }
        disputeStatusDropDown.topOffset = CGPoint(x: -10, y: -50)
        disputeStatusDropDown.width = disputeStatusTextField.frame.width + 60
        disputeStatusDropDown.direction = .top
    }
    
    
    // Set Date Picker To FromTextField
    func setStartDatePicker() {
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
    func setEndDatePicker() {
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
                self.view.endEditing(true)
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
