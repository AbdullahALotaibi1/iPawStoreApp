//
//  SettingsView.swift
//  iPawStore
//
//  Created by Abdullah on 28/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class SettingsView: UIViewController {

    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    @IBOutlet weak var buttonDashboardOutLet: UIView! { didSet{ buttonDashboardOutLet.layer.cornerRadius = 17 } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonMoveToDashboard(_ sender: Any) {
        performSegue(withIdentifier: "goToDashboard", sender: nil)
    }
    
}
