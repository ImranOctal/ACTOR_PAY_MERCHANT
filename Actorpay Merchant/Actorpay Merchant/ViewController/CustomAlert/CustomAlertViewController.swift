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
    @IBOutlet weak var customAlertView: UIView!
    @IBOutlet weak var alertTitleView: UIView!
    @IBOutlet weak var alertButtonView: UIView!
    @IBOutlet weak var okBtn: UIButton!
    
    var customAlertDelegate: CustomAlertDelegate?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topCorners(bgView: alertTitleView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: alertButtonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        customAlertDelegate?.okButtonclick(tag: sender.tag)
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        customAlertDelegate?.cancelButtonClick()
    }
    
    //MARK: - Helper Functions -
    
    // Setup Custom Alert
    func setUpCustomAlert(titleStr: String, descriptionStr: String ,isShowCancelBtn:Bool) {
        alertTitleLbl.text = titleStr
        alertDescLbl.text = descriptionStr
        cancelButtonView.isHidden = isShowCancelBtn
    }
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
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
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if !(customAlertView.frame.contains(currentPoint)) {
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

