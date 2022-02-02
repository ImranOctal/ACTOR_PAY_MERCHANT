//
//  OutletDetailsTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 31/01/22.
//

import UIKit

class OutletDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var addressLine2Lbl: UILabel!
    @IBOutlet weak var addressLine1Lbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    
    var editButtonHandler: (() -> ())!
    var deleteButtonHandler: (() -> ())!
    var item: OutletItems? {
        didSet {
            if let item = self.item {
                titleLbl.text = item.title
                addressLine1Lbl.text = item.addressLine1
                addressLine2Lbl.text = item.addressLine2
                contactLbl.text = "\(item.extensionNumber ?? "")\(item.contactNumber ?? "")"
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
    
    @IBAction func editButtonAction(_ sender: UIButton) {
        editButtonHandler()
    }
    
    @IBAction func deleteButtonAction(_ sender : UIButton) {
        deleteButtonHandler()
    }

}
