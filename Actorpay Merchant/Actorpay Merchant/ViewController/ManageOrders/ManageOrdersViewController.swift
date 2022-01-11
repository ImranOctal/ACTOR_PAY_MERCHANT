//
//  ManageOrdersViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 13/12/21.
//

import UIKit

class ManageOrdersViewController: UIViewController {
    
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
    
    //MARK:- life Cycle Function -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK:- Selectors -
    
    @IBAction func backButttonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Helper Function -

}

// MARK: - Extensions -

extension ManageOrdersViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageOrderTableViewCell", for: indexPath) as! ManageOrderTableViewCell
        cell.deleteButtonHandler = {
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
