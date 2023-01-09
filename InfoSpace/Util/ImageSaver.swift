//
//  ImageSaver.swift
//  InfoSpace
//
//  Created by GonzaloMR on 20/12/22.
//

import UIKit

class ImageSaver: NSObject {
    func writeToPhotoAlbum(urlString: String?) {
        Utils.shared.downloadUIImage(with: urlString) { [self] result in
            if let image = result {
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
            } else {
                CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "IMAGE_SAVER_SAVE_ERROR".localized)
            }
        }
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "IMAGE_SAVER_PERMISSIONS_ERROR".localized)
        } else {
            CustomNavigationController.instance.presentDefaultInfoAlert(title: "IMAGE_SAVER_DOWNLOAD_FINISH_TITLE".localized, message: "IMAGE_SAVER_DOWNLOAD_FINISH_TEXT".localized)
        }
    }
}
