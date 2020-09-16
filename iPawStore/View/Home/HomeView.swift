//
//  HomeView.swift
//  iPawStore
//
//  Created by Abdullah on 26/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

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
