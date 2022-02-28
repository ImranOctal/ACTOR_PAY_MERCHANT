//
//  DashboardViewControllerApiCall.swift
//  Actorpay Merchant
//
//  Created by iMac on 21/02/22.
//

import Foundation
import Alamofire
import PopupDialog

//MARK: - Extensions -

//MARK: Api Call
extension DashboardViewController {
    
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
    
    // Get Role List Api
    func getRoleListApi() {
        let params: Parameters = [
            "pageNo": roleListPage,
            "pageSize": 5,
            "sortBy": "createdAt",
            "asc": true
        ]
        showLoading()
        APIHelper.getRoleListApi(urlParameters: params) { (success, response) in
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
