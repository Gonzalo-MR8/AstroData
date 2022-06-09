//
//  ImageView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/6/22.
//

import UIKit

class ImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var circularImageView: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if circularImageView {
            layer.cornerRadius = bounds.size.width / 2.0
        } else {
            // Corner radius
            layer.cornerRadius = cornerRadius
        }
        
        // Border
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
    }

}
