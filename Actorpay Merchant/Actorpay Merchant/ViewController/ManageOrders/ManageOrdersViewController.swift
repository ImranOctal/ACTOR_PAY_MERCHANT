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
    var orderList: OrderList?
    var filteredArray: [OrderItems]?
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
            self.getOrderListApi()
        }
        
    }

    //MARK:- Selectors -
    
    // Back Button Action
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterOrderViewController") as? FilterOrderViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterOrderParm = filterOrderParm
        newVC.setFilterData()
        newVC.completion = { param in
            print(param)
            self.filterOrderParm = param
            self.getOrderListApi()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK:- Helper Function -
    
    

}

// MARK: - Extensions -

//MARK: Api Call
extension ManageOrdersViewController {
    
    // Get Order List Api
    func getOrderListApi(parameter: Parameters? = nil) {
        var parameters = Parameters()
        if parameter == nil {
            if let parameter = filterOrderParm {
                parameters = parameter
            }
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
        showLoading()
        APIHelper.getOrderListApi(params: parameters) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.orderList = OrderList.init(json: data)
                self.filteredArray = self.orderList?.items
                self.totalCount = self.orderList?.totalItems ?? 0
                let message = response.message
                print(message)
                self.tableView.reloadData()
            }
        }
    }
    
    // Update Order Status Api
    func updateOrderStatusApi(orderNo: String, status: String) {
        let params: Parameters = [
            "orderNo" : orderNo,
            "status" : status
        ]
        showLoading()
        APIHelper.updateOrderStatusApi(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.getOrderListApi()
            }
        }
    }
    
    // Cancel Or Return Order Api
    func cancelOrReturnOrderApi(orderNo: String) {
        showLoading()
        APIHelper.cancelOrReturnOrderApi(params: [:], orderNo: orderNo) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.getOrderListApi()
            }
        }
    }
}

//MARK: TableView SetUp
extension ManageOrdersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredArray?.count == 0{
            tableView.setEmptyMessage("No Order Availabel")
        } else {
            tableView.restore()
        }
        return filteredArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageOrderTableViewCell", for: indexPath) as! ManageOrderTableViewCell
        cell.titleLabel.text = orderList?.items?[indexPath.row].orderNo
        cell.itemPriceLabel.text = "\(orderList?.items?[indexPath.row].totalPrice ?? 0.0)"
        cell.statusButton.setTitle(orderList?.items?[indexPath.row].orderStatus, for: .normal)
        cell.dateLabel.text = orderList?.items?[indexPath.row].createdAt
        cell.statusButtonHandler = {
            cell.orderStatusDropDown.show()
//            self. (orderNo: self.orderList?.items?[indexPath.row].orderNo ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderSummaryViewController") as! OrderSummaryViewController
        newVC.orderItems = orderList?.items?[indexPath.row]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}

// MARK: ScrollView Setup
extension ManageOrdersViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.orderList?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords >= 10 {
            if page < self.orderList?.totalPages ?? 0 {
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
            filteredArray = orderList?.items
        } else {
            finalString = textField.text! + string
            self.filteredArray = self.orderList?.items?.filter({
                ($0.orderNo ?? "").localizedCaseInsensitiveContains(finalString)
            })
        }
        self.tableView.reloadData()
        return true
    }
}
