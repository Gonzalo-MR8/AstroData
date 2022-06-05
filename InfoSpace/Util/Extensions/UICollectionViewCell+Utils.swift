//
//  UICollectionViewCell+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import UIKit

extension UICollectionViewCell {
    static var nib: UINib {
        return UINib.init(nibName: String.init(describing: self), bundle: nil)
    }
    
    static var identifier: String {
        return String.init(describing: self)
    }
}
