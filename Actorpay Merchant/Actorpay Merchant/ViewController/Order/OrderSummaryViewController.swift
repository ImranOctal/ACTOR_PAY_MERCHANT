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
    @IBOutlet weak var orderDateAndTimeLbl: UILabel!
    @IBOutlet weak var orderAmountLbl: UILabel!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var deliveryAddressLbl: UILabel!
    @IBOutlet weak var shopNameLbl: UILabel!
    
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
        orderAmountLbl.text = "\(orderItems?.totalPrice ?? 0.0)"
        orderNumberLbl.text = "Order Number: \(orderItems?.orderNo ?? "")"
        orderDateAndTimeLbl.text = "Order Date & Time: \(orderItems?.createdAt ?? "")"
        shopNameLbl.text = "\(orderItems?.customer?.firstName ?? "") \(orderItems?.customer?.lastName ?? "")"
        deliveryAddressLbl.text = "\(orderItems?.shippingAddressDTO?.addressLine1 ?? "")\n\(orderItems?.shippingAddressDTO?.addressLine2 ?? "")\n\(orderItems?.shippingAddressDTO?.city ?? "")\n\(orderItems?.shippingAddressDTO?.country ?? "")"
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
        cell.titleLbl.text = item?.productName
        cell.qtyLbl.text = "Quantity: \(item?.productQty ?? 0)"
        cell.priceLbl.text = "Price: \(item?.totalPrice ?? 0.0)"
        cell.imgView.sd_setImage(with: URL(string: item?.image ?? ""), placeholderImage: UIImage(named: "logo"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        return cell
    }
    
    
}
