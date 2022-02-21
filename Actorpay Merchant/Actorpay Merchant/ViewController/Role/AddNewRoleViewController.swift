//
//  AddNewRoleViewController.swift
//  Actorpay Merchant
//
//  Created by iMac on 29/01/22.
//

import UIKit
import Alamofire

class AddNewRoleViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var headerTitleLbl: UILabel!
    @IBOutlet weak var tblView: UITableView! {
        didSet {
            self.tblView.delegate = self
            self.tblView.dataSource = self
        }
    }
    @IBOutlet weak var titleTextField: UITextField! {
        didSet {
            self.titleTextField.delegate = self
        }
    }
    @IBOutlet weak var descTextField: UITextField! {
        didSet {
            self.descTextField.delegate = self
        }
    }
    @IBOutlet weak var addNewRoleBtn: UIButton!
    @IBOutlet weak var titleValidationLbl: UILabel!
    @IBOutlet weak var descValidationLbl: UILabel!
    
    var screenList: [ScreenList] = []
    var roleId: String?
    var roleItem: RoleItems?
    var isUpdateRole = false
    var screenAccessPermission: [ScreenAccessPermission] = []
    
    //MARK: - Life Cycles -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        topCorner(bgView: bgView, maskToBounds: true)
        self.getAllScreenApi()
        self.headerTitleLbl.text = isUpdateRole ? "UPDATE ROLE" : "ADD NEW ROLE"
        self.addNewRoleBtn.setTitle(isUpdateRole ? "Update Role" : "+ Add New Role", for: .normal)
        self.manageValidationLbl()
        if isUpdateRole {
            self.getRoleDetailsByIdApi()
        }
    }
    
    //MARK: - Selectors -
    
    // Back Button Action
    @IBAction func backBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    // Add New Role Button Action
    @IBAction func addNewRoleBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if validateRole() {
            self.manageValidationLbl()
            if isUpdateRole {
                updateRoleApi()
            } else {
                createRoleApi()
            }
        }
    }
    
    //MARK: - Helper Functions -
    
    // SetUp Update Role Data
    func setUpdateRoleData() {
        titleTextField.text = roleItem?.name
        descTextField.text = roleItem?.description
        for (i, val) in screenList.enumerated() {
            for (_, value) in (roleItem?.screenAccessPermission ?? []).enumerated() {
                if val.id == value.screenId {
                    screenList[i].isReadSelected = value.read
                    screenList[i].isWriteSelected = value.write
                    screenAccessPermission.append(value)
                }
            }
        }
        self.tblView.reloadData()
    }
    
    // Validation Label Manage
    func manageValidationLbl() {
        titleValidationLbl.isHidden = true
        descValidationLbl.isHidden = true
    }
    
    // Role Validation
    func validateRole() -> Bool {
        var isValidate = true
        if titleTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            titleValidationLbl.isHidden = false
            titleValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            titleValidationLbl.isHidden = true
        }
        if descTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
            descValidationLbl.isHidden = false
            descValidationLbl.text = ValidationManager.shared.emptyField
            isValidate = false
        } else {
            descValidationLbl.isHidden = true
        }
        
        return isValidate
    }
    
}

//MARK: - Extensions -

//MARK: Api Call
extension AddNewRoleViewController {
    
    // Get All Screen Api
    func getAllScreenApi() {
        showLoading()
        APIHelper.getAllScreenApi(parameters: [:]) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                let data = response.response.data
                self.screenList = data.arrayValue.map({ScreenList(json: $0)})
                self.tblView.reloadData()
            }
        }
    }
    
    // Get Role Details By Id Api
    func getRoleDetailsByIdApi () {
        let params: Parameters = [
            "id": roleId ?? ""
        ]
        showLoading()
        APIHelper.getRoleDetailsByIdApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                let data = response.response["data"]
                self.roleItem = RoleItems.init(json: data)
                self.setUpdateRoleData()
            }
        }
    }
    
    // Create Role Api
    func createRoleApi() {
        var screenAccessParam : [Parameters] = []
        var param: Parameters = [:]
        for (_, val) in screenAccessPermission.enumerated() {
            param["read"] = val.read
            param["write"] = val.write
            param["screenId"] = val.screenId
            screenAccessParam.append(param)
        }
        let bodyParams: Parameters = [
            "name":titleTextField.text ?? "",
            "description":descTextField.text ?? "",
            "screenAccessPermission": screenAccessParam
        ]
        showLoading()
        APIHelper.createRoleApi(params: [:], bodyParameter: bodyParams) { (success, response) in
            self.tblView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                NotificationCenter.default.post(name: Notification.Name("reloadRoleListApi"), object: self)
                myApp.window?.rootViewController?.view.makeToast(message)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // Update Sub Merchant Api
    func updateRoleApi() {
        var screenAccessParam : [Parameters] = []
        var param: Parameters = [:]
        for (_, val) in screenAccessPermission.enumerated() {
            param["read"] = val.read
            param["write"] = val.write
            param["screenId"] = val.screenId
            screenAccessParam.append(param)
        }
        let bodyParams: Parameters = [
            "id": roleItem?.id ?? "",
            "name": titleTextField.text ?? "",
            "description": descTextField.text ?? "",
            "screenAccessPermission": screenAccessParam
        ]
        showLoading()
        APIHelper.updateRoleApi(params: [:], bodyParameter: bodyParams) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                myApp.window?.rootViewController?.view.makeToast(message)
                NotificationCenter.default.post(name:  Notification.Name("reloadRoleListApi"), object: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}

//MARK: Table View SetUp
extension AddNewRoleViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenList.count == 0{
            tableView.setEmptyMessage("No Screen Found")
        } else {
            tableView.restore()
        }
        return screenList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewRoleTableViewCell", for: indexPath) as! AddNewRoleTableViewCell
        let item = screenList[indexPath.row]
        cell.item = item
        cell.readBtn.isEnabled = !(item.isWriteSelected ?? false)
        cell.readBtn.setImage(UIImage(named:(item.isReadSelected ?? false ? "fill_check_box" : "unfill_check_box")), for: .normal)
        cell.writeBtn.setImage(UIImage(named:(item.isWriteSelected ?? false ? "fill_check_box" : "unfill_check_box") ), for: .normal)
        cell.checkBoxBtnHandler = { tag in
            for (indx,i) in self.screenAccessPermission.enumerated() {
                if i.screenId == item.id ?? "" {
                    self.screenAccessPermission.remove(at: indx)
                    break
                }
            }
            if tag == 1001 {
                if item.isReadSelected == true {
                    //                    if item.isWriteSelected == true {
                    //                        self.screenAccessPermission.append(ScreenAccessPermission.init(screenId: item.id ?? "", read: self.screenList[indexPath.row].isReadSelected ?? true, write: self.screenList[indexPath.row].isWriteSelected ?? false, screenName: item.screenName ?? ""))
                    //                    }else{
                    self.screenList[indexPath.row].isReadSelected = false
                    //                    }
                } else {
                    self.screenList[indexPath.row].isReadSelected = true
                    self.screenAccessPermission.append(ScreenAccessPermission.init(screenId: item.id ?? "", read: self.screenList[indexPath.row].isReadSelected ?? true, write: self.screenList[indexPath.row].isWriteSelected ?? false, screenName: item.screenName ?? ""))
                }
            } else {
                if (item.isWriteSelected == true) {
                    //                    if item.isReadSelected == true {
                    //                            cell.readBtn.isEnabled = true
                    ////                        self.screenAccessPermission.append(ScreenAccessPermission.init(screenId: item.id ?? "", read: self.screenList[indexPath.row].isReadSelected ?? false, write: self.screenList[indexPath.row].isWriteSelected ?? true, screenName: item.screenName ?? ""))
                    //                    }else{
                    //                        cell.readBtn.isEnabled = true
                    self.screenList[indexPath.row].isWriteSelected = false
                    self.screenList[indexPath.row].isReadSelected = false
                    //                    }
                } else {
                    self.screenList[indexPath.row].isWriteSelected = true
                    self.screenList[indexPath.row].isReadSelected = true
                    self.screenAccessPermission.append(ScreenAccessPermission.init(screenId: item.id ?? "", read: self.screenList[indexPath.row].isReadSelected ?? false, write: self.screenList[indexPath.row].isWriteSelected ?? true, screenName: item.screenName ?? ""))
                }
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
            print(self.screenAccessPermission)
        }
        return cell
    }
    
}

//MARK: Text Field Delegate Methods
extension AddNewRoleViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch textField {
        case titleTextField:
            if titleTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                titleValidationLbl.isHidden = false
                titleValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                titleValidationLbl.isHidden = true
            }
        case descTextField:
            if descTextField.text?.trimmingCharacters(in: .whitespaces).count == 0 {
                descValidationLbl.isHidden = false
                descValidationLbl.text = ValidationManager.shared.emptyField
            } else {
                descValidationLbl.isHidden = true
            }
        default:
            break
        }
    }
}
