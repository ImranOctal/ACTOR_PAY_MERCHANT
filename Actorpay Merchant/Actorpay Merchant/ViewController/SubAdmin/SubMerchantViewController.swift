//
//  SubMerchantViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 28/01/22.
//

import UIKit
import Alamofire

class SubMerchantViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
    }
    
    var subMerchant: SubMerchantList?
    var subMerchantList: [SubMerchantItems] = []
    var page = 0
    var totalCount = 10
    var filterParam: Parameters?
    var subMerchantId: String?
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topCorner(bgView: bgView, maskToBounds: true)
        self.getAllSubMerchantList()
        tblView.addPullToRefresh {
            self.page = 0
            self.getAllSubMerchantList()
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadMerchantListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadMerchantListApi),name:Notification.Name("reloadMerchantListApi"), object: nil)
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add New Sub Merchant Buton Action
    @IBAction func addNewSubMerchantBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NewSubAdminViewController") as! NewSubAdminViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // Reload Merchant List Api
    @objc func reloadMerchantListApi() {
        self.getAllSubMerchantList()
    }

}

//MARK: - Extensions -

//MARK: Api Call
extension SubMerchantViewController {
    
    // Get All Sub Merchant List Api
    func getAllSubMerchantList(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        if parameter == nil {
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
            parameters["sortBy"] = "createdAt"
            parameters["asc"] = true
        } else{
            page = 0
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
            parameters["sortBy"] = "createdAt"
            parameters["asc"] = true
        }
        
        var bodyParam = Parameters()
        if bodyParameter == nil {
            if let bodyParameter = filterParam {
                bodyParam = bodyParameter
            }
        } else {
            if let bodyParameter = bodyParameter {
                bodyParam = bodyParameter
            }
        }
        
        showLoading()
        APIHelper.getAllSubMerchantListApi(params: parameters, bodyParameter: bodyParam) { (success, response) in
            self.tblView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                let data = response.response["data"]
                self.subMerchant = SubMerchantList.init(json: data)
                if self.page == 0 {
                    self.subMerchantList = SubMerchantList.init(json: data).items ?? []
                } else {
                    self.subMerchantList.append(contentsOf: SubMerchantList.init(json: data).items ?? [])
                }
                self.totalCount = self.subMerchant?.totalItems ?? 0
                self.tblView.reloadData()
            }
        }
    }
    
    // Delete Sub Merchant By Id Api
    func deleteSubMerchentByIdApi(subMerchantId: String) {
        let bodyParams: Parameters = [
            "ids": [
                subMerchantId
            ]
        ]
        
        showLoading()
        APIHelper.deleteSubMerchentByIdApi(params: [:], bodyParameter: bodyParams) { (success, response) in
            self.tblView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
                NotificationCenter.default.post(name:  Notification.Name("reloadMerchantListApi"), object: self)
            }
        }
    }
}

//MARK: Table View SetUp
extension SubMerchantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if subMerchantList.count == 0{
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.restore()
        }
        return subMerchantList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubMerchantDetailTableViewCell", for: indexPath) as! SubMerchantDetailTableViewCell
        let item = subMerchantList[indexPath.row]
        cell.item = item
        cell.deleteButtonHandler = {
            self.subMerchantId = item.id
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            newVC.setUpCustomAlert(titleStr: "Delete Resource", descriptionStr: "Are you sure want to delete?", isShowCancelBtn: false)
            newVC.customAlertDelegate = self
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
        cell.editButtonHandler = {
            self.view.endEditing(true)
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "NewSubAdminViewController") as! NewSubAdminViewController
            newVC.isEditSubMerchant = true
            newVC.subMerchantId = item.id
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        return cell
    }
    
}

// MARK: ScrollView Setup
extension SubMerchantViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.subMerchant?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.subMerchant?.totalPages ?? 0)-1) {
                page += 1
                self.getAllSubMerchantList()
            }
        }
    }
    
}

// MARK: Custom Alert Delegate Methods
extension SubMerchantViewController: CustomAlertDelegate {
    
    func okButtonclick(tag: Int) {
        self.deleteSubMerchentByIdApi(subMerchantId: self.subMerchantId ?? "")
        self.dismiss(animated: true, completion: nil)
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
