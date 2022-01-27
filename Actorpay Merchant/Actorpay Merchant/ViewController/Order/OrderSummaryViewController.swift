//
//  OrderSummaryViewController.swift
//  Actorpay
//
//  Created by iMac on 29/12/21.
//

import UIKit
import SDWebImage

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
    
    // Customer Details
    @IBOutlet weak var customerNameLbl: UILabel!
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
        setUpOrderDetailsData()
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper Functions -
    
    //Table View SetUp
    func setUpTableView() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
    
    // Set Order Details Data
    func setUpOrderDetailsData() {
        
        self.tblViewHeightConst.constant = CGFloat(103 * (self.orderItems?.orderItemDtos?.count ?? 0))
        
        //Order Details
        orderAmountLbl.text = "\(orderItems?.totalPrice ?? 0.0)"
        orderNumberLbl.text = orderItems?.orderNo ?? ""
        orderDateAndTimeLbl.text = "Order Date & Time: \(orderItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM") ?? "")"
        orderStatusLbl.text = orderItems?.orderStatus ?? ""
        
        // Customer Details
        customerNameLbl.text = (orderItems?.customer?.firstName ?? "") + (orderItems?.customer?.lastName ?? "")
        emailLbl.text = orderItems?.customer?.email ?? ""
        contactNoLbl.text = orderItems?.customer?.contactNumber ?? ""
        
        // Delivery Address Details
        addressLine1Lbl.text = orderItems?.shippingAddressDTO?.addressLine1 ?? ""
        addressLine2Lbl.text = orderItems?.shippingAddressDTO?.addressLine2 ?? ""
        cityAndCountryNameLbl.text = "\(orderItems?.shippingAddressDTO?.city ?? "")\n\(orderItems?.shippingAddressDTO?.country ?? "")"
    }
    
}

//MARK:- Extensions -

//MARK: Table View SetUp
extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems?.orderItemDtos?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        let item = orderItems?.orderItemDtos?[indexPath.row]
        cell.item = item
        return cell
    }
    
}
