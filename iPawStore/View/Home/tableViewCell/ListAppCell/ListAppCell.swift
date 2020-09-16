//
//  ListAppCell.swift
//  iPawStore
//
//  Created by Abdullah on 27/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class ListAppCell: UITableViewCell {

    @IBOutlet weak var bgViewOutLet: UIView! { didSet{ bgViewOutLet.layer.cornerRadius = 17 } }
    @IBOutlet weak var buttonOptionOutLet: UIButton! { didSet{ buttonOptionOutLet.layer.cornerRadius = 13 } }
    @IBOutlet weak var appNameOutLet: UILabel!
    @IBOutlet weak var appVersionOutLet: UILabel!
    @IBOutlet weak var appDescOutLet: UILabel!
    @IBOutlet weak var appIconOutLet: UIImageView! { didSet{ appIconOutLet.layer.cornerRadius = 14 } }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print()
//        bgViewOutLet.backgroundColor = ()?.withAlphaComponent(0.40)
//        buttonOptionOutLet.layer.backgroundColor = appIconOutLet.image?.averageColor?.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(cell: App) {
        appNameOutLet.text = cell.appName
        appIconOutLet.image = cell.appIcon
        bgViewOutLet.backgroundColor = (appIconOutLet.image?.averageColor)?.withAlphaComponent(0.35)
        buttonOptionOutLet.layer.backgroundColor = appIconOutLet.image?.averageColor?.cgColor
    }
    
}
