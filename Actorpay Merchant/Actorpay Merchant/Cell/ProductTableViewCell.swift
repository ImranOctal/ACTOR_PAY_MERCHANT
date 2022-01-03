//
//  ProductTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dealPricLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: Items? {
        didSet {
            let totalGst = (item?.cgst ?? 0) + (item?.sgst ?? 0)
            let totalPrice = totalGst + (item?.dealPrice ?? 0)
            if let item = self.item {
//                let date = item.createdAt?.toDate()
                titleLabel.text = item.name
                dealPricLabel.text = "$\(totalPrice)"
                itemPriceLabel.text = "\(item.actualPrice ?? 0)"
                dateLabel.text = item.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "HH:mm a, dd MMM yyyy")
            }
        }
    }
    
    var editButtonHandler: (() -> ())!
    var deleteButtonHandler: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func editButtonAction(_ sender: UIButton) {
        editButtonHandler()
    }
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler()
    }
    
}
