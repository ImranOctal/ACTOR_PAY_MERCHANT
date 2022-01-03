//
//  NewSubAdminViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class NewSubAdminViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK:- life Cycle Function -

    override func viewDidLoad() {
        super.viewDidLoad()

    }    
    
    //MARK:- Selectors -

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
        
    @IBAction func submitButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
    }

}
