//
//  HomeViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit
import Alamofire

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
    var itemsList:[Items] = []
    
    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        getProductListAPI()
        self.backViewForHamburger.isHidden = true
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
    
    @IBAction func tappedOnHamburgerbackView(_ sender: Any) {
        self.view.endEditing(true)
        self.hideHamburgerView()
    }
    
    @IBAction func addProductButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
        newVC.titleLabel = "ADD NEW PRODUCT"
        self.navigationController?.pushViewController(newVC, animated: true)        
    }
    
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
    
    func getProductListAPI(){
        let params: Parameters = [
            "pageNo":page,
            "pageSize":10
        ]
        print(params)
        startAnimationLoader()
        APIHelper.getProductList(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                self.itemsList.removeAll()
                let data = response.response["data"]
                self.productList = ProductList.init(json: data)
                self.totalCount = self.productList?.totalItems ?? 0
                for item in self.productList?.items ?? [] {
                    self.itemsList.append(item)
                }
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.tableView.reloadData()
            }
        }
    }
    
    func hideHamburgerMenu() {
        self.hideHamburgerView()
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "hamburgerSegue"){
            if let controller = segue.destination as? SideMenuViewController{
                self.SideMenuViewController = controller
                self.SideMenuViewController?.delegate = self
            }
        }
    }
    
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

extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductTableViewCell", for: indexPath) as! ProductTableViewCell
        let item = self.itemsList[indexPath.row]
        cell.item = item
        
        cell.editButtonHandler = {
            let newVC = self.storyboard?.instantiateViewController(withIdentifier: "AddProductViewController") as! AddProductViewController
            newVC.titleLabel = "UPDATE PRODUCT"
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        cell.deleteButtonHandler = {
            self.view.makeToast("Not Available Service")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        self.navigationController?.pushViewController(newVC, animated: true)
    }
}
