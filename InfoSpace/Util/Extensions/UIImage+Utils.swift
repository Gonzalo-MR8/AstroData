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
    let layerFrame = CGRect(x: 0, y: 0, width: size, height: size)

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
    guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
    layer.render(in: context)
    guard let outputImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
    UIGraphicsEndImageContext()
    return outputImage
  }

  func imageWith(newSize: CGSize) -> UIImage {
    let renderer = UIGraphicsImageRenderer(size: newSize)
    let image = renderer.image { _ in
      self.draw(in: CGRect.init(origin: CGPoint.zero, size: newSize))
    }
    return image.withRenderingMode(self.renderingMode)
  }
}
