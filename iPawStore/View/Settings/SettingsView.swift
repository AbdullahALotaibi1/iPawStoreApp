//
//  SettingsView.swift
//  iPawStore
//
//  Created by Abdullah on 28/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit
import MBProgressHUD
import CFAlertViewController

class SettingsView: UIViewController {

    @IBOutlet weak var CustomerName: UILabel!
    @IBOutlet weak var udid: UILabel!
    @IBOutlet weak var groups: UILabel!
    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    @IBOutlet weak var buttonDashboardOutLet: UIView! { didSet{ buttonDashboardOutLet.layer.cornerRadius = 17 } }
    
    @IBOutlet weak var copyRight: UILabel!{ didSet{copyRight.text = "جميع الحقوق محفوظة © \(Config.title)" }}
    @IBOutlet weak var snapOutLet: UIButton!
    @IBOutlet weak var teleOutLet: UIButton!
    @IBOutlet weak var twittOutLet: UIButton!
    @IBOutlet weak var whtOutLet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
   
        CustomerName.text = "\(UserDefaults.standard.getFullName())"
        udid.text = "رقم الجهاز: \(UserDefaults.standard.getUserUDID())"
        groups.text = "المجموعة: \(UserDefaults.standard.getGroupName())"
        loadingAlert()
        SettingsModelView.getSettings(){
            status, message in
            self.hideAlert()
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func buttonMoveToDashboard(_ sender: Any) {
        performSegue(withIdentifier: "goToDashboard", sender: nil)
    }
    
    
    func loadingAlert() {
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "الرجاء الانتظار..."
    }
    
    func hideAlert() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    
    @IBAction func WhatsApp(_ sender: Any) {
   
        let urlW = "http://wa.me/" + SettingsModelView.data[0].whatsapp_account
        guard let url = URL(string: urlW) else {
             return
        }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
       
    }
    @IBAction func Twittet(_ sender: Any) {
        let urlW = "https://twitter.com/" + SettingsModelView.data[0].twitter_account
        guard let url = URL(string: urlW) else {
             return
        }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func snapCaht(_ sender: Any) {
        let urlW = "https://www.snapchat.com/add/" + SettingsModelView.data[0].snapchat_account
        guard let url = URL(string: urlW) else {
             return
        }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction func telegram(_ sender: Any) {
        let urlW = "https://www.t.me/" + SettingsModelView.data[0].telegram_account
        guard let url = URL(string: urlW) else {
             return
        }
        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
}
