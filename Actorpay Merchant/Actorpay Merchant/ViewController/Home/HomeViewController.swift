//
//  HomeViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import Alamofire
import SVPullToRefresh
import PopupDialog

class HomeViewController: UIViewController {
    
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
    @IBOutlet weak var searchTextField: UITextField!
    
    var page = 0
    var totalCount = 10
    var product: ProductList?
    var productList: [Items] = []
    var filteredArray: [Items]?
    var activeProductList: ProductList?
    
    var productId: String?
    var filterparm: Parameters?
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.searchTextField.delegate = self
        
        self.getProductListAPI()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadGetProductListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadGetProductListApi),name:Notification.Name("reloadGetProductListApi"), object: nil)
        tableView.addPullToRefresh {
            self.page = 0
            self.getProductListAPI()
        }
        
    }
    
    //MARK:- Selector -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
        
    //Add Product Button Action
    @IBAction func addProductButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        newVC.titleLabel = "ADD NEW PRODUCT"
        self.navigationController?.pushViewController(newVC, animated: true)        
    }
    
    // Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterProductViewController") as? FilterProductViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterparm = filterparm
        newVC.setFilterData()
        newVC.completion = { param in
            print(param as Any)
            self.page = 0
            self.filterparm = param
            self.getProductListAPI()
        }
        self.navigationController?.present(newVC, animated: true, completion: nil)
    }
    
    //MARK:- helper Functions -
    
    // Get Product List Api reload function
    @objc func reloadGetProductListApi() {
        self.getProductListAPI()
    }

}

// MARK: - Extensions -

//MARK: Api Call
extension HomeViewController {
    
    // Get Product List Api
    func getProductListAPI(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
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
            if let bodyParameter = filterparm {
                bodyParam = bodyParameter
            }
        } else {
            if let bodyParameter = bodyParameter {
                bodyParam = bodyParameter
            }
        }
        
        showLoading()
        APIHelper.getProductListApi(params: parameters, bodyParameter: bodyParam) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.product = ProductList.init(json: data)
                if self.page == 0 {
                    self.productList = ProductList.init(json: data).items ?? []
                } else{
                    self.productList.append(contentsOf: ProductList.init(json: data).items ?? [])
                }
                self.filteredArray = self.productList
                self.totalCount = self.product?.totalItems ?? 0
                let message = response.message
                print(message)
                self.tableView.reloadData()
            }
        }
    }
    
    // Remove Product By Id
    func removeProductByIdApi(productId: String) {
        let params: Parameters = [
            "productId" : productId
        ]
        showLoading()
        APIHelper.removeProductById(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.getProductListAPI()
            }
        }
    }
    
}

//MARK: TableView SetUp
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (filteredArray?.count == 0) || (filteredArray == nil) {
            tableView.setEmptyMessage("No Product Found")
        } else {
            tableView.restore()
        }
        return filteredArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = self.filteredArray?[indexPath.row]
        cell.item = item
        cell.editButtonHandler = {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
            newVC.titleLabel = "UPDATE PRODUCT"
            newVC.isUpdate = true
            newVC.productItem = self.filteredArray?[indexPath.row]
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        cell.deleteButtonHandler = {
            self.view.endEditing(true)
            self.productId = item?.productId
            let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
            let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            customV.setUpCustomAlert(titleStr: "Delete Product", descriptionStr: "Are you sure want to delete?", isShowCancelBtn: false)
            customV.okBtn.tag = 2
            customV.customAlertDelegate = self
            self.present(popup, animated: true, completion: nil)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.filteredArray?[indexPath.row]
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        newVC.productId = item?.productId
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
}

// MARK: ScrollView Setup
extension HomeViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        let totalRecords = self.productList.count
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            if page < ((self.product?.totalPages ?? 0)-1) {
                page += 1
                self.getProductListAPI(bodyParameter: filterparm)
            }
        }
    }
    
}

//MARK: TextField Delegate Methods
extension HomeViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case searchTextField:
            let finalString = searchTextField.text
            var filterParam = Parameters()
            if let parameter = filterparm {
                filterParam = parameter
            }
            filterParam["name"] = finalString
            self.page = 0
            self.getProductListAPI(bodyParameter: filterParam)
        default:
            break
        }
    }
    
}

//MARK: Custom Alert Delegate Methods
extension HomeViewController: CustomAlertDelegate {
    
    func okButtonclick(tag: Int) {
        print(tag)
     if tag == 2 {
            self.page = 0
            self.removeProductByIdApi(productId: self.productId ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
