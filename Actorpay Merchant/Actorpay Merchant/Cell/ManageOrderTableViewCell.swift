//
//  ManageOrderTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class ManageOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var switchButton: UISwitch!{
        didSet{
            switchButton.onTintColor = .green
            switchButton.tintColor = UIColor(named: "BlueColor")
            switchButton.subviews[0].subviews[0].backgroundColor = UIColor(named: "BlueColor")
            if let thumb = switchButton.subviews[0].subviews[1].subviews[2] as? UIImageView {
                thumb.transform = CGAffineTransform(scaleX:0.8, y: 0.8)
            }
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var editButtonHandler: (() -> ())!
    var deleteButtonHandler: (() -> ())!

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
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        deleteButtonHandler()
    }

}
