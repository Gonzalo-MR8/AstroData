//
//  Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/6/22.
//

import UIKit

final class Utils {

    static let shared = Utils()

    private init() {}

    func downloadUIImage(with imageUrlString: String?, completion: ((UIImage?) -> Void)?) {
        ImageDownloader.shared.downloadImage(with: imageUrlString) { image in
            DispatchQueue.main.async {
                completion?(image)
            }
        }
    }
    
    func adjustImageViewScaledHeight(frameWidth: CGFloat, imageView: UIImageView, imageViewPercentageWidth: CGFloat = 0.9) -> CGFloat {
        let ratio = imageView.image!.size.width / imageView.image!.size.height
        let scaledHeight = (frameWidth * imageViewPercentageWidth) / ratio
        return scaledHeight
    }
    
    func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }
}
