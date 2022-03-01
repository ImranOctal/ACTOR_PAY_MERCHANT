//
//  ManageOrdersViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import Alamofire
import DropDown

class ManageOrdersViewController: UIViewController {
    
    //MARK:- Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .none
        }
    }
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.delegate = self
        }
    }
    var order: OrderList?
    var orderList: [OrderItems] = []
    var filteredArray: [OrderItems] = []
    var page = 0
    var totalCount = 10
    var filterOrderParm: Parameters?
    
    //MARK:- life Cycle Function -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.getOrderListApi()
        tableView.addPullToRefresh {
            self.page = 0
            self.searchTextField.text = ""
            self.getOrderListApi()
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadOrderListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadOrderListApi),name:Notification.Name("reloadOrderListApi"), object: nil)
    }

    //MARK:- Selectors -
    
    // Back Button Action
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterOrderViewController") as? FilterOrderViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterOrderParm = filterOrderParm
        newVC.setFilterData()
        newVC.completion = { param in
            print(param as Any)
            self.page = 0
            self.filterOrderParm = param
            self.getOrderListApi()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // Reload Order List Api
    @objc func reloadOrderListApi() {
        self.getOrderListApi()
    }
    
}

// MARK: - Extensions -

//MARK: Api Call
extension ManageOrdersViewController {
    
    // Get Order List Api
    func getOrderListApi(parameter: Parameters? = nil,bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        if parameter == nil {
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        } else{
            page = 0
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        }
        
        var bodyParam = Parameters()
        if bodyParameter == nil {
            if let bodyParameter = filterOrderParm {
                bodyParam = bodyParameter
            }
        } else {
            if let bodyParameter = bodyParameter {
                bodyParam = bodyParameter
            }
        }
        
        showLoading()
        APIHelper.getOrderListApi(params: parameters, bodyParameter: bodyParam) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.order = OrderList.init(json: data)
                if self.page == 0 {
                    self.orderList = OrderList.init(json: data).items ?? []
                } else {
                    self.orderList.append(contentsOf: OrderList.init(json: data).items ?? [])
                }
                self.filteredArray = self.orderList
                self.totalCount = self.order?.totalItems ?? 0
                let message = response.message
                print(message)
                self.tableView.reloadData()
            }
        }
    }

}

//MARK: TableView SetUp
extension ManageOrdersViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredArray.count == 0 {
            tableView.setEmptyMessage("No Order Found")
        } else {
            tableView.restore()
        }
        return filteredArray.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageOrderTableViewCell", for: indexPath) as! ManageOrderTableViewCell
        let item = filteredArray[indexPath.row]
        cell.item = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        newVC.orderNo = filteredArray[indexPath.row].orderNo ?? ""
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

// MARK: ScrollView Setup
extension ManageOrdersViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.order?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.order?.totalPages ?? 0)-1) {
                page += 1
                self.getOrderListApi()
            }
        }
    }
    
}

//MARK: TextField Delegate Methods
extension ManageOrdersViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        var finalString = ""
        if string.isEmpty {
            finalString = String(finalString.dropLast())
            filteredArray = order?.items ?? []
        } else {
            finalString = textField.text! + string
            self.filteredArray = self.order?.items?.filter({
                ($0.orderNo ?? "").localizedCaseInsensitiveContains(finalString)
            }) ?? []
        }
        self.tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTextField:
            print("search")
            var filterParam = Parameters()
            if let parameter = filterOrderParm {
                filterParam = parameter
            }
            filterParam["orderNo"] = searchTextField.text ?? ""
            self.getOrderListApi(bodyParameter: filterParam)
        default:
            break
        }
        return true
    }
    
}
