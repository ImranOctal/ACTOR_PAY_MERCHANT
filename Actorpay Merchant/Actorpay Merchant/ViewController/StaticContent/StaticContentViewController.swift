//
//  StaticContentViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 12/01/22.
//

import UIKit
import Alamofire

class StaticContentViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webTextView: UITextView!
    
    
    var titleLabel = ""
    var staticContentData : StaticContent?
    var type: Int?
    
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text = titleLabel
        topCorner(bgView: mainView, maskToBounds: true)
        self.staticContentApi()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
    
    //Set Data In Text View
    func setUpTextView() {
        let attrStr = try! NSAttributedString(
            data: (staticContentData?.contents?.data(using: String.Encoding.unicode, allowLossyConversion: true))!,
            options:[NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        webTextView.attributedText = attrStr
        webTextView.isEditable = false
        webTextView.isSelectable = false
    }

}

//MARK: - Extensions -

//MARK: Api Call
extension StaticContentViewController {
    
    // Static Content Api
    func staticContentApi() {
        let params : Parameters = [
            "type": type ?? 0
        ]
        showLoading()
        APIHelper.staticContentApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.staticContentData = StaticContent.init(json: data)
                self.setUpTextView()
            }
        }
        
    }
}

