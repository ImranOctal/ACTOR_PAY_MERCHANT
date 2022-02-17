//
//  VerifyOtpViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 07/01/22.
//

import UIKit

class VerifyOtpViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var firstCodeTextField: UITextField! {
        didSet {
            self.firstCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var secondCodeTextField: UITextField! {
        didSet {
            self.secondCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var thirdCodeTextField: UITextField! {
        didSet {
            self.thirdCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var fourthCodeTextField: UITextField! {
        didSet {
            self.fourthCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var fifthCodeTextField: UITextField! {
        didSet {
            self.fifthCodeTextField.delegate = self
        }
    }
    @IBOutlet weak var sixthCodeTextField: UITextField! {
        didSet {
            self.sixthCodeTextField.delegate = self
        }
    }

    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpTextField()
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        print("Ok Button Tapped")
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Setup TextFied
    func setUpTextField() {
        firstCodeTextField.delegate = self
        secondCodeTextField.delegate = self
        thirdCodeTextField.delegate = self
        fourthCodeTextField.delegate = self
        fifthCodeTextField.delegate = self
        sixthCodeTextField.delegate = self
    }
    
}

//MARK: - Extensions -

//MARK: Text Field Delegate Methods
extension VerifyOtpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        switch textField {
        case firstCodeTextField:
            secondCodeTextField.becomeFirstResponder()
            return true
        case secondCodeTextField:
            thirdCodeTextField.becomeFirstResponder()
            return true
        case thirdCodeTextField:
            fourthCodeTextField.becomeFirstResponder()
            return true
        case fourthCodeTextField:
            fifthCodeTextField.resignFirstResponder()
            return true
        case fifthCodeTextField:
            sixthCodeTextField.resignFirstResponder()
            return true
        case sixthCodeTextField:
            sixthCodeTextField.resignFirstResponder()
            return true
        default:
            return true
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let string = textField.text ?? ""
        
        if textField.text?.count == 0 && string.count == 0{
            switch textField{
            case firstCodeTextField:
                firstCodeTextField.text = string
                firstCodeTextField.becomeFirstResponder()
            case secondCodeTextField:
                secondCodeTextField.text = string
                firstCodeTextField.becomeFirstResponder()
            case thirdCodeTextField:
                thirdCodeTextField.text = string
                secondCodeTextField.becomeFirstResponder()
            case fourthCodeTextField:
                fourthCodeTextField.text = string
                thirdCodeTextField.becomeFirstResponder()
            case fifthCodeTextField:
                fifthCodeTextField.text = string
                fourthCodeTextField.becomeFirstResponder()
            case sixthCodeTextField:
                sixthCodeTextField.text = string
                fifthCodeTextField.becomeFirstResponder()
            default:
                break
            }
        }
        return
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text
        guard let stringRange = Range(range, in: currentText!) else{
            return false
        }
        let updatedString = currentText?.replacingCharacters(in: stringRange, with: string)
        print(updatedString ?? "")
        if (updatedString != "") {
            if !(updatedString?.isNumeric ?? false) {
                return false
            }
        }
        
        if (updatedString?.count ?? 0) > 1{
            switch textField{
            case firstCodeTextField:
                secondCodeTextField.text = string
                secondCodeTextField.becomeFirstResponder()
            case secondCodeTextField:
                thirdCodeTextField.text = string
                thirdCodeTextField.becomeFirstResponder()
            case thirdCodeTextField:
                fourthCodeTextField.text = string
                fourthCodeTextField.becomeFirstResponder()
            case fourthCodeTextField:
                fifthCodeTextField.text = string
                fifthCodeTextField.becomeFirstResponder()
            case fifthCodeTextField:
                sixthCodeTextField.text = string
                sixthCodeTextField.becomeFirstResponder()
            case sixthCodeTextField:
                sixthCodeTextField.text = string
                sixthCodeTextField.becomeFirstResponder()
            default:
                break
            }
            return false
        }
        
        if string.count > 0{
            switch textField{
            case firstCodeTextField:
                firstCodeTextField.text = string
                secondCodeTextField.becomeFirstResponder()
            case secondCodeTextField:
                secondCodeTextField.text = string
                thirdCodeTextField.becomeFirstResponder()
            case thirdCodeTextField:
                thirdCodeTextField.text = string
                fourthCodeTextField.becomeFirstResponder()
            case fourthCodeTextField:
                fourthCodeTextField.text = string
                fifthCodeTextField.becomeFirstResponder()
            case fifthCodeTextField:
                fifthCodeTextField.text = string
                sixthCodeTextField.becomeFirstResponder()
            case sixthCodeTextField:
                sixthCodeTextField.text = string
                sixthCodeTextField.becomeFirstResponder()
            default:
                break
            }
            return false
        }
        
        if textField.text?.count == 0 && string.count  == 0{
            switch textField{
            case firstCodeTextField:
                firstCodeTextField.text = string
                firstCodeTextField.becomeFirstResponder()
            case secondCodeTextField:
                secondCodeTextField.text = string
                firstCodeTextField.becomeFirstResponder()
            case thirdCodeTextField:
                thirdCodeTextField.text = string
                secondCodeTextField.becomeFirstResponder()
            case fourthCodeTextField:
                fourthCodeTextField.text = string
                thirdCodeTextField.becomeFirstResponder()
            case fifthCodeTextField:
                fifthCodeTextField.text = string
                fourthCodeTextField.becomeFirstResponder()
            case sixthCodeTextField:
                sixthCodeTextField.text = string
                fifthCodeTextField.becomeFirstResponder()
            default:
                break
            }
            return false
        }
        else if textField.text!.count >= 1 && string.count == 0{
            textField.text = string
            return false
        }else {
            return false
        }
    }
}
