//
//  SideMenuViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.

import UIKit
import Toast_Swift
import SDWebImage

//MARK: - Sidemenu Model -
struct SideMenuModel {
    var icon: UIImage?
    var title: String
}

//MARK: - Sidemenu Protocol -

protocol SideMenuViewControllerDelegate {
    func hideHamburgerMenu()
}

class SideMenuViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet var sideMenuTableView: UITableView! {
        didSet {
            self.sideMenuTableView.delegate = self
            self.sideMenuTableView.dataSource = self
            self.sideMenuTableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.sideMenuTableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var profilePictureImage: UIImageView!
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var menu: [SideMenuModel] = [
        SideMenuModel(icon: UIImage(named: "my_profile"), title: "My Profile"),
        SideMenuModel(icon: UIImage(named: "change_password"), title: "Change Password"),
        SideMenuModel(icon: UIImage(named: "sub_merchant"), title: "Merchant & sub Merchant"),
        SideMenuModel(icon: UIImage(named: "manage_orders"), title: "Manage Products"),
        SideMenuModel(icon: UIImage(named: "manage_orders"), title: "Manage Orders"),
        SideMenuModel(icon: UIImage(named: "cancel_dispute"), title: "Cancelled/Raised Dispute"),
        SideMenuModel(icon: UIImage(named: "file_reports"), title: "Reports"),
    ]    
    var delegate : SideMenuViewControllerDelegate?
    
    //MARK:- Life Cycle Functions -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("setProfileData"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.setProfileData),name:Notification.Name("setProfileData"), object: nil)
        self.setProfileData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setProfileData()
    }
    
    //MARK:- Selectors -
    
    @IBAction func clickedOnButton(_ sender: Any) {
        self.delegate?.hideHamburgerMenu()
    }
    
    // LogOut Button Action
    @IBAction func logoutButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if let opo = obj_AppDelegate.window?.rootViewController {
            let popOverConfirmVC = self.storyboard?.instantiateViewController(withIdentifier: "LogOutAlertViewController") as! LogOutAlertViewController
            popOverConfirmVC.isSideMenu = true
            obj_AppDelegate.window?.rootViewController?.addChild(popOverConfirmVC)
            popOverConfirmVC.view.frame = opo.view.frame
            opo.view.center = popOverConfirmVC.view.center
            opo.view.addSubview(popOverConfirmVC.view)
            popOverConfirmVC.didMove(toParent: self)
        }
    }
    
    //MARK: - Helper Functions -
    
    // Set Profile Data
    @objc func setProfileData() {
        profilePictureImage.sd_setImage(with: URL(string: merchantDetails?.profilePicture ?? ""), placeholderImage: UIImage(named: "profile"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        nameLabel.text = merchantDetails?.businessName ?? ""
    }
}

// MARK: - Extensions -

//MARK: TableView SetUp
extension SideMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as? SideMenuCell else { fatalError("xib doesn't exist") }
        cell.iconImageView.image = self.menu[indexPath.row].icon
        cell.titleLabel.text = self.menu[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.delegate?.hideHamburgerMenu()
        switch indexPath.row {
        case 0:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 1:
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as? ChangePasswordViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        case 2:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NewSubAdminViewController") as! NewSubAdminViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 3:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 4:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ManageOrdersViewController") as! ManageOrdersViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 5:
            obj_AppDelegate.window?.rootViewController?.view.makeToast("Coming Soon")
            return
        case 6:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PayRollViewController") as! PayRollViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        default:
            break
        }
    }
}
