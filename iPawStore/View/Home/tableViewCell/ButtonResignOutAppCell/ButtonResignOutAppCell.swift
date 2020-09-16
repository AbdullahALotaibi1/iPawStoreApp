//
//  ButtonResignOutAppCell.swift
//  iPawStore
//
//  Created by Abdullah on 26/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

class ButtonResignOutAppCell: UITableViewCell {

    @IBOutlet weak var BgViewOutLet: UIView! { didSet{ BgViewOutLet.layer.cornerRadius = 17 } }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
