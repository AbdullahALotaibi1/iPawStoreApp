//
//  LastAddedAppsCell.swift
//  iPawStore
//
//  Created by Abdullah on 26/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class LastAddedAppsCell: UITableViewCell {

    @IBOutlet weak var collectionViewOutLet: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
        registerNibs()
    }

    
   // MARK: - Register All Nibs
   func registerNibs() {
    self.collectionViewOutLet.register(UINib(nibName: "LastAddedAppsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "LastAddedAppsCollectionCell")
   }
       
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
