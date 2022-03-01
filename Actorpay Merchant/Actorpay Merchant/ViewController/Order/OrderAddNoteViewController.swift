//
//  OrderAddNoteViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 27/01/22.
//

import UIKit
import Alamofire

class OrderAddNoteViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var noteView: UIView!
    @IBOutlet weak var noteDescTextView: UITextView!
    @IBOutlet weak var notesTextViewValidationLbl: UILabel!
    
    var placeHolder = ""
    var status: String = ""
    var orderItems: OrderItems?
    var orderItemDtos: OrderItemDtos?
    var productImage : UIImage?
    var isAddNoteBtn = false
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpTextView()
        topCorner(bgView: noteView, maskToBounds: true)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
    }
    
    //MARK: - Selectors -
    
    // Cancel Button Action
    @IBAction func cancelBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    // Submit Button Action
    @IBAction func submitBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if addNoteValidation() {
            if isAddNoteBtn {
                self.notesTextViewValidationLbl.isHidden = true
                self.postOrderNoteApi()
            } else {
                notesTextViewValidationLbl.isHidden = true
                if status == "READY" ||  status == "DISPATCHED" ||  status == "DELIVERED" || status == "RETURNING ACCEPTED" || status == "RETURNING DECLINED" || status == "RETURNED" {
                    updateOrderStatusApi()
                } else {
                    cancelOrReturnOrderApi()
                }
            }
        }
    }
    
    //MARK: - Helper Functions -
    
    // SetUp Text View
    func setUpTextView() {
        notesTextViewValidationLbl.isHidden = true
        placeHolder = "Add Description"
        noteDescTextView.delegate = self
        noteDescTextView.text = placeHolder
        if noteDescTextView.text == placeHolder {
            noteDescTextView.textColor = .lightGray
        } else {
            noteDescTextView.textColor = .black
        }
    }
    
    // Add Order Notes Validation
    func addNoteValidation() -> Bool {
        var isValidate = true
        
        if noteDescTextView.text?.trimmingCharacters(in: .whitespaces).count == 0 || noteDescTextView.text == placeHolder {
            notesTextViewValidationLbl.isHidden = false
            notesTextViewValidationLbl.text = ValidationManager.shared.emptyNotesDesc
            isValidate = false
        } else {
            notesTextViewValidationLbl.isHidden = true
        }
        
        return isValidate
        
    }
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.removeFromSuperview()
            }
        });
    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            if !(noteView.frame.contains(currentPoint)) {
                removeAnimate()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

}

//MARK: - Extensions -

//MARK: Api Call
extension OrderAddNoteViewController {
    
    // Update Order Status Api
    func updateOrderStatusApi() {
        let params: Parameters = [
            "orderNo" : orderItems?.orderNo ?? "",
            "status" : status.replacingOccurrences(of: " ", with: "_")
        ]
        let bodyParams: Parameters = [
            "orderNoteDescription": noteDescTextView.text ?? "",
            "orderItemIds": [orderItemDtos?.orderItemId ?? ""]
        ]
        showLoading()
        APIHelper.updateOrderStatusApi(params: params, bodyParameter: bodyParams) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderListApi"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderDetails"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Cancel Or Return Order Api
    func cancelOrReturnOrderApi() {
        var imgData: Data?
        
        let bodyParams: Parameters = [
            "cancelOrder": [
                "cancellationRequest":"CANCELLED",
                "cancelReason": noteDescTextView.text ?? "",
                "orderItemIds": [orderItemDtos?.orderItemId ?? ""]
            ]
        ]
        if productImage != nil {
            imgData = self.productImage?.jpegData(compressionQuality: 0.1)
        }
        showLoading()
        APIHelper.cancelOrReturnOrderApi(urlParams:[:], bodyParams: bodyParams, imgData: imgData, imageKey: "file", orderNo: orderItems?.orderNo ?? "") { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
                self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderListApi"), object: self)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderDetails"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // Post Order Note Api
    func postOrderNoteApi() {
        let bodyParams: Parameters = [
            "orderNo": orderItems?.orderNo ?? "",
            "orderNoteDescription": noteDescTextView.text ?? ""
        ]
        showLoading()
        APIHelper.postOrderNoteApi(params: [:], bodyParameter: bodyParams) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
//                self.view.makeToast(message)
                let data = response.response["data"]
                print(data)
                NotificationCenter.default.post(name:  Notification.Name("reloadOrderDetails"), object: self)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: Text View Delegate Methods
extension OrderAddNoteViewController : UITextViewDelegate{
    
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
            notesTextViewValidationLbl.isHidden = false
            notesTextViewValidationLbl.text = ValidationManager.shared.emptyNotesDesc
        } else {
            textView.isSelectable = true
            notesTextViewValidationLbl.isHidden = true
        }
    }
    
}
