//
//  RaiseDisputeViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 10/12/21.
//

import UIKit

class RaiseDisputeViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var mainView: UIView! {
        didSet {
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var orderNoLbl: UILabel!
    @IBOutlet weak var orderDateLbl: UILabel!
    @IBOutlet weak var orderPriceLbl: UILabel!
    @IBOutlet weak var disputeReasonDetailTextView: UITextView!
    @IBOutlet weak var disputeReasonDetailValidationLbl: UILabel!
    @IBOutlet weak var disputeReasonDetailValidationView: UIView!
    @IBOutlet weak var orderTblView: UITableView! {
        didSet {
            orderTblView.delegate = self
            orderTblView.dataSource = self
        }
    }
    @IBOutlet weak var uploadImageView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var uploadImageBtn: UIButton!
    @IBOutlet weak var disputeReasonTextField: UITextField!
    @IBOutlet weak var disputeReasonValidationLbl: UILabel!
    
    var imagePicker = UIImagePickerController()
    var status:String = ""
    var orderItems: OrderItems?
    var orderItemDtos: OrderItemDtos?
    var placeHolder = ""
    var productImage: UIImage?

    
    //MARK: - Life Cycle Function -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        self.setUpTextView()
        disputeReasonValidationLbl.isHidden = true
    }
    
    //MARK: - Selectors -
    
    //MARK: - Selectors -
    
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Cancel Order Button Action
    @IBAction func raiseDisputeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if cancelOrderValidation() {
            disputeReasonDetailValidationView.isHidden = true
//            cancelOrReturnOrderApi()
        }
    }
    
    // Upload Image Button Action
    @IBAction func uploadImageBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let alertController = UIAlertController(title:"", message: "", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Choose Existing", style: .default) { (action) in
            self.openPhotos()
        }
        let okAction2 = UIAlertAction(title: "Take Photo", style: .default) { (action) in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(okAction2)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -
    
    // SetUp Text View
    func setUpTextView() {
        disputeReasonDetailValidationView.isHidden = true
        placeHolder = "Enter reason in details"
        disputeReasonDetailTextView.delegate = self
        disputeReasonDetailTextView.text = placeHolder
        if disputeReasonDetailTextView.text == placeHolder {
            disputeReasonDetailTextView.textColor = .lightGray
        } else {
            disputeReasonDetailTextView.textColor = .black
        }
    }
    
    // Cancel Order Validation
    func cancelOrderValidation() -> Bool {
        var isValidate = true
        
        if disputeReasonDetailTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || disputeReasonDetailTextView.text == placeHolder {
            disputeReasonDetailValidationView.isHidden = false
            disputeReasonDetailValidationLbl.text = ValidationManager.shared.emptyCancelOrderDescription
            isValidate = false
        } else {
            disputeReasonDetailValidationView.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Set Order Data
    func setOrderData() {
        orderNoLbl.text = orderItems?.orderNo
        orderDateLbl.text = "Order Date: \(orderItems?.createdAt?.toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM") ?? "")"
        orderPriceLbl.text = "₹\((orderItems?.totalPrice ?? 0.0).doubleToStringWithComma())"
    }
    
    //Open Camera
    func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            let alert  = UIAlertController(title: "Warning", message: "Camera Not Supported", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //Open Image Gallary
    func openPhotos(){
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
}

//MARK: - Extensions -

//MARK: Api Call
extension RaiseDisputeViewController {
    
}

//MARK: TableView Setup
extension RaiseDisputeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderItemTableViewCell", for: indexPath) as! OrderItemTableViewCell
        cell.cancelOrderItemDtos = orderItemDtos
        return cell
    }
    
}

//MARK: Image Picker Delegate Methods
extension RaiseDisputeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.productImage = image
            uploadImageBtn.setTitle(productImage == nil ? "Upload Image":"Edit Image", for: .normal)
            imageView.contentMode = .scaleAspectFill
            imageView.image = self.productImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

// MARK: Text View Delegate Methods
extension RaiseDisputeViewController : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == placeHolder {
            textView.text = ""
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars <= 500
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.text = nil
            
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text == placeHolder {
            textView.isSelectable = true
        } else {
            textView.isSelectable = true
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count == 0 {
            textView.text = placeHolder
            textView.textColor = UIColor.lightGray
        } else {
            textView.textColor = UIColor.black
        }
        
        if textView.text == placeHolder {
            textView.isSelectable = false
            disputeReasonDetailValidationView.isHidden = false
            disputeReasonDetailValidationLbl.text = ValidationManager.shared.emptyCancelOrderDescription
        } else {
            textView.isSelectable = true
            disputeReasonDetailValidationView.isHidden = true
        }
    }
    
}
