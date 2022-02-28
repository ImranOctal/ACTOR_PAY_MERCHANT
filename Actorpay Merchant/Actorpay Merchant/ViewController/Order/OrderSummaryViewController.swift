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
    @IBOutlet weak var orderSummaryScrollView: UIScrollView!
    
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
    @IBOutlet weak var notesTblView: UITableView! {
        didSet {
            self.notesTblView.delegate = self
            self.notesTblView.dataSource = self
        }
    }
    @IBOutlet weak var notesTblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var paymentMethodLbl: UILabel!
    @IBOutlet weak var paymentMethodView: UIView!
    
    var orderNo = ""
    var orderItems: OrderItems?
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.setUpTableView()
        self.getOrderDetailsApi()
        self.orderSummaryScrollView.addPullToRefresh {
            self.getOrderDetailsApi()
        }
        NotificationCenter.default.removeObserver(self, name: Notification.Name("reloadOrderDetails"), object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(self.reloadOrderDetails),name:Notification.Name("reloadOrderDetails"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        DispatchQueue.main.async {
            self.notesTblViewHeightConst.constant = self.notesTblView.contentSize.height
        }
    }
    
    //MARK: - Selectors -
    
    //Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add Note Button Action
    @IBAction func addNoteButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = (self.storyboard?.instantiateViewController(withIdentifier: "OrderAddNoteViewController") as? OrderAddNoteViewController)!
        newVC.orderItems = self.orderItems
        newVC.isAddNoteBtn = true
        newVC.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        self.definesPresentationContext = true
        self.providesPresentationContextTransitionStyle = true
        newVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(newVC, animated: true, completion: nil)
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
        orderStatusLbl.text = (orderItems?.orderStatus ?? "").replacingOccurrences(of: "_", with: " ", options: .literal, range: nil)
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
        if orderItems?.paymentMethod != nil {
            paymentMethodLbl.text = orderItems?.paymentMethod
        } else {
            paymentMethodView.isHidden = true
        }
        
    }
    
}

//MARK:- Extensions -

//MARK: Api Call
extension OrderSummaryViewController {
    
    // get Order Details Api
    @objc func getOrderDetailsApi() {
        showLoading()
        APIHelper.getOrderDetailsApi(orderNo: orderNo) { (success, response) in
            self.orderSummaryScrollView.pullToRefreshView?.stopAnimating()
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
                self.notesTblView.reloadData()
            }
        }
    }
    
}

//MARK: Table View SetUp
extension OrderSummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case tblView:
            return orderItems?.orderItemDtos?.count ?? 0
        case notesTblView:
            if self.orderItems?.orderNotesDtos?.count == 0 {
                notesTblView.setEmptyMessage("No Data Found.")
            }else {
                notesTblView.restore()
            }
            return self.orderItems?.orderNotesDtos?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case tblView:
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
        case notesTblView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderNoteTableViewCell", for: indexPath) as! OrderNoteTableViewCell
            let item = orderItems?.orderNotesDtos?[indexPath.row]
            cell.item = item
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch tableView {
        case notesTblView:
            self.viewWillLayoutSubviews()
        default:
            break
        }
    }
    
}
