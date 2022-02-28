//
//  DashboardViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 17/02/22.
//

import UIKit

class DashboardViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var hamburgerView: UIView!{
        didSet {
            rightCorners(bgView: hamburgerView, maskToBounds: true)
        }
    }
    @IBOutlet weak var backViewForHamburger: UIView!
    @IBOutlet weak var leadingConstraintForHamburgerView: NSLayoutConstraint!
    @IBOutlet weak var dashboardCollectionView: UICollectionView! {
        didSet {
            self.dashboardCollectionView.delegate = self
            self.dashboardCollectionView.dataSource = self
        }
    }
    
    var dashBoardImgArr = ["ic_order_color","ic_earn_money_color","ic_manage_product","ic_outlet_color","ic_merchant","ic_role_color","ic_profile","ic_reporting"]
    var dashBoardTitleArr = ["Orders","Earn Money","Product","Outlet","Sub Merchant","Role","My Profile","Reporting"]
    var dashBoarDescArr = ["Manage","Manage","Manage","Manage","Manage","Manage","Manage","Manage"]
    
    private var isHamburgerMenuShown:Bool = false
    var SideMenuViewController : SideMenuViewController?
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    var getTaxDataByHSNCode: TaxList?
    var viewActiveTaxDataById: TaxList?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.backViewForHamburger.isHidden = true
        
        self.getRoleListApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadRoleListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadRoleListApi),name:Notification.Name("reloadRoleListApi"), object: nil)
        self.getMerchantDetailsByIdApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getMerchantDetailsByIdApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.getMerchantDetailsByIdApi),name:Notification.Name("getMerchantDetailsByIdApi"), object: nil)
    }
    
    //MARK: - Selectors -
    
    // Notification Button Action
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // Humburger Back View Action
    @IBAction func tappedOnHamburgerbackView(_ sender: Any) {
        self.view.endEditing(true)
        self.hideHamburgerView()
    }
    
    // humburgerMenu Button Action
    @IBAction func showHamburgerMenu(_ sender: Any) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.1) {
            self.leadingConstraintForHamburgerView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHamburger.alpha = 0.75
            self.backViewForHamburger.isHidden = false
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHamburgerView.constant = 0
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.isHamburgerMenuShown = true
            }
        }
        self.backViewForHamburger.isHidden = false
        
    }
    
    //MARK: - Helper Functions -
    
    // Reload Role List Api
    @objc func reloadRoleListApi() {
        self.getRoleListApi()
    }
    
    //Hide Humburger View
    private func hideHamburgerView(){
        UIView.animate(withDuration: 0.1) {
            self.leadingConstraintForHamburgerView.constant = 10
            self.view.layoutIfNeeded()
        } completion: { (status) in
            self.backViewForHamburger.alpha = 0.0
            UIView.animate(withDuration: 0.1) {
                self.leadingConstraintForHamburgerView.constant = -320
                self.view.layoutIfNeeded()
            } completion: { (status) in
                self.backViewForHamburger.isHidden = true
                self.isHamburgerMenuShown = false
            }
        }
    }
    
    // Side Menu Segue Action
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "hamburgerSegue"){
            if let controller = segue.destination as? SideMenuViewController{
                self.SideMenuViewController = controller
                self.SideMenuViewController?.delegate = self
            }
        }
    }
    
    // SetTouch For Humburger Back View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown)
        {
            if let touch = touches.first
            {
                let location = touch.location(in: backViewForHamburger)
                beginPoint = location.x
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown){
            if let touch = touches.first{
                let location = touch.location(in: backViewForHamburger)
                let differenceFromBeginPoint = beginPoint - location.x
                if (differenceFromBeginPoint>0 || differenceFromBeginPoint<320){
                    difference = differenceFromBeginPoint
                    self.leadingConstraintForHamburgerView.constant = 0
                    self.backViewForHamburger.alpha = 0.75
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (isHamburgerMenuShown){
            if (difference>140){
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHamburgerView.constant = -320
                } completion: { (status) in
                    self.backViewForHamburger.alpha = 0.0
                    self.isHamburgerMenuShown = false
                    self.backViewForHamburger.isHidden = true
                }
            }else{
                UIView.animate(withDuration: 0.1) {
                    self.leadingConstraintForHamburgerView.constant = 0
                } completion: { (status) in
                    self.backViewForHamburger.alpha = 0.75
                    self.isHamburgerMenuShown = true
                    self.backViewForHamburger.isHidden = false
                }
            }
        }
    }
}

//MARK: - Extensions -

//MARK: Collection View SetUp
extension DashboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dashBoardImgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as! DashboardCollectionViewCell
        cell.dashboardTitleLbl.text = dashBoardTitleArr[indexPath.row]
        cell.dashboardDescLbl.text = dashBoarDescArr[indexPath.row]
        cell.dashboardImgView.image = UIImage(named: dashBoardImgArr[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageOrdersViewController") as! ManageOrdersViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 1:
            //self.view.makeToast("Comming Soon")
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "CommissionViewController") as! CommissionViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 2:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(newVC, animated: true)
            
        case 3:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "OutletsViewController") as! OutletsViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 4:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SubMerchantViewController") as! SubMerchantViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 5:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "RoleViewController") as! RoleViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 6:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 7:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PayRollViewController") as! PayRollViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 162)
    }
    
}

//MARK: SideMenuViewController Delegate Methods
extension DashboardViewController: SideMenuViewControllerDelegate {
    
    func hideHamburgerMenu() {
        self.hideHamburgerView()
    }
    
}

//MARK: Custom Alert Delegate Methods
extension DashboardViewController: CustomAlertDelegate {
    
    func okButtonclick(tag: Int) {
        print(tag)
        if tag == 1 {
            AppManager.shared.token = ""
            AppManager.shared.merchantUserId = ""
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        }
        
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
