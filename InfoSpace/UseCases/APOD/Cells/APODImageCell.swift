//
//  APODImageCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODImageCell: UITableViewCell {

    @IBOutlet private weak var imageViewApod: CIImageView!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var labelCopyright: UILabel!
    @IBOutlet private weak var labelCopyrightAutor: UILabel!
    @IBOutlet private weak var stackViewCopyright: UIStackView!
    
    private var apod: APOD!

    private let analyticsScreen: AnalyticsScreen = .apod

    func configure(image: UIImage, apod: APOD, frameWidth: CGFloat) {
        self.apod = apod
        
        imageViewApod.image = image

        imageViewHeight.constant = Utils.adjustImageViewScaledHeight(frameWidth: frameWidth, imageView: imageViewApod)
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
        AnalyticsManager.shared.send(event: analyticsScreen.imagesGalleryEnterAnalyticsEvent)
        let galleryVC = ImagesGalleryViewController.initAndLoad(imagesUrl: [apod.thumbUrl], highDefinitionUrlImages: [apod.hdUrl ?? apod.thumbUrl], position: 0)
        CustomNavigationController.instance.navigate(to: galleryVC, animated: true)
    }
}
