//
//  SIDetailImageCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 20/11/22.
//

import UIKit

class SIDetailImageCell: UITableViewCell {

    @IBOutlet private weak var itemImageView: CIImageView!
    @IBOutlet private weak var imageViewHeight: NSLayoutConstraint!
    
    private var link: ItemLink!
    private var highDefinitionUrlImage: String?

    private let analyticsScreen: AnalyticsScreen = .spaceLibraryDetail

    func configure(image: UIImage, link: ItemLink?, highDefinitionUrlImage: String?, frameWidth: CGFloat) {
        self.link = link
        self.highDefinitionUrlImage = highDefinitionUrlImage
        
        itemImageView.image = image
        
        self.imageViewHeight.constant = Utils.adjustImageViewScaledHeight(frameWidth: frameWidth, imageView: self.itemImageView)
        self.layoutIfNeeded()
    }
    
    @IBAction func imageViewPressed(_ sender: Any) {
        if let link = link {
            AnalyticsManager.shared.send(event: analyticsScreen.imagesGalleryEnterAnalyticsEvent)

            let galleryVC = ImagesGalleryViewController.initAndLoad(imagesUrl: [link.href], highDefinitionUrlImages: [highDefinitionUrlImage ?? link.href], position: 0)
            CustomNavigationController.instance.navigate(to: galleryVC, animated: true)
        }
    }
    
}
