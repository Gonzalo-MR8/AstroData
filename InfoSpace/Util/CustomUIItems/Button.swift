//
//  Button.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/6/22.
//

import UIKit

@IBDesignable
class Button: UIButton {
    
    private var gradientLayer: CAGradientLayer? = nil
    
    @IBInspectable
    var enabledBgColor: UIColor?
    
    @IBInspectable
    var disabledBgColor: UIColor?
    
    @IBInspectable
    var alphaDisabledBgColor: CGFloat = 1.0
    
    @IBInspectable
    var alphaBgColor: CGFloat = 1.0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable
    var alphaTintColor: CGFloat = 1.0 {
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
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var roundedCorners: Bool = false {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var gradientStartColor: UIColor = .clear {
        didSet {
            layoutSubviews()
        }
    }
    
    @IBInspectable var gradientEndColor: UIColor = .clear {
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
    
    override var isEnabled: Bool {
        didSet {
            guard oldValue != isEnabled else { return }
            
            if isEnabled {
                if let bgColor = enabledBgColor {
                    backgroundColor = bgColor
                }
            } else {
                if let bgColor = disabledBgColor {
                    backgroundColor = bgColor
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Border
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        
        if roundedCorners {
            layer.cornerRadius = frame.height / 2.0
        } else {
            // Corner radius
            layer.cornerRadius = cornerRadius
        }
        
        // Apply custom alpha only if bg color has not alpha already applied
        if let bgColor = backgroundColor, !bgColor.hasAlpha {
            let alpha = isEnabled ? alphaBgColor : alphaDisabledBgColor
            backgroundColor = backgroundColor?.withAlphaComponent(alpha)
        }
        
        // Apply custom tint alpha only if tint color has not alpha already applied
        if !tintColor.hasAlpha {
            tintColor = tintColor.withAlphaComponent(alphaTintColor)
        }
        
        // Shadow
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        
        // Gradient
        applyGradient()
    }
    
    private func applyGradient() {
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            layer.insertSublayer(gradientLayer!, at: 0)
        }
        
        gradientLayer!.cornerRadius = layer.cornerRadius
        gradientLayer!.frame = bounds
        gradientLayer!.colors = [gradientStartColor.cgColor, gradientEndColor.cgColor]
        
        let startPoint = CGPoint(x: 0.0, y: 0.5)
        let endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradientLayer!.startPoint = startPoint
        gradientLayer!.endPoint = endPoint
    }

}

