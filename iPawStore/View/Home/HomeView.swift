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

class HomeView: UIViewController {
    
    // MARK: - OutLet Variables
    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    @IBOutlet weak var WelcomeMessageOutLet: UIView! { didSet{ WelcomeMessageOutLet.layer.cornerRadius = 17 } }
    @IBOutlet weak var tableViewOutLet: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
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
        return 28
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
            return lastAddedAppsCell
        }
        
        if indexPath.row == 2 {
                   let headerOfRandomAppsCell = tableView.dequeueReusableCell(withIdentifier: "HeaderOfRandomAppsCell", for: indexPath) as! HeaderOfRandomAppsCell
                   return headerOfRandomAppsCell
        }
        
        
        let listAppCell = tableView.dequeueReusableCell(withIdentifier: "ListAppCell", for: indexPath) as! ListAppCell
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
            alertInstallApp(id: 1)
            print(indexPath.row)
        }
    }
}


// MARK: - Table View
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let lastAddedAppsCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LastAddedAppsCollectionCell", for: indexPath) as! LastAddedAppsCollectionCell
        
        return lastAddedAppsCollectionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 94, height: 100)
    }
    
}


// MARK: - Function Install + Resign Apps
extension HomeView {
    
    func alertInstallApp(id appID: Int){
            DispatchQueue.main.async {
            // Create Alet View Controller
            let alertController = CFAlertViewController(title: "Youtube ++",
                                                        message: "يمكن تثبيت تطبيق (اسم التطبيق) مباشرة او تعديل اسم التطبيق او تعديل بندل التطبيق وتكرار التطبيق لاكثر من نسخة.",
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
                                                loadingNotification.label.text = "جاري تحضير (Youtube++)..."
            })
            
            let resignAction = CFAlertAction(title: "تعديل وتكرار",
                                              style: .Default,
                                              alignment: .justified,
                                              backgroundColor: UIColor(hex: "#1E76F3"),
                                              textColor: nil,
                                              handler: { (action) in
                                                self.setAppName()
                                                print("Button with title '" + action.title! + "' tapped")
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
    
    func setAppName(){
         DispatchQueue.main.async {
        let alert = UIAlertController(style: .actionSheet, title: "اسم التطبيق", message: "في حال تركت اسم التطبيق فارغ سيتم اخذ اسم التطبيق الافتراضي")
        let config: TextField.Config = { textField in
        textField.becomeFirstResponder()
        textField.textColor = .black
        textField.placeholder = "مثال: Youtube Test"
        textField.leftViewPadding = 12
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.backgroundColor = nil
        textField.keyboardAppearance = .default
        textField.keyboardType = .default
        textField.isSecureTextEntry = false
        textField.returnKeyType = .done
        textField.textAlignment = .right
        textField.action { textField in
            // validation and so on
            print(textField.text)
        }
    }
    alert.addOneTextField(configuration: config)
    alert.addAction(title: "OK", style: .cancel) {
        action in
        self.setAppBundle()
    }
    alert.show()
        }
    }
    
    func setAppBundle(){
         DispatchQueue.main.async {
        let alert = UIAlertController(style: .actionSheet, title: " بندل التطبيق", message: "في حال تركت بندل التطبيق فارغ سيتم اخذ بندل التطبيق الافتراضي وتعديلة بحيث لا يتعارض مع البندل الاصلي")
        let config: TextField.Config = { textField in
        textField.becomeFirstResponder()
        textField.textColor = .black
        textField.placeholder = "مثال: com.abduallah.iPawStore"
        textField.leftViewPadding = 12
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        textField.backgroundColor = nil
        textField.keyboardAppearance = .default
        textField.keyboardType = .default
        textField.isSecureTextEntry = false
        textField.returnKeyType = .done
        textField.textAlignment = .right
        textField.action { textField in
            // validation and so on
            print(textField.text)
        }
    }
    alert.addOneTextField(configuration: config)
    alert.addAction(title: "OK", style: .cancel) {
        action in
        self.setNumberOfRepet()
    }
    alert.show()
        }
    }
    
    func setNumberOfRepet() {
        let alert = UIAlertController(style: .actionSheet, title: "عدد نسخ التكرار")

        let frameSizes: [CGFloat] = (1...5).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: frameSizes.index(of: 216) ?? 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { vc, picker, index, values in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 1) {
//                    //
                    // MARK: - Prepare Url Install
                    let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                    loadingNotification.mode = MBProgressHUDMode.indeterminate
                    loadingNotification.label.text = "جاري توقيع (اسم التطبيق)..."
                }
            }
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
    
    func downloadFromUrl(){
             DispatchQueue.main.async {
                let alert = UIAlertController(style: .actionSheet, title: "التحميل من خارج المتجر", message: "قم بلصق او كتابة رابط التطبيق وعليك التاكد من صحة الرابط قبل تحميلة")
                let config: TextField.Config = { textField in
                textField.becomeFirstResponder()
                textField.textColor = .white
                textField.placeholder = "مثال: example.com/youtube.ipa"
                textField.leftViewPadding = 12
                textField.layer.borderWidth = 1
                textField.layer.cornerRadius = 8
                textField.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
                textField.backgroundColor = nil
                textField.keyboardAppearance = .default
                textField.keyboardType = .default
                textField.isSecureTextEntry = false
                textField.returnKeyType = .done
                textField.textAlignment = .right
                textField.action { textField in
                    // validation and so on
                    print(textField.text)
                }
            }
            alert.addOneTextField(configuration: config)
            alert.addAction(title: "OK", style: .cancel) {
                action in
                
                        // MARK: - Prepare Url Install
                        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
                        loadingNotification.mode = MBProgressHUDMode.indeterminate
                        loadingNotification.label.text = "جاري تحميل وتوقيع. وقد يستغرق بعض الوقت"

            }
            alert.show()
                }
    }
}
