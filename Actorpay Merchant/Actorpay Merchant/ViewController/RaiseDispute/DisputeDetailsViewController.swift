//
//  DisputeDetailsViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 16/02/22.
//

import UIKit
import Alamofire

class DisputeDetailsViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var disputeCodeLbl: UILabel!
    @IBOutlet weak var disputeTitleLbl: UILabel!
    @IBOutlet weak var disputeDescLbl: UILabel!
    @IBOutlet weak var disputeStatusLbl: UILabel!
    @IBOutlet weak var disputeDateLbl: UILabel!
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var mainView: UIView! {
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    @IBOutlet weak var messageTextField: UITextField!
    
    var disputeMessages:[DisputeMessages] = []
    var disputeDetails: DisputeItem?
    var disputeId: String = ""
    var disputeCode: String = ""
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        self.disputeDetailsApi()
        self.disputeListApi()
        self.tableView.addPullToRefresh {
//            self.disputeDetailsApi()
            self.disputeListApi()
        }
        
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Send Message Button Action
    @IBAction func sendBtnAction(_ sender: UIButton) {
        if messageValidation() {
            if let msg = messageTextField.text {
                sendMessageAPI(message: msg)
            }
        }
    }
    
    //MARK: - Helper Functions -
    
    // Message Validation
    func messageValidation() -> Bool {
        var isValidate = true
        
        if messageTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            self.view.makeToast("Please an enter Message")
            isValidate = false
        }
        return isValidate
        
    }
    
    // SetUp Dispute Details Data
    func setupData(){
        if let disputeDetails = self.disputeDetails {
            disputeCodeLbl.text = disputeDetails.disputeCode
            disputeTitleLbl.text = disputeDetails.title
            disputeDescLbl.text = disputeDetails.description
            disputeStatusLbl.text = disputeDetails.status
            disputeDateLbl.text = (disputeDetails.createdAt ?? "").toFormatedDate(from: "yyyy-MM-dd hh:mm", to: "dd MMM yyyy HH:MM")
            disputeStatusLbl.textColor = getStatus(stausString: disputeDetails.status ?? "")
        }
    }
    
    // Scroll Tableview To Bottom
    func scrollToBottom() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
            }
        }
    }
}

//MARK: - Extension -

//MARK: Api Call
extension DisputeDetailsViewController {
    
    // Dispute Details Api
    func disputeDetailsApi(){
        showLoading()
        APIHelper.disputeDetailsApi(id: disputeId) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.disputeDetails = DisputeItem.init(json: data)
                print(data)
                self.setupData()
                let message = response.message
                print(message)
                self.disputeMessages = self.disputeDetails?.disputeMessages ?? []
                self.disputeMessages = self.disputeMessages.reversed()
                self.scrollToBottom()
                self.tableView.reloadData()
            }
        }
    }
    
    // Send Message Api
    func sendMessageAPI(message: String) {
        showLoading()
        let params: Parameters = [
            "disputeId":disputeId,
            "message": message
        ]
        print(params)
        APIHelper.sendMessageAPI(bodyParameter: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
//                self.disputeDetailsApi()
                self.disputeListApi()
                self.messageTextField.text = nil
                self.tableView.reloadData()
            }
        }
    }
    
    // Dispute List Api
    func disputeListApi() {
        
        let bodyParameter: Parameters = [
            "disputeCode": disputeCode
        ]
        
        showLoading()
        APIHelper.disputeListApi(urlParameters: [:], bodyParameter: bodyParameter ) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.disputeDetails = DisputeList.init(json: data).items?[0]
                self.disputeMessages = self.disputeDetails?.disputeMessages ?? []
                self.disputeMessages = self.disputeMessages.reversed()
                self.tableView.reloadData()
            }
        }
    }
    
}

//MARK: TableView SetUp
extension DisputeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if disputeMessages.count == 0{
            tableView.setEmptyMessage("No Message Found")
        } else {
            tableView.restore()
        }
        return disputeMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = disputeMessages[indexPath.row]
        if message.userType == "customer" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerMessageCell", for: indexPath) as! CustomerMessageCell
            if indexPath.row != 0 {
                if message.userType == disputeMessages[indexPath.row - 1].userType {
                    cell.userTypeView.isHidden = true
                } else {
                    cell.userTypeView.isHidden = false
                }
            }
            cell.message = message
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MerchantMessageCell", for: indexPath) as! MerchantMessageCell
            if indexPath.row != 0 {
                if message.userType == disputeMessages[indexPath.row - 1].userType {
                    cell.userTypeView.isHidden = true
                } else {
                    cell.userTypeView.isHidden = false
                }
            }
            cell.message = message
            return cell
        }
    }
    
}
