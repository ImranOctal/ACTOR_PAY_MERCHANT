//
//  APIManager.swift
//  Actorpay
//
//  Created by iMac on 20/12/21.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias APICompletionBlock = (_ respone:APIResponse) -> Void
//
struct APIResponse {
    var success = false
    var message = ""
    var response:JSON
    
    static func createAPIResponse(_ success:Bool,_ message:String = "", _ response:JSON = JSON.null) -> APIResponse {
        return APIResponse.init(success: success, message: message, response: response)
    }
    
    static func createSuccessAPIResponse(_ message:String = "",_ response:JSON = JSON.null) -> APIResponse {
        return APIResponse.init(success: true, message: message, response: response)
    }
    
    static func createFailureAPIResponse(_ message:String = "", _ response:JSON = JSON.null) -> APIResponse {
        return  APIResponse.init(success: false, message: message, response: response)
    }
}


class APIManager {
    
    static var shared = APIManager()
    var manager = Session.default
    var absoluteUrl = ""
    
    func getMethod(method : HTTPMethod = .get, url:String, parameters:Parameters = [:], success:@escaping APICompletionBlock){
        absoluteUrl = APIBaseUrlPoint.localHostBaseURL.rawValue + url
        let headers: HTTPHeaders = [.authorization(bearerToken: AppManager.shared.token)]
        var param:Parameters? = parameters
        if method == .get {
            if let urlParameters = param {
                if !(urlParameters.isEmpty) {
                    absoluteUrl.append("?")
                    var array:[String] = []
                    let _ = urlParameters.map { (key, value) -> Bool in
                        let str = key + "=" +  String(describing: value)
                        array.append(str)
                        return true
                    }
                    absoluteUrl.append(array.joined(separator: "&"))
                }
            }
            param = nil
        }
        print(absoluteUrl)
        manager.request(absoluteUrl, method: method, /*parameters: parameters, encoding: JSONEncoding.default,*/ headers: headers)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let retrivedResult):
                    let responseJSON = JSON(retrivedResult)
                    let message = responseJSON["message"].stringValue
                    success(APIResponse.createSuccessAPIResponse(message, responseJSON))
                    break
                case .failure(let errorGiven):
                    print(errorGiven.errorDescription ?? "")
                    break
                }
            })
    }
    
    func request(method : HTTPMethod, url:String, parameters:Parameters, success:@escaping APICompletionBlock){
        absoluteUrl = APIBaseUrlPoint.localHostBaseURL.rawValue + url
        print(absoluteUrl)
        manager.request(absoluteUrl, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let retrivedResult):
                    let responseJSON = JSON(retrivedResult)
                    let message = responseJSON["message"].stringValue
                    success(APIResponse.createSuccessAPIResponse(message, responseJSON))
                    break
                case .failure(let errorGiven):
                    print(errorGiven.errorDescription ?? "")
                    break
                }
            })
    }
    
    
    func request2(method : HTTPMethod, url:String, parameters:Parameters, success:@escaping APICompletionBlock){
        absoluteUrl = APIBaseUrlPoint.localHostBaseURL.rawValue + url
        print(absoluteUrl)
        let headers: HTTPHeaders = [.authorization(bearerToken: AppManager.shared.token)]
        manager.request(absoluteUrl, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let retrivedResult):
                    let responseJSON = JSON(retrivedResult)
                    let message = responseJSON["message"].stringValue
                    success(APIResponse.createSuccessAPIResponse(message, responseJSON))
                    break
                case .failure(let errorGiven):
                    print(errorGiven.errorDescription ?? "")
                    break
                }
            })
    }
    
    
}
