//
//  RaiseDisputeViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit

class RaiseDisputeViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Selectors -
    
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
