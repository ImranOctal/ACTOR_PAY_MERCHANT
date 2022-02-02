//
//  MoreViewController.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class MoreViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: mainView, maskToBounds: true)
        
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
    
    // AboutUS Button Action
    @IBAction func aboutUsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
        newVC.titleLabel = "About Us"
        newVC.type = 1
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // ContactUS Button Action
    @IBAction func contactUsButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        print("Contact Us Tapped")
    }
    
    // FAQ Button Action
    @IBAction func faqButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Terms And Condition Button Action
    @IBAction func termsAndConditionButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
        newVC.titleLabel = "TERM & CONDITIONS"
        newVC.type = 3
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Privacy And Policy Button Action
    @IBAction func privacyPolicyButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
        newVC.titleLabel = "PRIVACY POLICY"
        newVC.type = 2
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}
