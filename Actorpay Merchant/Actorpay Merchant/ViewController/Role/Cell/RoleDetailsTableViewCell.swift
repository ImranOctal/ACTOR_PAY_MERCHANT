//
//  RoleDetailsTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 28/01/22.
//

import UIKit

class RoleDetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var deleteButtonHandler: (() -> ())!
    var editButtonHandler: (() -> ())!
    var item: RoleItems? {
        didSet {
            if let item = self.item {
                nameLbl.text = item.name
                descLbl.text = item.description
                dateLbl.text = item.createdAt?.toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM")
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
    
    // Delete Button Action
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler()
    }
    
    // Edit Button Action
    @IBAction func editButtonAction(_ sender: UIButton) {
        editButtonHandler()
    }

}
