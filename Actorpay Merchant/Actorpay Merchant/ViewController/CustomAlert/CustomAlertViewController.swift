//
//  CustomAlertViewController.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

protocol CustomAlertDelegate {
    func okButtonclick(tag: Int)
    func cancelButtonClick()
}

class CustomAlertViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var alertTitleLbl: UILabel!
    @IBOutlet weak var alertDescLbl: UILabel!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var horizontalBorderView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    
    var customAlertDelegate: CustomAlertDelegate?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        customAlertDelegate?.okButtonclick(tag: sender.tag)
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        customAlertDelegate?.cancelButtonClick()
    }
    
    //MARK: - Helper Functions -
    
    // Setup Custom Alert
    func setUpCustomAlert(titleStr: String, descriptionStr: String ,isShowCancelBtn:Bool) {
        alertTitleLbl.text = titleStr
        alertDescLbl.text = descriptionStr
        cancelButtonView.isHidden = isShowCancelBtn
    }

}

