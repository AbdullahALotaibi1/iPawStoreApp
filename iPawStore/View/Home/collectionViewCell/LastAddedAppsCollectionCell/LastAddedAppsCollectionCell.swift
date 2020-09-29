//
//  LastAddedAppsCollectionCell.swift
//  iPawStore
//
//  Created by Abdullah on 26/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit
import SDWebImage

class LastAddedAppsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var appIcon: UIImageView! { didSet { appIcon.layer.cornerRadius = 20 }}
    @IBOutlet weak var appName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func update(app: Application){
        let imgUrl = URL(string: Config.url + app.appIcon!)
        appIcon?.sd_setImage(with: imgUrl!, placeholderImage: UIImage(named: "ipawLogo"))
        appName.text = app.appName
    }
}
