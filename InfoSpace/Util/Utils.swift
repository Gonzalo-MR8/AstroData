//
//  Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 26/6/22.
//

import UIKit

final class Utils: NSObject {
    
    static func downloadUIImage(with imageUrlString: String?, completion: ((UIImage?) -> Void)?) {
        ImageDownloader.shared.downloadImage(with: imageUrlString) { image in
            DispatchQueue.main.async {
                completion?(image)
            }
        }
    }
    
    static func adjustImageViewScaledHeight(frameWidth: CGFloat, imageView: UIImageView, imageViewPercentageWidth: CGFloat = 0.9) -> CGFloat {
        guard let image = imageView.image else { return 200 }

        let ratio = image.size.width / image.size.height
        let scaledHeight = (frameWidth * imageViewPercentageWidth) / ratio
        return scaledHeight
    }
    
    static func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }

    // MARK: - Methods to save images into photo album
    static func writeToPhotoAlbum(urlString: String?) {
        downloadUIImage(with: urlString) { result in
            if let image = result {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
            } else {
                CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "IMAGE_SAVER_SAVE_ERROR".localized)
            }
        }
    }

    @objc private static func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "IMAGE_SAVER_PERMISSIONS_ERROR".localized)
        } else {
            CustomNavigationController.instance.presentDefaultInfoAlert(title: "IMAGE_SAVER_DOWNLOAD_FINISH_TITLE".localized, message: "IMAGE_SAVER_DOWNLOAD_FINISH_TEXT".localized)
        }
    }
}
