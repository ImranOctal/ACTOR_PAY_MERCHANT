//
//  WebViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 09/12/21.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var mainView: UIView!
    
    var titleLabel = ""
    
    //MARK: - Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerTitleLabel.text = titleLabel
        topCorner(bgView: mainView, maskToBounds: true)
        if let url = URL(string: "https://www.google.com/") {
            webView.load(URLRequest(url: url))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selector -

    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
}
