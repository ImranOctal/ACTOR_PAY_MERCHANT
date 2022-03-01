//
//  ProductTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import SDWebImage
import UIKit

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var dealPricLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var item: Items? {
        didSet {
            if let item = self.item {
                titleLabel.text = item.name
                dealPricLabel.text = doubleToStringWithComma(item.dealPrice ?? 0)
                itemPriceLabel.text = doubleToStringWithComma(item.actualPrice ?? 0)
                dateLabel.text = item.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM")
                imgView.sd_setImage(with: URL(string: item.image ?? ""), placeholderImage: UIImage(named: "placeholder_img"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
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
