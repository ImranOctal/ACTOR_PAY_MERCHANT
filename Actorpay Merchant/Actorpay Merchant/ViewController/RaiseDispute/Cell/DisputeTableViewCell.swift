//
//  DisputeTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import UIKit

class DisputeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var disputeCodeLbl: UILabel!
    @IBOutlet weak var disputeTitleLbl: UILabel!
    @IBOutlet weak var disputeDescLbl: UILabel!
    @IBOutlet weak var disputeStatusLbl: UILabel!
    @IBOutlet weak var disputeDateLbl: UILabel!
    
    var item: DisputeItem? {
        didSet {
            if let item = self.item {
                disputeCodeLbl.text = item.disputeCode
                disputeTitleLbl.text = item.title
                disputeDescLbl.text = item.description
                disputeStatusLbl.text = item.status
                disputeDateLbl.text = (item.createdAt ?? "").toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM")
                disputeStatusLbl.textColor = getStatus(stausString: item.status ?? "")
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
