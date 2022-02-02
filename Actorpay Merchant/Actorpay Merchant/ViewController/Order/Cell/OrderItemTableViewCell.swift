//
//  OrderItemTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 29/12/21.
//

import UIKit
import SDWebImage
import DropDown

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    
    var menuButtonHandler: (() -> ())!
    let cancelOrderDropDown = DropDown()
    var cancelOrderHandler: ((_ status: String) -> ())!
    
    var item: OrderItemDtos? {
        didSet {
            if let item = self.item {
                imgView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "placeholder_img"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                titleLbl.text = item.productName
                qtyLbl.text = "Quantity: \(item.productQty ?? 0)"
                priceLbl.text = "Price: \(item.totalPrice ?? 0.0)"
                statusLbl.text = "Status: \(item.orderItemStatus ?? "")"
                menuButton.isHidden = item.orderItemStatus == "CANCELLED" || item.orderItemStatus == "DELIVERED" || item.orderItemStatus == "RETURNED" ? true : false
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Menu Button Action
    @IBAction func menuButtonAction(_ sender: UIButton) {
        menuButtonHandler()
    }
    
    // Cancel Order DropDown SetUp
    func setUpCancelOrderDropDown() {
        cancelOrderDropDown.show()
        cancelOrderDropDown.anchorView = menuButton
        if item?.orderItemStatus == "SUCCESS" {
            cancelOrderDropDown.dataSource = ["READY","CANCELLED"]
        } else if item?.orderItemStatus == "READY" {
            cancelOrderDropDown.dataSource = ["CANCELLED","DISPATCHED"]
        } else if item?.orderItemStatus == "DISPATCHED" {
            cancelOrderDropDown.dataSource = ["DELIVERED"]
        } else if item?.orderItemStatus == "RETURNING" {
            cancelOrderDropDown.dataSource = ["RETURNED"]
        }
        cancelOrderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            cancelOrderHandler(item)
            self.cancelOrderDropDown.hide()
        }
        cancelOrderDropDown.bottomOffset = CGPoint(x: -60, y: 25)
        cancelOrderDropDown.width =  110
        cancelOrderDropDown.direction = .bottom
    }

}
