//
//  ChangePasswordViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var changePasswordView: UIView!
    @IBOutlet weak var changePasswordLabelView: UIView!
    @IBOutlet weak var buttonView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        topCorners(bgView: changePasswordLabelView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: buttonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != changePasswordView){
            removeAnimate()
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton){
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func okButtonAction(_ sender: UIButton){
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
}
