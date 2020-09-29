//
//  LoginViewModel.swift
//  iPawStore
//
//  Created by Abdullah on 04/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
class LoginViewModel {
    
    static func check(udid: String, completionHandler: @escaping (Bool?, String?) -> ()) {
        
        
        let encryptedUDID = Cypto.getHash(udid)
        let login = LoginModel(udid: udid, ipaw_store_access_key: encryptedUDID)
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        AF.request(Config.loginUrl,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
                    
                    if response.data != nil {
                        do {
                            let json = try JSON(data: response.data!)
                            let success = json["success"].bool
                            if success != nil {
                                let message = json["message"].string
                                // Success Login
                                if success == true {
                                    let fullName = json["full_name"].string
                                    let groupName = json["group_name"].string
                                    UserDefaults.standard.setFullName(value: fullName!)
                                    UserDefaults.standard.setGroupName(value: groupName!)
                                    completionHandler(success, message)
                                }else{
                                    completionHandler(success, message)
                                }
                            }
                        } catch {
                            completionHandler(false, "حدث خطاء اثناء الاتصال بسيرفر.")
                        }
                        
                        
                    }
                   }
        
    }
}
