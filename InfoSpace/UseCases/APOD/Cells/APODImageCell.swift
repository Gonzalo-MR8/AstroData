//
//  APODImageCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODImageCell: UITableViewCell {

    @IBOutlet weak var imageViewApod: ImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet weak var labelCopyright: UILabel!
    @IBOutlet weak var labelCopyrightAutor: UILabel!
    @IBOutlet weak var stackViewCopyright: UIStackView!
    
    private var apod: APOD!
    
    func configure(image: UIImage, apod: APOD, frameWidth: CGFloat) {
        self.apod = apod
        
        imageViewApod.image = image

        imageViewHeight.constant = Utils.shared.adjustImageViewScaledHeight(frameWidth: frameWidth, imageView: imageViewApod)
        self.layoutIfNeeded()
        
        if let copyright = apod.copyright {
            labelCopyright.text = "APOD_COPYRIGHT".localized
            labelCopyrightAutor.text = copyright
        } else {
            labelCopyright.text = "APOD_NO_COPYRIGHT".localized
            labelCopyrightAutor.text = ""
        }
    }
    
    @IBAction func imageViewPressed(_ sender: Any) {
        let galleryVC = ImagesGalleryViewController.initAndLoad(imagesUrl: [apod.thumbUrl], highDefinitionUrlImages: [apod.hdUrl ?? apod.thumbUrl], position: 0)
        CustomNavigationController.instance.navigate(to: galleryVC, animated: true)
    }
}
