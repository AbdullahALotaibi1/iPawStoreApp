//
//  MyAppsView.swift
//  iPawStore
//
//  Created by Abdullah on 27/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class MyAppsView: UIViewController {

    // MARK: - Variables
    let appsData:[App] = [App(appName: "whatsapp", appIcon: UIImage(named: "whatsapp")!),
                          App(appName: "twiter", appIcon: UIImage(named: "twiter")!),
                          App(appName: "youtube", appIcon: UIImage(named: "youtube")!)]
    var filteredData:[App]?
    @IBOutlet weak var navigationHeaderOutLet: UIView! { didSet{ navigationHeaderOutLet.roundCorners([.bottomLeft, .bottomRight], radius: 42) } }
    @IBOutlet weak var tableViewOutLet: UITableView!
    @IBOutlet weak var searchBarOutLet: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredData = appsData
        setupTableView()
        setupSearchBar()
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
        listAppCell.update(cell: filteredData![indexPath.row])

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
    
}


//MARK: - Search Bar

extension MyAppsView: UISearchBarDelegate {
    
    func setupSearchBar() {
        searchBarOutLet.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredData = []
        if searchText == "" {
            filteredData = appsData
        }else{
            for app in appsData {
                if app.appName.lowercased().contains(searchText.lowercased()){
                    filteredData?.append(app)
                }
            }
        }
        
        self.tableViewOutLet.reloadData()
    }
}
