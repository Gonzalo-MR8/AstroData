//
//  UITableViewCell+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 25/6/22.
//

import UIKit

extension UITableViewCell {
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
    
    static var identifier: String {
        return String.init(describing: self)
    }
}
