//
//  UIImageView+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/5/22.
//

import UIKit

extension UIImageView {
    func setImage(with imageUrlString: String?, placeholderImage: UIImage? = UIImage(named: "placeholderIcon"), completion: ((UIImage?) -> Void)? = nil) {
        self.image = placeholderImage
        
        ImageDownloader.shared.downloadImage(with: imageUrlString, placeholderImage: placeholderImage) { image in
            self.image = image
            completion?(image)
        }
    }
    
    func createElipseToImage(containerView: UIView, size: CGSize, borderColor: CGColor) {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let image = renderer.image { renderImage in
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height).insetBy(dx: 8, dy: 8)
            
            renderImage.cgContext.setFillColor(UIColor.clear.cgColor)
            renderImage.cgContext.setStrokeColor(borderColor)
            renderImage.cgContext.setLineWidth(2)
            
            renderImage.cgContext.addEllipse(in: rectangle)
            renderImage.cgContext.drawPath(using: .fillStroke)
        }
        
        let imageView = UIImageView()
        imageView.image = image
        
        containerView.insertSubview(imageView, at: 0)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: -20).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20).isActive = true
    }
}

