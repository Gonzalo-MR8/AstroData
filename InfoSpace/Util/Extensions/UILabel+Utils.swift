//
//  UILabel+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/1/23.
//

import UIKit

protocol XIBLocalizable {
    var xibLocKey: String? { get set }
}

extension UILabel: XIBLocalizable {
    @IBInspectable var xibLocKey: String? {
        get { return nil }
        set(key) {
            text = key?.localized
        }
    }
    
    @IBInspectable var uppercased: Bool {
        get { return false }
        set(flag) {
            if flag {
                text = text?.uppercased()
            }
        }
    }
}
