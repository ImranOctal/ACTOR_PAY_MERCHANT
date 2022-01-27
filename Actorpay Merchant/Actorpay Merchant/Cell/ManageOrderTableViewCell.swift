//
//  ManageOrderTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import DropDown

class ManageOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: OrderItems? {
        didSet {
            if let item = self.item {
                titleLabel.text = item.orderNo
                itemPriceLabel.text = "\(item.totalPrice ?? 0.0)"
                statusLbl.text = item.orderStatus
                dateLabel.text = item.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM")
            }
        }
    }
    var statusButtonHandler: (() -> ())!
    var orderStatusDropDown =  DropDown()
    var statusData: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusData = ["SUCCESS","PENDING","CANCELLED","COMPLETED","FAILED","RETURNED"]
        setupOrderStatusDropDown()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func statusButtonAction(_ sender: UIButton) {
        statusButtonHandler()
    }
    
    // Setup order Status Drop Down
    func setupOrderStatusDropDown() {
        orderStatusDropDown.anchorView = statusView
        orderStatusDropDown.dataSource = statusData
        orderStatusDropDown.backgroundColor = .white
        orderStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            statusLbl.text = item
            self.orderStatusDropDown.hide()
            orderStatusDropDown.bottomOffset = CGPoint(x: 0, y: -10)
            orderStatusDropDown.width = statusView.frame.width + 20
            orderStatusDropDown.direction = .bottom
        }
    }

}
