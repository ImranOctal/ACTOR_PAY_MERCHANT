//
//  CommissionDetailsTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 01/02/22.
//

import UIKit

class CommissionDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var orderStatusLbl: UILabel!
    @IBOutlet weak var earningsLbl: UILabel!
    @IBOutlet weak var commissionPercentageLbl: UILabel!
    @IBOutlet weak var commissionAmtLbl: UILabel!
    @IBOutlet weak var settlementStatusLbl: UILabel!
    
    var item: CommissionItems? {
        didSet {
            if let item = self.item {
                nameLbl.text = item.orderNo
                orderStatusLbl.text = item.orderStatus
                earningsLbl.text = "₹\(doubleToStringWithComma(item.merchantEarnings ?? 0.0))"
                commissionPercentageLbl.text = "\(item.commissionPercentage ?? 0.0)"
                commissionAmtLbl.text = "₹\(doubleToStringWithComma(item.actorCommissionAmt ?? 0.0))"
                settlementStatusLbl.text = item.settlementStatus
                
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
