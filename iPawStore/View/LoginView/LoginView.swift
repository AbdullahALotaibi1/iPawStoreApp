//
//  LoginView.swift
//  iPawStore
//
//  Created by Abdullah on 28/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit
import MBProgressHUD
import CFAlertViewController

class LoginView: UIViewController {

    @IBOutlet weak var titleLogin: UILabel!{ didSet {
        titleLogin.text = " اهلاً بك في \(Config.title) ✨"
    }}
    @IBOutlet weak var Logo: UIImageView!{ didSet{ Logo.layer.cornerRadius = 20 }}
    @IBOutlet weak var buttonCheckOutLet: UIButton! { didSet { buttonCheckOutLet.layer.cornerRadius = 8 } }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check User udid has value
        if UserDefaults.standard.hasValueUserUDID() {
            checkCustomer()
        }
    }
    
    
    
    @IBAction func checkCustomer(_ sender: Any){
        if UserDefaults.standard.hasValueUserUDID() {
            checkCustomer()
        }else{
            print(Config.checkLoginUrl)
           getUDID()
        }
    }
    
    
    
    func checkCustomer() {
        loadingAlert()
        LoginViewModel.check(udid: UserDefaults.standard.getUserUDID()) {
            statusLogin, message in
            self.serverMessage(status: statusLogin!, message: message!)
        }
    }
    
    func getUDID(){
        guard let url = URL(string: Config.checkLoginUrl) else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func loadingAlert() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "الرجاء الانتظار..."
    }
    
    func hideAlert() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    func serverMessage(status: Bool, message: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        if(status == false){
            DispatchQueue.main.async {
            // Create Alet View Controller
            let alertController = CFAlertViewController(title: "تنبية!",
                                                        message: message,
                                                        textAlignment: .right,
                                                        preferredStyle: .notification,
                                                        didDismissAlertHandler: nil)
            
            let cancelAction = CFAlertAction(title: "اغلاق",
                                             style: .Cancel,
                                              alignment: .justified,
                                              backgroundColor: UIColor(hex: "#dddddd"),
                                              textColor: nil,
                                              handler: { (action) in })
            
            alertController.addAction(cancelAction)

            // Present Alert View Controller
            self.present(alertController, animated: true, completion: nil)
        }
        }else{
            performSegue(withIdentifier: "openHome", sender: nil)
        }
    }
}
