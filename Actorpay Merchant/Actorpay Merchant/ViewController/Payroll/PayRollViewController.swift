//
//  PayRollViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class PayRollViewController: UIViewController {

    //MARK:- Properties -
    
    @IBOutlet weak var mainView: UIView!{
        didSet{
            topCorner(bgView: mainView, maskToBounds: true)
        }
    }
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.separatorStyle = .none
        }
    }
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var payrollArray:[Int] = [1,2,3,4,5]
    
    //MARK:- life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewHeightManage()
        // Do any additional setup after loading the view.
    }
    
    //MARK:- Selectors -
    
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Helper Function -
    
    func tableViewHeightManage(){
        tableViewHeightConstraint.constant = CGFloat((payrollArray.count == 0 ? Int(100.0) : (payrollArray.count*100)))
    }
}


// MARK: - Extensions -

extension PayRollViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return payrollArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayRollTableViewCell", for: indexPath) as! PayRollTableViewCell
        cell.payButtonHandler = {
            self.view.makeToast("No Available Service")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
