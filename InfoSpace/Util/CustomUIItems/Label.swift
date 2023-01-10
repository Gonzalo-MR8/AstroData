//
//  Label.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/7/22.
//

import UIKit

@IBDesignable
class Label: UILabel {
    
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
    
    private func getGradientLayer() -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        gradient.frame = self.bounds
        
        // If transparent colors, replaced with white transparent to avoid undesirable effects
        let startColor = gradientStartColor.isTransparent ? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0) : gradientStartColor
        let endColor = gradientEndColor.isTransparent ? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0) : gradientEndColor
        
        var colors: [CGColor] = [startColor.cgColor, endColor.cgColor]
        
        if let gradientMidColor = gradientMidColor {
            let midColor = gradientMidColor.isTransparent ? UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.0) : gradientMidColor
            colors.insert(midColor.cgColor, at: 1)
        }
        
        gradient.colors = colors
        
        let startPoint = gradientHorizontal ? CGPoint(x: 0.0, y: 0.5) : CGPoint(x: 0.5, y: 0.0)
        let endPoint = gradientHorizontal ? CGPoint(x: 1.0, y: 0.5) : CGPoint(x: 0.5, y: 1.0)
        
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        
        return gradient
    }
    
    private func gradientColor(bounds: CGRect, gradientLayer: CAGradientLayer) -> UIColor? {
        // Create UIImage by rendering gradient layer
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        gradientLayer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        // Get gradient UIcolor from gradient UIImage
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Gradient
        let gradient = getGradientLayer()
        self.textColor = gradientColor(bounds: self.bounds, gradientLayer: gradient)
    }
}

