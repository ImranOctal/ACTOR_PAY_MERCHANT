//
//  CountryPickerTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 07/01/22.
//

import UIKit

class CountryPickerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagImgView: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
