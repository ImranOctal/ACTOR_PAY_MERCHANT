//
//  FAQViewController.swift
//  Actorpay
//
//  Created by iMac on 27/12/21.
//

import UIKit
import Alamofire

class FAQViewController: UIViewController {
    
    //MARK: - Properties -

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgView: UIView!
    
    var faqList: [FAQ] = []
    private let numberOfActualRowsForSection = 1
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.setUpTableView()
        self.getFAQData()
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Helper function -
    
    // setTableview
    func setUpTableView() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }

}

//MARK: - Extensions -

//MARK:  API Call
extension FAQViewController {
    
    // FAQ Api
    func getFAQData() {
        let params: Parameters = [:]
        print(params)
        showLoading()
        APIHelper.getFAQAll(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                print(message)
//                myApp.window?.rootViewController?.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response.data
                print(data)
                self.faqList = data.arrayValue.map({FAQ(json: $0)})
                self.tblView.reloadData()
            }
        }
    }
}

//MARK: Tableview Setup
extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList[section].sectionIsExpended ? (1 + numberOfActualRowsForSection) : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FaqCollapseTableViewCell", for: indexPath) as! FaqCollapseTableViewCell
            cell.titleLbl.text = faqList[indexPath.section].question
            faqList[indexPath.section].sectionIsExpended ? cell.setExpented() : cell.setCollpased()
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FaqExpandTableViewCell", for: indexPath) as! FaqExpandTableViewCell
            cell.descLbl.text = faqList[indexPath.section].answer?.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
            let view = UIView()
            view.backgroundColor = .clear
            cell.selectedBackgroundView = view
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            faqList[indexPath.section].sectionIsExpended = !faqList[indexPath.section].sectionIsExpended
            
            tableView.reloadSections([indexPath.section], with: .automatic)
            tableView.reloadData()
        }
    }
    
    
}
