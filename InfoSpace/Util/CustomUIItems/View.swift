//
//  View.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import UIKit

@IBDesignable
class View: UIView {
    
    /// Tag id for the BorderGradientViewTag, so it can be retrieved later without keeping a reference to it, this number is built based on the position of each letter of "COVERVIEW" in the alphabet
    private let kBorderGradientViewTag = 31522518229523
    
    @IBInspectable
    var alphaBgColor: CGFloat = 1.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var roundedBorders: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var topRoundedBorders: Bool = false {
        didSet {
            layoutSubviews()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
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
    
    @IBInspectable var borderGradient: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var shadowColor: UIColor = .clear {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = .zero {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var gradientStartColor: UIColor = .clear {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var gradientMidColor: UIColor? {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = .clear {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var gradientHorizontal: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Corner radius
        if roundedBorders {
            layer.cornerRadius = bounds.size.height / 2.0
        } else {
            layer.cornerRadius = cornerRadius

            if topRoundedBorders {
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        }
        
        // Border
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        // Shadow
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
        // Apply custom alpha only if bg color has not alpha already applied
        if let bgColor = backgroundColor, !bgColor.hasAlpha {
            backgroundColor = backgroundColor?.withAlphaComponent(alphaBgColor)
        }

        // Gradient
        let gradientLayer = layer as! CAGradientLayer
        
        // If transparent colors, replaced with white transparent to avoid undesirable effects
        let startColor = gradientStartColor.isTransparent ? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0) : gradientStartColor
        let endColor = gradientEndColor.isTransparent ? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0) : gradientEndColor
        
        var colors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        
        if let gradientMidColor = gradientMidColor {
            let midColor = gradientMidColor.isTransparent ? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0) : gradientMidColor
            colors.insert(midColor.cgColor, at: 1)
        }
        
        gradientLayer.colors = colors
        
        let startPoint = gradientHorizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0.0)
        let endPoint = gradientHorizontal ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1.0)
        
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint

        // BorderGradient
        createBorderGradient()
    }

    private func createBorderGradient() {
        guard borderGradient else {
            self.subviews.forEach { subview in
                if subview.tag == kBorderGradientViewTag {
                    subview.removeFromSuperview()
                }
            }

            return
        }

        let coverView = View()

        coverView.tag = kBorderGradientViewTag

        coverView.backgroundColor = backgroundColor
        coverView.alphaBgColor = alphaBgColor
        coverView.roundedBorders = roundedBorders
        coverView.cornerRadius = cornerRadius
        coverView.topRoundedBorders = topRoundedBorders

        coverView.widthAnchor.constraint(equalToConstant: self.frame.width - borderWidth).isActive = true
        coverView.heightAnchor.constraint(equalToConstant: self.frame.height - borderWidth).isActive = true

        self.insertSubview(coverView, at: 0)

        coverView.translatesAutoresizingMaskIntoConstraints = false
        coverView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        coverView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
