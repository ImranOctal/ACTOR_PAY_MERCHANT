//
//  VerifyOtpViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 07/01/22.
//

import UIKit

class VerifyOtpViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var firstCodeTextField: UITextField!
    @IBOutlet weak var secondCodeTextField: UITextField!
    @IBOutlet weak var thirdCodeTextField: UITextField!
    @IBOutlet weak var fourthCodeTextField: UITextField!
    @IBOutlet weak var fifthCodeTextField: UITextField!
    @IBOutlet weak var sixthCodeTextField: UITextField!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var verifyOtpView: UIView!

    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setUpTextField()
        topCorners(bgView: titleView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: buttonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        removeAnimate()
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
    
    // Show View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    //Remove View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != verifyOtpView){
            removeAnimate()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

//MARK: - Extensions -

//MARK: Text Field Delegate Methods
extension VerifyOtpViewController: UITextFieldDelegate {
    
}

