//
//  OrderNoteTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 03/02/22.
//

import UIKit

class OrderNoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNoteDescLbl: UILabel!
    @IBOutlet weak var orderNoteDateLbl: UILabel!
    
    var item: OrderNotesDtos? {
        didSet {
            if let item = self.item {
                orderNoteDescLbl.text = item.orderNoteDescription
                orderNoteDateLbl.text = item.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM") ?? ""
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
