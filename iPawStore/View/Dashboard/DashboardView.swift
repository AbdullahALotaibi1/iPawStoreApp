//
//  DashboardView.swift
//  iPawStore
//
//  Created by Abdullah on 28/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class DashboardView: UIViewController {

    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
