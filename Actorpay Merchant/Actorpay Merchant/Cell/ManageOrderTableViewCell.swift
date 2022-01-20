//
//  ManageOrderTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import DropDown

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
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var editButtonHandler: (() -> ())!
    var deleteButtonHandler: (() -> ())!
    var statusButtonHandler: (() -> ())!
    var orderStatusDropDown =  DropDown()
    var statusData: [String] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        statusData = ["SUCCESS","PENDING","CANCELLED","COMPLETED","FAILED","RETURNED"]
        setupOrderStatusDropDown()
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
    
    @IBAction func statusButtonAction(_ sender: UIButton) {
        statusButtonHandler()
    }
    
    // Setup order Status Drop Down
    func setupOrderStatusDropDown() {
        orderStatusDropDown.anchorView = statusButton
        orderStatusDropDown.dataSource = statusData
        orderStatusDropDown.backgroundColor = .white
        orderStatusDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            statusButton.setTitle(item, for: .normal)
            self.orderStatusDropDown.hide()
            orderStatusDropDown.bottomOffset = CGPoint(x: -30, y: 10)
            orderStatusDropDown.width = statusButton.frame.width + 60
            orderStatusDropDown.direction = .bottom
        }
    }

}
