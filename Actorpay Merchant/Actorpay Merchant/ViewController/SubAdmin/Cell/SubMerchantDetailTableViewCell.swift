//
//  SubMerchantDetailTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 28/01/22.
//

import UIKit

class SubMerchantDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contactNoLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    var item: SubMerchantItems? {
        didSet {
            if let item = self.item {
                nameLbl.text = "\(item.firstName ?? "") \(item.lastName ?? "")"
                emailLbl.text = item.email
                contactNoLbl.text = "\(item.extensionNumber ?? "")\(item.contactNumber ?? "")"
                imgView.image = UIImage(named: "placeholder_img")
            }
        }
    }
    var deleteButtonHandler: (() -> ())!
    var editButtonHandler: (() -> ())!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Edit Button Action
    @IBAction func editButtonAction(_ sender: UIButton) {
        editButtonHandler()
    }
    
    // Delete Button Action
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler()
    }
    

}
