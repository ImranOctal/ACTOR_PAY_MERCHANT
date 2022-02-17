//
//  MerchantMessageCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import UIKit

class MerchantMessageCell: UITableViewCell {
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var userTypeView: UIView!
    
    var message: DisputeMessages? {
        didSet {
            if let message = self.message {
                self.lblUserType.text = "You"
                self.lblMessage.text = message.message
                self.lblDate.text = (message.createdAt ?? "").toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        messageView.roundCorners(radius: 10, corners: [.topLeft, .topRight, .bottomLeft])
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
