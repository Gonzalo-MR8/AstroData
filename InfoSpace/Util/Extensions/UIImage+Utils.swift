//
//  UIImage+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 14/12/22.
//

import UIKit

extension UIImage {
    /// Extension funcs to use in Slider Thumb
    class func createThumbImage(size: CGFloat, color: UIColor) -> UIImage {
        let layerFrame = CGRectMake(0, 0, size, size)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = CGPath(ellipseIn: layerFrame.insetBy(dx: 1, dy: 1), transform: nil)
        shapeLayer.fillColor = color.cgColor
        shapeLayer.strokeColor = color.withAlphaComponent(0.65).cgColor
        
        let layer = CALayer.init()
        layer.frame = layerFrame
        layer.addSublayer(shapeLayer)
        return self.imageFromLayer(layer: layer)
    }
    
    class func imageFromLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, UIScreen.main.scale)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return outputImage
    }
}
