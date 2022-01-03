//
//  PayRollTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class PayRollTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var payableAmountLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var payButtonHandler: (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction func payButtonACtion(_ sender: UIButton) {
        payButtonHandler()
    }
    
}
