//
//  CommissionViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 01/02/22.
//

import UIKit
import Alamofire

class CommissionViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
    }
    
    var page = 0
    var totalCount = 10
    var filterParam: Parameters?
    var commission: CommissionList?
    var commissionList: [CommissionItems] = []
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.commissionListApi()
        
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Filter Commission Button Action
    @IBAction func filterBtnAction(_ sender: UIButton) {
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterCommissionViewController") as? FilterCommissionViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterCommissionParm = filterParam
        newVC.setFilterData()
        newVC.completion = { param in
            print(param as Any)
            self.page = 0
            self.filterParam = param
            self.commissionListApi()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension CommissionViewController {
    
    // Get Commission List Api
    func commissionListApi(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
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
        APIHelper.commissionListApi(params: parameters, bodyParameter: bodyParam) { (success, response) in
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
                self.commission = CommissionList.init(json: data)
                if self.page == 0 {
                    self.commissionList = CommissionList.init(json: data).items ?? []
                } else {
                    self.commissionList.append(contentsOf: CommissionList.init(json: data).items ?? [])
                }
                self.totalCount = self.commission?.totalItems ?? 0
                self.tblView.reloadData()
            }
        }
    }
    
}

//MARK: TableView SetUp
extension CommissionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commissionList.count == 0{
            tableView.setEmptyMessage("No Data Found")
        } else {
            tableView.restore()
        }
        return commissionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommissionDetailsTableViewCell", for: indexPath) as! CommissionDetailsTableViewCell
        let item = commissionList[indexPath.row]
        cell.item = item
        return cell
    }
    
}

// MARK: ScrollView Setup
extension CommissionViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.commission?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.commission?.totalPages ?? 0)-1) {
                page += 1
                self.commissionListApi()
            }
        }
    }
    
}
 
