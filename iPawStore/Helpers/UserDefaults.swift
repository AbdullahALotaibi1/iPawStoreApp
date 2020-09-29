//
//  UserDefaults.swift
//  iPawStore
//
//  Created by Abdullah on 28/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

extension UserDefaults {
    
    //MARK: Save User Data
    func setUserUDID(value: String){
        set(value, forKey: UserDefaultsKeys.userUDID.rawValue)
    }

    //MARK: Retrieve User Data
    func getUserUDID() -> String {
        return string(forKey: UserDefaultsKeys.userUDID.rawValue)!
    }

    
    func setFullName(value: String){
        set(value, forKey: UserDefaultsKeys.fullName.rawValue)
    }

    //MARK: Retrieve User Data
    func getFullName() -> String {
        return string(forKey: UserDefaultsKeys.fullName.rawValue)!
    }
    
    func setGroupName(value: String){
        set(value, forKey: UserDefaultsKeys.groupName.rawValue)
    }

    //MARK: Retrieve User Data
    func getGroupName() -> String {
        return string(forKey: UserDefaultsKeys.groupName.rawValue)!
    }

    
    func hasValueUserUDID() -> Bool {
            return nil != object(forKey: UserDefaultsKeys.userUDID.rawValue)
    }
}

enum UserDefaultsKeys : String {
    case userUDID, fullName, groupName
}
