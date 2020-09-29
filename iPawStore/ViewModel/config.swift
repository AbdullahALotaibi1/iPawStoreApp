//
//  config.swift
//  iPawStore
//
//  Created by Abdullah on 04/02/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import Foundation

class Config {
    
    // MARK: - Confing
    static let title = "XiStore"
    
    // MARK:- Store URL
    static let url = "https://xistore2.me/"
    static let checkLoginUrl = url + "storage/mobileconfig/check.mobileconfig"
    static let loginUrl = url + "api/customer/check/udid"
    static let lastAddedAppsUrl = url + "api/applications/last_added_apps"
    static let randomAppsUrl = url + "api/applications/random_apps"
    static let installAppUrl = "itms-services://?action=download-manifest&url=" + url + "api/applications/get_plist/"
    static let resignAppOutStore = url + "api/applications/resign_app/url"
    static let resignAppStore = url + "api/applications/resign_app"
    static let allApps = url + "api/applications/all_apps"
    static let settings = url + "api/store/settings"
}
