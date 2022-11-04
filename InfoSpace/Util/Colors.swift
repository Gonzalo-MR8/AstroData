//
//  Colors.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/6/22.
//

import UIKit

enum Colors: String {
    case black
    case white
    case white20
    case white15
    case white10
    
    case blueStar
    case brownStar
    
    case elementColor
    
    case primaryColor
    case secondaryColor
    case tertiaryColor
    
    case textColor
    case textSecondaryColor
    case titleColor
}

extension Colors {
    var value: UIColor {
        get {
            guard let color = UIColor.init(named: self.rawValue) else { return .clear }
            
            return color
        }
    }
}
