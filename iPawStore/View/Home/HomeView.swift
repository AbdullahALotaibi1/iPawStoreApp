//
//  HomeView.swift
//  iPawStore
//
//  Created by Abdullah on 26/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit
import CFAlertViewController
import MBProgressHUD
import RLBAlertsPickers
import SCLAlertView

class HomeView: UIViewController {
    
    // MARK: - OutLet Variables
    @IBOutlet weak var titleMessage: UILabel! { didSet{ titleMessage.text = " اهلاً بك في \(Config.title) ✨" }}
    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    @IBOutlet weak var WelcomeMessageOutLet: UIView! { didSet{ WelcomeMessageOutLet.layer.cornerRadius = 17 } }
    @IBOutlet weak var tableViewOutLet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Config.title
        loadingAlert()
        setupTableView()
        HomeViewModel.geLastAddedApps(){ statusLogin, message in
           
            if statusLogin == true {
                
                HomeViewModel.getRandomApps(){ statusLogin, message in
                   
                    if statusLogin == true {
                        self.hideAlert()
                        self.tableViewOutLet.reloadData()
                    }else{
                        self.hideAlert()
                        self.serverMessage(status: statusLogin!, message: message!)
                    }
                }
                
            }else{
                self.hideAlert()
                self.serverMessage(status: statusLogin!, message: message!)
            }
        }
    }
}


// MARK: - Table View
extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Setup Table View
    func setupTableView(){
        tableViewOutLet.delegate = self
        tableViewOutLet.dataSource = self
        registerNibs()
    }
    
    // MARK: - Register All Nibs
    func registerNibs() {
        self.tableViewOutLet.register(UINib(nibName: "ButtonResignOutAppCell", bundle: nil), forCellReuseIdentifier: "ButtonResignOutAppCell")
        self.tableViewOutLet.register(UINib(nibName: "LastAddedAppsCell", bundle: nil), forCellReuseIdentifier: "LastAddedAppsCell")
        self.tableViewOutLet.register(UINib(nibName: "HeaderOfRandomAppsCell", bundle: nil), forCellReuseIdentifier: "HeaderOfRandomAppsCell")
        self.tableViewOutLet.register(UINib(nibName: "ListAppCell", bundle: nil), forCellReuseIdentifier: "ListAppCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 + HomeViewModel.randomApp.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let buttonResignOutAppCell = tableView.dequeueReusableCell(withIdentifier: "ButtonResignOutAppCell", for: indexPath) as! ButtonResignOutAppCell
            return buttonResignOutAppCell
        }
        
        if indexPath.row == 1 {
            let lastAddedAppsCell = tableView.dequeueReusableCell(withIdentifier: "LastAddedAppsCell", for: indexPath) as! LastAddedAppsCell
            lastAddedAppsCell.collectionViewOutLet.delegate = self
            lastAddedAppsCell.collectionViewOutLet.dataSource = self
            lastAddedAppsCell.collectionViewOutLet.reloadData()
            return lastAddedAppsCell
        }
        
        if indexPath.row == 2 {
                   let headerOfRandomAppsCell = tableView.dequeueReusableCell(withIdentifier: "HeaderOfRandomAppsCell", for: indexPath) as! HeaderOfRandomAppsCell
                   return headerOfRandomAppsCell
        }
        
        
        let listAppCell = tableView.dequeueReusableCell(withIdentifier: "ListAppCell", for: indexPath) as! ListAppCell
        listAppCell.update(app: HomeViewModel.randomApp[indexPath.row - 3])
        return listAppCell
       
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.5, delay: 0.01 * Double(indexPath.row), animations: {
            cell.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 113
        }
        if indexPath.row == 1{
            return 160
        }
        
        if indexPath.row == 2{
            return 30
        }
        
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            downloadFromUrl()
        }
        if indexPath.row >= 3 {
            alertInstallApp(id: indexPath.row - 3)
        }
    }
}


// MARK: - Table View
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeViewModel.lastAddedApp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lastAddedAppsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastAddedAppsCollectionCell", for: indexPath) as! LastAddedAppsCollectionCell
        lastAddedAppsCollectionCell.update(app: HomeViewModel.lastAddedApp[indexPath.row])
        return lastAddedAppsCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 94, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        alertInstallAppCollectionView(id: indexPath.row)
    }
    
}


// MARK: - Function Install + Resign Apps
extension HomeView {
    
    func alertInstallApp(id appID: Int){
            DispatchQueue.main.async {
            // Create Alet View Controller
                let alertController = CFAlertViewController(title: HomeViewModel.randomApp[appID].appName,
                                                        message: "يمكن تثبيت تطبيق \(HomeViewModel.randomApp[appID].appName!) مباشرة او تعديل اسم التطبيق او تعديل بندل التطبيق وتكرار التطبيق لاكثر من نسخة.",
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
                                                loadingNotification.label.text = "جاري تحضير \(HomeViewModel.randomApp[appID].appName!)..."
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
    
    func alertInstallAppCollectionView(id appID: Int){
            DispatchQueue.main.async {
            // Create Alet View Controller
                let alertController = CFAlertViewController(title: HomeViewModel.lastAddedApp[appID].appName,
                                                        message: "يمكن تثبيت تطبيق \(HomeViewModel.lastAddedApp[appID].appName!) مباشرة او تعديل اسم التطبيق او تعديل بندل التطبيق وتكرار التطبيق لاكثر من نسخة.",
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
                                                loadingNotification.label.text = "جاري تحضير \(HomeViewModel.lastAddedApp[appID].appName!)..."
                                                self.installDircCollectionView(id: appID)
                                                
            })
            
            let resignAction = CFAlertAction(title: "تعديل وتكرار",
                                              style: .Default,
                                              alignment: .justified,
                                              backgroundColor: UIColor(hex: "#1E76F3"),
                                              textColor: nil,
                                              handler: { (action) in
                                                self.setAppNameCollectionView(appID: appID)
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
                HomeViewModel.bduplicationApp(appID: HomeViewModel.randomApp[appID].appID!, appName: appNameNew!, appBundle: "", appNumber: appNumber.text!){
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
    
    
    func setAppNameCollectionView(appID: Int){
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
                HomeViewModel.bduplicationApp(appID: HomeViewModel.lastAddedApp[appID].appID!, appName: appNameNew!, appBundle: "", appNumber: appNumber.text!){
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
  
    func downloadFromUrl(){
             DispatchQueue.main.async {
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "DINNextLTArabic-Medium", size: 20)!,
                    kTextFont: UIFont(name: "DINNextLTArabic-Regular", size: 14)!,
                    kButtonFont: UIFont(name: "DINNextLTArabic-Regular", size: 14)!,
                    showCloseButton: true
                )
                // Add a text field
                let alert = SCLAlertView(appearance: appearance)
                let txt = alert.addTextField("مثال: example.com/youtube.ipa")
                alert.addButton("تحميل") {
                    if txt.text != nil
                    {
                        // MARK: - Prepare Url Install
                        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                        loadingNotification.mode = MBProgressHUDMode.indeterminate
                        loadingNotification.label.text = "جاري تحميل وتوقيع التطبيق..."
                        
                        HomeViewModel.downloadFormUrl(ipaURL: txt.text!){
                            statusResign, resignURL in
                            if statusResign == true {
                                let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
                                print(Config.installAppUrl + "resign/" + "\(UserDefaults.standard.getUserUDID())/" + "\(encryptedUDID)/" + "\(resignURL!)")
                                guard let url = URL(string: Config.installAppUrl + "resign/" + "\(UserDefaults.standard.getUserUDID())/" + "\(encryptedUDID)/" + "\(resignURL!)") else {
                                     return
                                }
                                if UIApplication.shared.canOpenURL(url) {
                                     UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                }
                                self.hideAlert()
                            }
                        }

                    }
                }
                alert.showCustom("التحميل من خارج المتجر", subTitle: "قم بلصق او كتابة رابط التطبيق وعليك التاكد من صحة الرابط قبل تحميلة", color: UIColor(hex: "#32385C"), icon: UIImage(named: "resignOutAppIcon")!, closeButtonTitle: "اغلاق")
            }
    }
}


extension HomeView {
        
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

extension HomeView {
        
        func installDirc(id appID: Int) {
            let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
            guard let url = URL(string: Config.installAppUrl + "\(HomeViewModel.randomApp[appID].appID!)/" + "\(UserDefaults.standard.getUserUDID())/" + "\(encryptedUDID)") else {
                 return
            }
            if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            hideAlert()
        }
    
    func installDircCollectionView(id appID: Int) {
        let encryptedUDID = Cypto.getHash(UserDefaults.standard.getUserUDID())
        guard let url = URL(string: Config.installAppUrl + "\(HomeViewModel.lastAddedApp[appID].appID!)/" + "\(UserDefaults.standard.getUserUDID())/" + "\(encryptedUDID)") else {
             return
        }

        if UIApplication.shared.canOpenURL(url) {
             UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
        hideAlert()
    }
    

}
