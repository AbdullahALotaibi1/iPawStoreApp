//
//  UIView.swift
//  iPawStore
//
//  Created by Abdullah on 26/01/1442 AH.
//  Copyright © 1442 Abdullah. All rights reserved.
//

import UIKit

extension UIView {
    
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
    
}
