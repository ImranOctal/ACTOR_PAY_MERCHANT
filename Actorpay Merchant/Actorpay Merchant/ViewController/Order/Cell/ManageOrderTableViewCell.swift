//
//  ManageOrderTableViewCell.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit
import SDWebImage

class ManageOrderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var totalPriceLbl: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var orderStatusView: UIView!
    
    var orderItemDtos: [OrderItemDtos]?
    var item: OrderItems? {
        didSet {
            if let item = self.item {
                orderNoLbl.text = item.orderNo
                totalPriceLbl.text = "Price: ₹\(item.totalPrice ?? 0.0)"
                statusLabel.text = item.orderStatus
                orderDateLbl.text = "Order Date:\(item.createdAt?.toFormatedDate(from: "yyyy-MM-dd HH:mm", to: "dd MMM yyyy HH:MM") ?? "")"
                orderStatusView.layer.borderColor = getStatus(stausString: item.orderStatus ?? "").cgColor
                statusLabel.textColor = getStatus(stausString: item.orderStatus ?? "")
                orderItemDtos = item.orderItemDtos
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //Setup Collection View
    func setUpCollectionView() {
        imgCollectionView.delegate = self
        imgCollectionView.dataSource = self
    }

}

extension ManageOrderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderItemDtos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OrderImgCollectionViewCell", for: indexPath) as! OrderImgCollectionViewCell
        cell.imgView.sd_setImage(with: URL(string: orderItemDtos?[indexPath.row].image ?? ""), placeholderImage: UIImage(named: "placeholder_img"), options: SDWebImageOptions.allowInvalidSSLCertificates, completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if orderItemDtos?.count == 1 {
            return CGSize(width: (collectionView.frame.size.width), height: (collectionView.frame.size.width))
        }
        else if orderItemDtos?.count == 2 {
            return CGSize(width: (collectionView.frame.size.width-2.5) / 2, height: (collectionView.frame.size.width))
        }
        else if orderItemDtos?.count == 3 {
            if indexPath.row == 2 {
                return CGSize(width: (collectionView.frame.size.width) , height: (collectionView.frame.size.width-2.5) / 2)
            }else {
                return CGSize(width: (collectionView.frame.size.width - 2.5) / 2 , height: (collectionView.frame.size.width-2.5) / 2)
            }
        }
        else {
            return CGSize(width: (collectionView.frame.size.width-2.5) / 2, height: (collectionView.frame.size.width-2.5)/2)
        }
        
    }
}
