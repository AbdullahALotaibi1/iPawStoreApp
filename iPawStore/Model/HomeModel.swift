//
//  HomeModel.swift
//  iPawStore
//
//  Created by Abdullah on 04/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import Foundation

struct Application {
    var appID: Int?
    var appName: String?
    var appIcon: String?
    var appBundle: String?
    var appVersion: String?
    var appSize: String?
}

struct ResignOutStoreModel: Encodable {
    let udid: String
    let url_ipa: String
    let ipaw_store_access_key: String
}

struct ResignAppModel: Encodable {
    let udid: String
    let app_id: Int
    let app_name: String
    let app_bundle: String
    let duplicate_num: String
    let ipaw_store_access_key: String
}

