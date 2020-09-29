//
//  SettingsModelView.swift
//  iPawStore
//
//  Created by Abdullah on 05/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SettingsModelView {
    
    static var data: [SettingsModel] = []
    
    static func getSettings(completionHandler: @escaping (Bool?, String?) -> ()) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        let login = LoginModel(udid: UserDefaults.standard.getUserUDID(), ipaw_store_access_key: encryptedUDID)
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        
        AF.request(Config.settings,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
//                    debugPrint(response)
                    if response.data != nil {
                        do {
                            let json = try JSON(data: response.data!)
                            let success = json["success"].bool
                            if success != nil {
                                // Success Login
                                if success == true {
                                    data.append(SettingsModel(twitter_account: json["twitter_account"].string!, snapchat_account: json["snapchat_account"].string!, telegram_account: json["telegram_account"].string!, whatsapp_account: json["whatsapp_account"].string!))
                                    completionHandler(success, nil)
                                }else{
                                    let message = json["message"].string
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
