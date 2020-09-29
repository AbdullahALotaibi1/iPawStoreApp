//
//  MyAppsView.swift
//  iPawStore
//
//  Created by Abdullah on 27/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit
import CFAlertViewController
import MBProgressHUD
import RLBAlertsPickers
import SCLAlertView

class MyAppsView: UIViewController {

    // MARK: - Variables
    var filteredData:[Application]?
    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    @IBOutlet weak var tableViewOutLet: UITableView!
    @IBOutlet weak var searchBarOutLet: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        hideKeyboardWhenTappedAround()
        loadingAlert()
        self.filteredData = []
        MyAppsModel.getAllApps(){ [self]
            statusLogin, message in
            if statusLogin == true {
                self.hideAlert()
                self.filteredData = MyAppsModel.allApp
                self.tableViewOutLet.reloadData()
            }else{
                
            }
        }
    }
}


//MARK: - Table View
extension MyAppsView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Setup Table View
    func setupTableView(){
        tableViewOutLet.delegate = self
        tableViewOutLet.dataSource = self
        registerNibs()
    }
    
    // MARK: - Register All Nibs
    func registerNibs() {
        self.tableViewOutLet.register(UINib(nibName: "ListAppCell", bundle: nil), forCellReuseIdentifier: "ListAppCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData!.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let listAppCell = tableView.dequeueReusableCell(withIdentifier: "ListAppCell", for: indexPath) as! ListAppCell
        listAppCell.update(app: filteredData![indexPath.row])
         return listAppCell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0.01 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            alertInstallApp(id: indexPath.row)
    }
    
}


//MARK: - Search Bar
extension MyAppsView: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBarOutLet.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        if searchText == "" {
            self.filteredData = MyAppsModel.allApp
        }else{
            for app in MyAppsModel.allApp {
                if app.appName!.lowercased().contains(searchText.lowercased()){
                    filteredData?.append(app)
                }
            }
        }
        
        self.tableViewOutLet.reloadData()
    }
}


// Put this piece of code anywhere you like
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension MyAppsView {
        
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


// MARK: - Function Install + Resign Apps
extension MyAppsView {
    
    func alertInstallApp(id appID: Int){
            DispatchQueue.main.async {
            // Create Alet View Controller
                let alertController = CFAlertViewController(title: MyAppsModel.allApp[appID].appName,
                                                        message: "يمكن تثبيت تطبيق \(MyAppsModel.allApp[appID].appName!) مباشرة او تعديل اسم التطبيق او تعديل بندل التطبيق وتكرار التطبيق لاكثر من نسخة.",
                                                        textAlignment: .right,
                                                        preferredStyle: .actionSheet,
                                                        didDismissAlertHandler: nil)

            // Create Upgrade Action
            let installAction = CFAlertAction(title: "تثبيت",
                                              style: .Default,
                                              alignment: .justified,
                                              backgroundColor: UIColor(hex: "#018083"),
                                              textColor: nil,
                                              handler: { (action) in
                                                // MARK: - Prepare Url Install
                                                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                                                loadingNotification.mode = MBProgressHUDMode.indeterminate
                                                loadingNotification.label.text = "جاري تحضير \(MyAppsModel.allApp[appID].appName!)..."
                                                self.installDirc(id: appID)
                                                
            })
            
            let resignAction = CFAlertAction(title: "تعديل وتكرار",
                                              style: .Default,
                                              alignment: .justified,
                                              backgroundColor: UIColor(hex: "#1E76F3"),
                                              textColor: nil,
                                              handler: { (action) in
                                                self.setAppName(appID: appID)
            })
                
                
                
            
            let cancelAction = CFAlertAction(title: "اغلاق",
                                             style: .Cancel,
                                              alignment: .justified,
                                              backgroundColor: UIColor(hex: "#dddddd"),
                                              textColor: nil,
                                              handler: { (action) in
                                                print("Button with title '" + action.title! + "' tapped")
            })
            
            // Add Action Button Into Alert
            alertController.addAction(installAction)
            alertController.addAction(resignAction)
            alertController.addAction(cancelAction)

            // Present Alert View Controller
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setAppName(appID: Int){
        DispatchQueue.main.async {
           let appearance = SCLAlertView.SCLAppearance(
               kTitleFont: UIFont(name: "DINNextLTArabic-Medium", size: 20)!,
               kTextFont: UIFont(name: "DINNextLTArabic-Regular", size: 14)!,
               kButtonFont: UIFont(name: "DINNextLTArabic-Regular", size: 14)!,
               showCloseButton: true
           )
           // Add a text field
            let alert = SCLAlertView(appearance: appearance)
            let appName = alert.addTextField("اسم التطبيق (اختياري)")
            let appNumber = alert.addTextField("عدد نسخ التكرار, اعلى حد 5")
            alert.addButton("تكرار") {
                
                if appNumber.text != nil && appNumber.text != ""
               {
                // MARK: - Prepare Url Install
                let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                loadingNotification.mode = MBProgressHUDMode.indeterminate
                loadingNotification.label.text = "جاري تكرار وتوقيع التطبيق..."
                
                let appNameNew = appName.text == nil ? "" : appName.text
                HomeViewModel.bduplicationApp(appID: MyAppsModel.allApp[appID].appID!, appName: appNameNew!, appBundle: "", appNumber: appNumber.text!){
                    statusResign, resign in
                    self.hideAlert()
                    let appearanceins = SCLAlertView.SCLAppearance(
                        kTitleFont: UIFont(name: "DINNextLTArabic-Medium", size: 20)!,
                        kTextFont: UIFont(name: "DINNextLTArabic-Regular", size: 14)!,
                        kButtonFont: UIFont(name: "DINNextLTArabic-Regular", size: 14)!,
                        showCloseButton: true,
                        shouldAutoDismiss: false
                    )
                    let alertResign = SCLAlertView(appearance: appearanceins)
                    var numberApp = 0
                    for resignItem in HomeViewModel.urlResignApp {
                        numberApp += 1
                        alertResign.addButton("تحميل النسحة رقم \(numberApp)"){
                            let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
                            guard let url = URL(string: Config.installAppUrl + "resign/" + "\(UserDefaults.standard.getUserUDID())/" + "\(encryptedUDID)/" + "\(resignItem)") else {
                                 return
                            }
                            if UIApplication.shared.canOpenURL(url) {
                                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    }
                    alertResign.showSuccess("تم توقيع \(appNameNew!)", subTitle: "الرجاء تحميل جميع النسخ لانه سيتم حذفه بعد نصف ساعة", closeButtonTitle: "اغلاق")
                    
                }
               }else{
                self.serverMessage(status: false, message: "الرجاء تحديد عدد النسخ التكرار")
               }
           }
            alert.showCustom("تعديل وتكرار التطبيق", subTitle: "يمكنك تعديل اسم التطبيق ومعرف التطبيق وتكرار التطبيق.", color: UIColor(hex: "#32385C"), icon: UIImage(named: "resignOutAppIcon")!, closeButtonTitle: "اغلاق")
       }
    }

    func installDirc(id appID: Int) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        guard let url = URL(string: Config.installAppUrl + "\(MyAppsModel.allApp[appID].appID!)/" + "\(UserDefaults.standard.getUserUDID())/" + "\(encryptedUDID)") else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        hideAlert()
    }


}

