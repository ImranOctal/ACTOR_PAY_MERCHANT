//
//  OrderItemTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 29/12/21.
//

import UIKit
import SDWebImage

class OrderItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var qtyLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    
    var item: OrderItemDtos? {
        didSet {
            if let item = self.item {
                imgView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "placeholder_img"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
                titleLbl.text = item.productName
                qtyLbl.text = "Quantity: \(item.productQty ?? 0)"
                priceLbl.text = "Price: \(item.totalPrice ?? 0.0)"
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

}
