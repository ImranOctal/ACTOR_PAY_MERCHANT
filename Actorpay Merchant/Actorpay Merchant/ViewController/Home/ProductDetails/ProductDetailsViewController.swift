//
//  ProductDetailsViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class ProductDetailsViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!

    //MARK:- life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Selector -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
}
