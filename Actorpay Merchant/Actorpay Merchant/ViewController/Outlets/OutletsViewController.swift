//
//  OutletsViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 31/01/22.
//

import UIKit
import Alamofire
import PopupDialog

class OutletsViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
    }
    @IBOutlet weak var bgView: UIView!

    var page = 0
    var totalCount = 10
    var filterParam: Parameters?
    var outletList: OutletList?
    var outletItems: [OutletItems] = []
    var outletId: String?
    
    //MARK:- Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.getOutletListApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadOutletListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadOutletListApi),name:Notification.Name("reloadOutletListApi"), object: nil)
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add Outlet Button Action
    @IBAction func addOutletButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddOutletViewController") as! AddOutletViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // Reload Outlet List Api
    @objc func reloadOutletListApi() {
        self.getOutletListApi()
    }

}

//MARK: - Extensions -

//MARK: Api Call
extension OutletsViewController {
    
    // Get All Outlet List Api
    func getOutletListApi(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        if parameter == nil {
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
            parameters["sortBy"] = "createdAt"
        } else{
            page = 0
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
            parameters["sortBy"] = "createdAt"
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
        APIHelper.getOutletListApi(params: parameters, bodyParameter: bodyParam) { (success, response) in
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
                self.outletList = OutletList.init(json: data)
                if self.page == 0 {
                    self.outletItems = OutletList.init(json: data).items ?? []
                } else {
                    self.outletItems.append(contentsOf: OutletList.init(json: data).items ?? [])
                }
                self.totalCount = self.outletList?.totalItems ?? 0
                self.tblView.reloadData()
            }
        }
    }
    
    // Delete Outlet By Id Api
    func deleteOutletByIdApi(outletId: String) {
        let bodyParams: Parameters = [
            "ids": [
                outletId
            ]
        ]
        
        showLoading()
        APIHelper.deleteOutletByIdApi(params: [:], bodyParameter: bodyParams) { (success, response) in
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
                NotificationCenter.default.post(name: Notification.Name("reloadOutletListApi"), object: self)
            }
        }
    }
    
}

//MARK: TableView Setup
extension OutletsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if outletItems.count == 0{
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.restore()
        }
        return outletItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OutletDetailsTableViewCell", for: indexPath) as! OutletDetailsTableViewCell
        let item = outletItems[indexPath.row]
        cell.item = item
        cell.deleteButtonHandler = {
            self.outletId = item.id ?? ""
            let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            customV.setUpCustomAlert(titleStr: "Delete Resource", descriptionStr: "Are you sure want to delete?", isShowCancelBtn: false)
            customV.customAlertDelegate = self
            self.present(popup, animated: true, completion: nil)
        }
        cell.editButtonHandler = {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddOutletViewController") as! AddOutletViewController
            newVC.isUpdateOutlet = true
            newVC.outletId = item.id ?? ""
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        return cell
    }
    
}

// MARK: ScrollView Setup
extension OutletsViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.outletList?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.outletList?.totalPages ?? 0)-1) {
                page += 1
                self.getOutletListApi()
            }
        }
    }
    
}

// MARK: Custom Alert Delegate Methods
extension OutletsViewController: CustomAlertDelegate {
    
    func okButtonclick(tag: Int) {
        deleteOutletByIdApi(outletId: outletId ?? "")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
