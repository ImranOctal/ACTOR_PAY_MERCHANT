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
    @IBOutlet weak var dashboardCollectionView: UICollectionView! {
        didSet {
            self.dashboardCollectionView.delegate = self
            self.dashboardCollectionView.dataSource = self
        }
    }
    
    var dashBoardImgArr = ["package","clipboard","salary","manager"]
    var dashBoardTitleArr = ["MANAGE","Reporting","Payroll","MANAGE"]
    var dashBoarDescArr = ["Product","Manager","Manager","Sub Merchant"]
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        
    }
    
    //MARK: - Selectors -

    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Notification Button Action
    @IBAction func notificationButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as! NotificationViewController
        self.navigationController?.pushViewController(newVC, animated: true)
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
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 1:
            self.view.makeToast("Comming Soon")
        case 2:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "PayRollViewController") as! PayRollViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        case 3:
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SubMerchantViewController") as! SubMerchantViewController
            self.navigationController?.pushViewController(newVC, animated: true)
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2, height: 162)
    }
    
}
