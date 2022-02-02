//
//  AddNewRoleTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/01/22.
//

import UIKit

class AddNewRoleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var screenTitleLbl: UILabel!
    @IBOutlet weak var readBtn: UIButton!
    @IBOutlet weak var writeBtn: UIButton!
    
    var item: ScreenList? {
        didSet {
            if let item = self.item {
                screenTitleLbl.text = item.screenName
            }
        }
    }
    var readBtnHandler: (() -> ())!
    var writeBtnHandler: (() -> ())!
    var checkBoxBtnHandler: ((_ tag:Int) -> ())!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Check Box Btn Action
    @IBAction func checkBoxBtnAction(_ sender: UIButton) {
        checkBoxBtnHandler(sender.tag)
    }

}
