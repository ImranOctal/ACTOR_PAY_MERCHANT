//
//  HomeViewControllerApiCall.swift
//  Actorpay Merchant
//
//  Created by iMac on 28/01/22.
//

import Foundation
import Alamofire
import PopupDialog

//MARK: Api Call
extension HomeViewController {
    
    //Get Merchant Details By Id Api
    @objc func getMerchantDetailsByIdApi() {
        showLoading()
        APIHelper.getMerchantDetailsById(id: AppManager.shared.merchantUserId) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
//                self.view.makeToast(message)
                print(message)
                let customV = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
                let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
                customV.setUpCustomAlert(titleStr: "Logout", descriptionStr: "Session Expire", isShowCancelBtn: true)
                customV.okBtn.tag = 1
                customV.customAlertDelegate = self
                self.present(popup, animated: true, completion: nil)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                merchantDetails = MerchantDetails.init(json: data)
                AppManager.shared.merchantId = merchantDetails?.merchantId ?? ""
                print(AppManager.shared.merchantId)
                NotificationCenter.default.post(name:Notification.Name("setProfileData"), object: self)
                NotificationCenter.default.post(name:Notification.Name("setMerchantDetailsData"), object: self)
                
            }
        }
    }
    
    // Get Product List Api
    func getProductListAPI(parameter: Parameters? = nil, bodyParameter:Parameters? = nil) {
        var parameters = Parameters()
        
        if parameter == nil {
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        } else{
            page = 0
            if let parameter = parameter {
                parameters = parameter
            }
            parameters["pageNo"] = page
            parameters["pageSize"] = 10
        }
        
        var bodyParam = Parameters()
        if bodyParameter == nil {
            if let bodyParameter = filterparm {
                bodyParam = bodyParameter
            }
        } else {
            if let bodyParameter = bodyParameter {
                bodyParam = bodyParameter
            }
        }
        
        showLoading()
        APIHelper.getProductListApi(params: parameters, bodyParameter: bodyParam) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.product = ProductList.init(json: data)
                if self.page == 0 {
                    self.productList = ProductList.init(json: data).items ?? []
                } else{
                    self.productList.append(contentsOf: ProductList.init(json: data).items ?? [])
                }
                self.filteredArray = self.productList
                self.totalCount = self.product?.totalItems ?? 0
                let message = response.message
                print(message)
                self.tableView.reloadData()
            }
        }
    }
    
    // View All Active Product Api
    func viewAllActiveProductListApi(){
        let params: Parameters = [
            "pageNo":page,
            "pageSize":10
        ]
        print(params)
        showLoading()
        APIHelper.viewAllActiveProductListApi(parameters: params) { (success, response) in
            self.tableView.pullToRefreshView?.stopAnimating()
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.activeProductList = ProductList.init(json: data)
                let message = response.message
                print(message)
            }
        }
    }
    
    // Remove Product By Id
    func removeProductByIdApi(productId: String) {
        let params: Parameters = [
            "productId" : productId
        ]
        showLoading()
        APIHelper.removeProductById(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.getProductListAPI()
            }
        }
    }
    
    // Change Product Status By Id
    func changeProductStatusApi(productId: String, status: String) {
        let params: Parameters = [
            "id" : productId,
            "status" : status
        ]
        showLoading()
        APIHelper.changeProductStatusApi(params: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let message = response.message
                print(message)
                self.getProductListAPI()
            }
        }
    }
    
    // Get All Tax Data By HSN Code Api
    func getAllTaxDataByHSNCode(HSNCode: String) {
        showLoading()
        APIHelper.getAllTaxDataByHSNCodeApi(parameters: [:],HSNCode: HSNCode) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.getTaxDataByHSNCode = TaxList.init(json: data)
                let message = response.message
                print(message)
            }
        }
    }
    
    // View Active Tax Data By ID
    func viewActiveTaxDataByIDApi(taxID: String) {
        showLoading()
        APIHelper.viewActiveTaxDataByIDApi(parameters: [:], taxID: taxID) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            }else {
                dissmissLoader()
                let data = response.response["data"]
                self.viewActiveTaxDataById = TaxList.init(json: data)
                let message = response.message
                print(message)
            }
        }
    }
    
    // Get Role List Api
    func getRoleListApi() {
        let params: Parameters = [
            "pageNo": roleListPage,
            "pageSize": 5,
            "sortBy": "createdAt",
            "asc": true
        ]
        showLoading()
        APIHelper.getRoleListApi(parameters: params) { (success, response) in
            if !success {
                dissmissLoader()
                let message = response.message
                self.view.makeToast(message)
            } else {
                dissmissLoader()
                let message = response.message
                print(message)
                let data = response.response["data"]
                roleList = RoleList.init(json: data)
                if roleListPage == 0 {
                    roleItems = RoleList.init(json: data).items ?? []
                } else {
                    roleItems.append(contentsOf: RoleList.init(json: data).items ?? [])
                }
                roleListTotalCount = roleList?.totalItems ?? 0
                NotificationCenter.default.post(name: Notification.Name("reloadRoleListTblView"), object: self)
            }
        }
    }
    
}
