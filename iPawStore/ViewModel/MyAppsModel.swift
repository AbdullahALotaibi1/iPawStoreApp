//
//  MyApps.swift
//  iPawStore
//
//  Created by Abdullah on 05/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MyAppsModel {
    static var allApp : [Application] = []
    
    static func getAllApps(completionHandler: @escaping (Bool?, String?) -> ()) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        let login = LoginModel(udid: UserDefaults.standard.getUserUDID(), ipaw_store_access_key: encryptedUDID)
//        let encryptedUDID = Cypto.getHash()
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        
        AF.request(Config.allApps,
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
                                    if let data = json["data"].array {
                                       for item in data {
                                        let appID = item["app_id"].int
                                        let appName = item["app_name"].string
                                        let appIcon = item["app_icon"].string
                                        let appBundle = item["app_bundle"].string
                                        let appVersion = item["app_version"].string
                                        let appSize = item["app_size"].string
                                        allApp.append(Application(appID: appID, appName: appName, appIcon: appIcon, appBundle: appBundle, appVersion: appVersion, appSize: appSize))
                                       }
                                    }
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
