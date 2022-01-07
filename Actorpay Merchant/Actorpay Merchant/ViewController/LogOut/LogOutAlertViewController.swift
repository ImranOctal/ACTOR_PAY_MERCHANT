//
//  LogOutAlertViewController.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

class LogOutAlertViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var cancelButtonView: UIView!
    @IBOutlet weak var horizontalBorderView: UIView!
    @IBOutlet weak var logOutAlertView: UIView!
    @IBOutlet weak var logOutTitleView: UIView!
    @IBOutlet weak var logOutAlertButtonView: UIView!
    
    var isSideMenu = false
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topCorners(bgView: logOutTitleView, cornerRadius: 10, maskToBounds: true)
        bottomCorner(bgView: logOutAlertButtonView, cornerRadius: 10, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.showAnimate()
        self.navigationController?.navigationBar.isHidden = true
        if isSideMenu {
            self.setUpSimpleLogOutAlert()
        } else {
            self.setUpSessionExpireAlert()
        }
        
    }
    
    //MARK: - Selectors -
    
    // OK Button Action
    @IBAction func okButtonAction(_ sender: UIButton) {
        AppManager.shared.token = ""
        AppManager.shared.merchantUserId = ""
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
        myApp.window?.rootViewController = newVC
    }
    
    // Cancel Button Action
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // SetUp Session Expire Logout Alert
    func setUpSessionExpireAlert() {
        descLbl.text = "Session Expire Please LogOut"
        horizontalBorderView.isHidden = true
        cancelButtonView.isHidden = true
    }
    
    // SetUp Simple LogOut Alert
    func setUpSimpleLogOutAlert () {
        descLbl.text = "Are you sure you want to LogOut?"
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
        if(touches.first?.view != logOutAlertView) {
            removeAnimate()
        }
    }

}

