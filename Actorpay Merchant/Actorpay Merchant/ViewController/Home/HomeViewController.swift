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
    
    private var isHamburgerMenuShown:Bool = false
    private var beginPoint:CGFloat = 0.0
    private var difference:CGFloat = 0.0
    var SideMenuViewController : SideMenuViewController?
    var page = 0
    var totalCount = 10
    var productList: ProductList?
    
    var getTaxDataByHSNCode: TaxList?
    var viewActiveTaxDataById: TaxList?
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.backViewForHamburger.isHidden = true
        self.getMerchantDetailsByIdApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("getMerchantDetailsByIdApi"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.getMerchantDetailsByIdApi),name:Notification.Name("getMerchantDetailsByIdApi"), object: nil)
        self.getProductListAPI()
       
        self.getAllTaxDataByHSNCode(HSNCode: "0007")
        self.viewActiveTaxDataByIDApi(taxID: "16111609-bff3-477a-b4cf-603592597721")
        tableView.addPullToRefresh {
            self.getProductListAPI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductListAPI()
        print("reload")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("hello")
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
    
    //MARK:- helper Functions -
    
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
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response
                merchantDetails = MerchantDetails.init(json: data)
                AppManager.shared.merchantId = merchantDetails?.merchantId ?? ""
                print(AppManager.shared.merchantId)
            }
        }
    }
    
    //Product List Api
    func getProductListAPI(){
        let params: Parameters = [
            "pageNo":page,
            "pageSize":10
        ]
        print(params)
        showLoading()
        APIHelper.getProductList(parameters: params) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.productList = ProductList.init(json: data)
                self.totalCount = self.productList?.totalItems ?? 0
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
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
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
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
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
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
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.getTaxDataByHSNCode = TaxList.init(json: data)
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
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
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.viewActiveTaxDataById = TaxList.init(json: data)
                let message = response.message
                 // myApp.window?.rootViewController?.view.makeToast(message)
            }
        }
    }
    
    
}

//MARK: TableView SetUp
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productList?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = self.productList?.items?[indexPath.row]
        cell.item = item
        
        cell.editButtonHandler = {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
            newVC.titleLabel = "UPDATE PRODUCT"
            newVC.isUpdate = true
            newVC.productItem = self.productList?.items?[indexPath.row]
            self.navigationController?.pushViewController(newVC, animated: true)
//            self.changeProductStatusApi(productId: item?.productId ?? "", status: "true")
        }
        cell.deleteButtonHandler = {
            self.removeProductByIdApi(productId: item?.productId ?? "")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = self.productList?.items?[indexPath.row]
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
        let totalRecords = self.productList?.items?.count ?? 0
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 10.0 && totalRecords < totalCount {
            page += 1
            self.getProductListAPI()
        }
    }
    
}
