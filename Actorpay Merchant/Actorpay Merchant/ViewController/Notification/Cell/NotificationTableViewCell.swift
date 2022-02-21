//
//  NotificationTableViewCell.swift
//  Actorpay
//
//  Created by iMac on 06/12/21.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accountNumberButton: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var accountTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
