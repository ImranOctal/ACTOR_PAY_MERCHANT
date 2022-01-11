//
//  ProductDetailsViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import SDWebImage

class ProductDetailsViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    var productDetails: Items?
    var productId: String?

    //MARK:- life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK:- Selector -
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // Reload Function
    func reloadFunction() {
        self.getProductDetailsByIdApi(id: productId ?? "")
    }
    
    // Set Product Details Data
    func setProductDetailsData() {
        productImageView.sd_setImage(with: URL(string: productDetails?.image ?? ""), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        productTitleLabel.text = productDetails?.name ?? ""
        priceLabel.text = "\(productDetails?.dealPrice ?? 0)"
        discountPriceLabel.text = "\(productDetails?.actualPrice ?? 0)"
        descriptionLabel.text = productDetails?.description
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension ProductDetailsViewController {
    
    // Get Product Details By Id
    func getProductDetailsByIdApi(id: String) {
        showLoading()
        APIHelper.getProductDetails(id: id) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.productDetails = Items.init(json: data)
                self.setProductDetailsData()
                let message = response.message
                print(message)
            }
        }
    }
}
