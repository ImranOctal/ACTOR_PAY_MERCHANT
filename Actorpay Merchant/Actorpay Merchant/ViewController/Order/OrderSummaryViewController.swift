//
//  OrderSummaryViewController.swift
//  Actorpay
//
//  Created by iMac on 29/12/21.
//

import UIKit
import SDWebImage
import Alamofire

class OrderSummaryViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    
    //Order Details
    @IBOutlet weak var orderDateAndTimeLbl: UILabel!
    @IBOutlet weak var orderAmountLbl: UILabel!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var orderStatusView: UIView!
    
    // Customer Details
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contactNoLbl: UILabel!
    
    //Delivery Address Detail
    @IBOutlet weak var addressLine1Lbl: UILabel!
    @IBOutlet weak var addressLine2Lbl: UILabel!
    @IBOutlet weak var cityAndCountryNameLbl: UILabel!
    
    // Notes
    @IBOutlet weak var noteDescLbl: UILabel!
    
    var orderNo = ""
    var orderItems: OrderItems?
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.setUpTableView()
        self.getOrderDetailsApi()
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadOrderDetails"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadOrderDetails),name:Notification.Name("reloadOrderDetails"), object: nil)
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
    
    // Reload Order List Api
    @objc func reloadOrderDetails() {
        self.getOrderDetailsApi()
    }
    
    //Table View SetUp
    func setUpTableView() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    // Set Order Details Data
    func setUpOrderDetailsData() {
        
        self.tblViewHeightConst.constant = CGFloat(120 * (self.orderItems?.orderItemDtos?.count ?? 0))
        
        //Order Details
        orderAmountLbl.text = "₹\(orderItems?.totalPrice ?? 0.0)"
        orderNumberLbl.text = orderItems?.orderNo ?? ""
        orderDateAndTimeLbl.text = "Order Date & Time: \(orderItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM") ?? "")"
        orderStatusLbl.text = orderItems?.orderStatus ?? ""
        orderStatusView.layer.borderColor = getStatus(stausString: orderItems?.orderStatus ?? "").cgColor
        orderStatusLbl.textColor = getStatus(stausString: orderItems?.orderStatus ?? "")
        
        // Customer Details
        firstNameLbl.text = orderItems?.customer?.firstName ?? ""
        lastNameLbl.text = orderItems?.customer?.lastName ?? ""
        emailLbl.text = orderItems?.customer?.email ?? ""
        contactNoLbl.text = orderItems?.customer?.contactNumber ?? ""
        
        // Shipping Address Details
        addressLine1Lbl.text = orderItems?.shippingAddressDTO?.addressLine1 ?? ""
        addressLine2Lbl.text = orderItems?.shippingAddressDTO?.addressLine2 ?? ""
        cityAndCountryNameLbl.text = "\(orderItems?.shippingAddressDTO?.city ?? "")\n\(orderItems?.shippingAddressDTO?.country ?? "")"
        
    }
    
}

//MARK:- Extensions -

//MARK: Api Call
extension OrderSummaryViewController {
    
//    // Get Order List Api
//    func getOrderListApi(parameter: Parameters? = nil) {
//        let params: Parameters = [
//            "pageNo": 0,
//            "pageSize": 10,
//
//        ]
//        let bodyParams: Parameters = [
//            "orderNo": orderNo
//        ]
//        showLoading()
//        APIHelper.getOrderListApi(params: params, bodyParameter: bodyParams) { (success, response) in
//            if !success {
//                dissmissLoader()
//                let message = response.message
//                self.view.makeToast(message)
//            }else {
//                dissmissLoader()
//                let data = response.response["data"]
//                self.orderItems =  OrderList.init(json: data).items?[0]
//                let message = response.message
//                print(message)
//                self.setUpOrderDetailsData()
//                self.tblView.reloadData()
//            }
//        }
//    }
    
    // get Order Details Api
    @objc func getOrderDetailsApi() {
        showLoading()
        APIHelper.getOrderDetailsApi(orderNo: orderNo) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.orderItems = OrderItems.init(json: data)
                let message = response.message
                print(message)
                self.setUpOrderDetailsData()
                self.tblView.reloadData()
            }
        }
    }
}

//MARK: Table View SetUp
extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems?.orderItemDtos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        let item = orderItems?.orderItemDtos?[indexPath.row]
        cell.item = item
        cell.menuButtonHandler = {
            cell.setUpCancelOrderDropDown()
        }
        cell.cancelOrderHandler = { status in
            let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "OrderAddNoteViewController") as? OrderAddNoteViewController)!
            newVC.status = status
            newVC.orderItems = self.orderItems
            newVC.orderItemDtos = item
            newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            self.definesPresentationContext = true
            self.providesPresentationContextTransitionStyle = true
            newVC.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(newVC, animated: true, completion: nil)
        }
        return cell
    }
    
}
