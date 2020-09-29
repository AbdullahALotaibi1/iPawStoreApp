//
//  HomeViewModel.swift
//  iPawStore
//
//  Created by Abdullah on 04/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HomeViewModel {
    
    static var lastAddedApp : [Application] = []
    static var randomApp : [Application] = []
    static var urlResignApp : [String] = []
    
    static func geLastAddedApps(completionHandler: @escaping (Bool?, String?) -> ()){
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        let login = LoginModel(udid: UserDefaults.standard.getUserUDID(), ipaw_store_access_key: encryptedUDID)
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        
        AF.request(Config.lastAddedAppsUrl,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
                    if response.data != nil {                        do {
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
                                        lastAddedApp.append(Application(appID: appID, appName: appName, appIcon: appIcon, appBundle: appBundle, appVersion: appVersion, appSize: appSize))
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
    
    static func getRandomApps(completionHandler: @escaping (Bool?, String?) -> ()) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        let login = LoginModel(udid: UserDefaults.standard.getUserUDID(), ipaw_store_access_key: encryptedUDID)
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        
        AF.request(Config.randomAppsUrl,
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
                                        randomApp.append(Application(appID: appID, appName: appName, appIcon: appIcon, appBundle: appBundle, appVersion: appVersion, appSize: appSize))
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
    
    static func downloadFormUrl(ipaURL: String, completionHandler: @escaping (Bool?, String?) -> ()) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        let login = ResignOutStoreModel(udid: UserDefaults.standard.getUserUDID(), url_ipa: ipaURL, ipaw_store_access_key: encryptedUDID)
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        
        AF.request(Config.resignAppOutStore,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
//                    debugPrint(response)
                    if response.data != nil {
                        do {
                            let json = try JSON(data: response.data!)
                            let success = json["resign_app"].bool
                            if success != nil {
                                // Success Login
                                if success == true {
                                    let resign_ipa = json["resign_ipa"].string
                                    completionHandler(success, resign_ipa)
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
    
    
    static func bduplicationApp(appID: Int, appName: String, appBundle: String, appNumber: String, completionHandler: @escaping (Bool?, String?) -> ()) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        let login = ResignAppModel(udid: UserDefaults.standard.getUserUDID(), app_id: appID, app_name: appName, app_bundle: appBundle, duplicate_num: appNumber, ipaw_store_access_key: encryptedUDID)
        let headers : HTTPHeaders = ["ipaw_store_access_key": ""+encryptedUDID+""]
        
        AF.request(Config.resignAppStore,
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default,
                   headers: headers).response { response in
//                    debugPrint(response)
                    if response.data != nil {
                        do {
                            let json = try JSON(data: response.data!)
                            let success = json["resign_app"].bool
                            if success != nil {
                                // Success Login
                                if success == true {
                                    urlResignApp = []
                                    if let urlIpa = json["url_ipa"].array {
                                        for item in urlIpa {
                                            urlResignApp.append(item.string!)
                                        }
                                    }
                                    completionHandler(success, "")
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
