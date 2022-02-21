//
//  DisputesViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import UIKit
import Alamofire

class DisputesViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var disputeTblView: UITableView! {
        didSet {
            self.disputeTblView.delegate = self
            self.disputeTblView.dataSource = self
        }
    }

    var page = 0
    var totalCount = 10
    var disputeList: DisputeList?
    var disputeItems: [DisputeItem] = []
    var filterDisputeParm: Parameters?
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.disputeListApi()
        disputeTblView.addPullToRefresh {
            self.page = 0
            self.disputeListApi()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterDisputesViewController") as? FilterDisputesViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterDisputeParm = filterDisputeParm
        newVC.setFilterData()
        newVC.completion = { param in
            print(param ?? [:])
            self.page = 0
            self.filterDisputeParm = param
            self.disputeListApi()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    //MARK: - Helper Functions -
    
    
}

//MARK: - Extensions -


//MARK: Api Call
extension DisputesViewController {
    
    // Dispute List Api
    func disputeListApi(urlParameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
                
        var urlParams = Parameters()
        if urlParameter == nil {
            urlParams["pageNo"] = page
            urlParams["pageSize"] = 10
            urlParams["sortBy"] = "createdAt"
            urlParams["asc"] = false
        } else{
            page = 0
            if let parameter = urlParameter {
                urlParams = parameter
            }
            urlParams["pageNo"] = page
            urlParams["pageSize"] = 10
            urlParams["sortBy"] = "createdAt"
            urlParams["asc"] = false
        }
        
        var bodyParams = Parameters()
        if bodyParameter == nil {
            if let bodyParameter = filterDisputeParm {
                bodyParams = bodyParameter
            }
        } else {
            if let bodyParameter = bodyParameter {
                bodyParams = bodyParameter
            }
        }
        
        showLoading()
        APIHelper.disputeListApi(urlParameters: urlParams, bodyParameter: bodyParams) { (success, response) in
            self.disputeTblView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.disputeList = DisputeList.init(json: data)
                if self.page == 0 {
                    self.disputeItems = DisputeList.init(json: data).items ?? []
                } else{
                    self.disputeItems.append(contentsOf: DisputeList.init(json: data).items ?? [])
                }
                self.totalCount = self.disputeList?.totalItems ?? 0
                self.disputeTblView.reloadData()
            }
        }
    }
}

//MARK: TableView SetUp
extension DisputesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.disputeItems.count == 0 {
            tableView.setEmptyMessage("No Dispute Found")
        }else{
            tableView.restore()
        }
        return self.disputeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DisputeTableViewCell", for: indexPath) as! DisputeTableViewCell
        let item = self.disputeItems[indexPath.row]
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        let item = self.disputeItems[indexPath.row]
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "DisputeDetailsViewController") as! DisputeDetailsViewController
        newVC.disputeId = item.disputeId ?? ""
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

// MARK: ScrollView Setup
extension DisputesViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = disputeItems.count
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.disputeList?.totalPages ?? 0)-1) {
                page += 1
                self.disputeListApi()
            }
        }
    }
    
}
