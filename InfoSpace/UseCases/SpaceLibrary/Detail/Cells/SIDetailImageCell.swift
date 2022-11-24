//
//  SIDetailImageCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 20/11/22.
//

import UIKit

class SIDetailImageCell: UITableViewCell {

    @IBOutlet weak var itemImageView: ImageView!
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    private var link: ItemLink!
    
    func configure(image: UIImage, link: ItemLink?, frameWidth: CGFloat) {
        self.link = link

        itemImageView.image = image
        
        self.imageViewHeight.constant = Utils.shared.adjustImageViewScaledHeight(frameWidth: frameWidth, imageView: self.itemImageView)
        self.layoutIfNeeded()
    }
    
    @IBAction func imageViewPressed(_ sender: Any) {
        if let link = link {
            let galleryVC = ImagesGalleryViewController.initAndLoad(imagesUrl: [link.href], position: 0)
            CustomNavigationController.instance.present(to: galleryVC, animated: true)
        }
    }
    
}
