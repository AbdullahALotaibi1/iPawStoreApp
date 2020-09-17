//
//  LoginView.swift
//  iPawStore
//
//  Created by Abdullah on 28/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class LoginView: UIViewController {

    @IBOutlet weak var buttonCheckOutLet: UIButton! { didSet { buttonCheckOutLet.layer.cornerRadius = 8 } }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
         
       
//            print("udid => \(UserDefaults.standard.getUserUDID() ?? "" )")
       
        
        // Do any additional setup after loading the view.
    }

}
