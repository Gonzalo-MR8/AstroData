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
                CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "No se puede guardar la imagen")
            }
        }
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            CustomNavigationController.instance.presentDefaultAlert(title: "Error", message: "Compruebe que la app tiene los permisos para descargar imagenes en ajustes")
        } else {
            CustomNavigationController.instance.presentDefaultAlert(title: "Enhorabuena", message: "Imagen guardada satisfactoriamente en la galeria")
        }
    }
}
