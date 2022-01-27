//
//  HomeViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import Alamofire
import SVPullToRefresh

class HomeViewController: UIViewController, SideMenuViewControllerDelegate {
    
    //MARK:- Properties -
    
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var hamburgerView: UIView!{
        didSet {
            rightCorners(bgView: hamburgerView, maskToBounds: true)
        }
    }
    @IBOutlet weak var leadingConstraintForHamburgerView: NSLayoutConstraint!
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
    @IBOutlet weak var backViewForHamburger: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var isHamburgerMenuShown:Bool = false
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    var SideMenuViewController : SideMenuViewController?
    var page = 0
    var totalCount = 10
    var product: ProductList?
    var productList: [Items] = []
    var filteredArray: [Items]?
    var activeProductList: ProductList?
    var getTaxDataByHSNCode: TaxList?
    var viewActiveTaxDataById: TaxList?
    var productId: String?
    var filterparm: Parameters?
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.backViewForHamburger.isHidden = true
        self.searchTextField.delegate = self
        self.getMerchantDetailsByIdApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getMerchantDetailsByIdApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.getMerchantDetailsByIdApi),name:Notification.Name("getMerchantDetailsByIdApi"), object: nil)
        self.getProductListAPI()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadGetProductListApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadGetProductListApi),name:Notification.Name("reloadGetProductListApi"), object: nil)
        self.getAllTaxDataByHSNCode(HSNCode: "0007")
        self.viewActiveTaxDataByIDApi(taxID: "16111609-bff3-477a-b4cf-603592597721")
        tableView.addPullToRefresh {
            self.page = 0
            self.getProductListAPI()
        }
    }
    
    //MARK:- Selector -
    
    // Humburger Back View Action
    @IBAction func tappedOnHamburgerbackView(_ sender: Any) {
        self.view.endEditing(true)
        self.hideHamburgerView()
    }
    
    //Add Product Button Action
    @IBAction func addProductButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        newVC.titleLabel = "ADD NEW PRODUCT"
        self.navigationController?.pushViewController(newVC, animated: true)        
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
    
    // Filter Button Action
    @IBAction func filterButtonAction(_ sender: UIButton) {
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "FilterProductViewController") as? FilterProductViewController)!
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        newVC.filterparm = filterparm
        newVC.setFilterData()
        newVC.completion = { param in
            print(param)
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
    
    // Hide Humburger Menu
    func hideHamburgerMenu() {
        self.hideHamburgerView()
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

// MARK: - Extensions -

//MARK: Api Call
extension HomeViewController {
    
    //Get Merchant Details By Id Api
    @objc func getMerchantDetailsByIdApi() {
       showLoading()
        APIHelper.getMerchantDetailsById(id: AppManager.shared.merchantUserId) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
//                self.view.makeToast(message)
                print(message)
                let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController)!
                newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
                newVC.setUpCustomAlert(titleStr: "Logout", descriptionStr: "Session Expire", isShowCancelBtn: true)
                newVC.okBtn.tag = 1
                newVC.customAlertDelegate = self
                self.definesPresentationContext = true
                self.providesPresentationContextTransitionStyle = true
                newVC.modalPresentationStyle = .overCurrentContext
                self.navigationController?.present(newVC, animated: true, completion: nil)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                merchantDetails = MerchantDetails.init(json: data)
                AppManager.shared.merchantId = merchantDetails?.merchantId ?? ""
                print(AppManager.shared.merchantId)
                NotificationCenter.default.post(name:Notification.Name("setProfileData"), object: self)
                NotificationCenter.default.post(name:Notification.Name("setMerchantDetailsData"), object: self)
                
            }
        }
    }
    
    // Get Product List Api
    func getProductListAPI(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        
        if parameter == nil {
            if let parameter = filterparm {
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
        
        var bodyParam = Parameters()
        if bodyParameter == nil {
            bodyParam = [:]
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
    
    // View All Active Product Api
    func viewAllActiveProductListApi(){
        let params: Parameters = [
            "pageNo":page,
            "pageSize":10
        ]
        print(params)
        showLoading()
        APIHelper.viewAllActiveProductListApi(parameters: params) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.activeProductList = ProductList.init(json: data)
                let message = response.message
                print(message)
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
    
    // Change Product Status By Id
    func changeProductStatusApi(productId: String, status: String) {
        let params: Parameters = [
            "id" : productId,
            "status" : status
        ]
        showLoading()
        APIHelper.changeProductStatusApi(params: params) { (success, response) in
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
        
    // Get All Tax Data By HSN Code Api
    func getAllTaxDataByHSNCode(HSNCode: String) {
        showLoading()
        APIHelper.getAllTaxDataByHSNCodeApi(parameters: [:],HSNCode: HSNCode) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.getTaxDataByHSNCode = TaxList.init(json: data)
                let message = response.message
                print(message)
            }
        }
    }
    
    // View Active Tax Data By ID
    func viewActiveTaxDataByIDApi(taxID: String) {
        showLoading()
        APIHelper.viewActiveTaxDataByIDApi(parameters: [:], taxID: taxID) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.viewActiveTaxDataById = TaxList.init(json: data)
                let message = response.message
                print(message)
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
//            self.changeProductStatusApi(productId: item?.productId ?? "", status: "true")
        }
        cell.deleteButtonHandler = {
            self.view.endEditing(true)
            self.productId = item?.productId
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as? CustomAlertViewController)!
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            newVC.setUpCustomAlert(titleStr: "Delete Resource", descriptionStr: "Are you sure want to delete?", isShowCancelBtn: false)
            newVC.okBtn.tag = 2
            newVC.customAlertDelegate = self
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.filteredArray?[indexPath.row]
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        newVC.productId = item?.productId
        newVC.reloadFunction()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        var finalString = ""
        if string.isEmpty {
            finalString = String(finalString.dropLast())
            filteredArray = product?.items
        } else {
            finalString = textField.text! + string
            self.filteredArray = self.product?.items?.filter({
                ($0.name ?? "").localizedCaseInsensitiveContains(finalString)
            })
        }
        self.tableView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case searchTextField:
            print("search")
            var filterParam = Parameters()
            if let parameter = filterparm {
                filterParam = parameter
            }
            filterParam["name"] = searchTextField.text ?? ""
            self.getProductListAPI(parameter: filterParam)
        default:
            break
        }
        return true
    }
}

//MARK: Custom Alert Delegate Methods
extension HomeViewController: CustomAlertDelegate {
    
    func okButtonclick(tag: Int) {
        print(tag)
        if tag == 1 {
            AppManager.shared.token = ""
            AppManager.shared.merchantUserId = ""
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
            myApp.window?.rootViewController = newVC
        } else if tag == 2 {
            self.removeProductByIdApi(productId: self.productId ?? "")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
}
