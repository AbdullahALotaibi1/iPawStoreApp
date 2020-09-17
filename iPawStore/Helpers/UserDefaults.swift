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
    
}

enum UserDefaultsKeys : String {
    case userUDID
}
