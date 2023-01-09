//
//  UIButton+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/1/23.
//

import UIKit

extension UIButton: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            setTitle(key?.localized, for: self.state)
        }
    }
}
