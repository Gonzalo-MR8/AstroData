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
    @IBOutlet weak var stackViewCopyright: UIStackView!
    @IBOutlet weak var viewBottomDecorative: View!
    
    private let kImageViewWidth: CGFloat = 0.9
    
    private var apod: APOD!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func adjustImageView(frameWidth: CGFloat) {
        let ratio = imageViewApod.image!.size.width / imageViewApod.image!.size.height
        let scaledHeight = (frameWidth * kImageViewWidth) / ratio
        
        imageViewHeight.constant = scaledHeight
        
        self.layoutIfNeeded()
    }
    
    func configure(image: UIImage, apod: APOD, frameWidth: CGFloat) {
        self.apod = apod
        
        imageViewApod.image = image
    
        adjustImageView(frameWidth: frameWidth)
        
        if let copyright = apod.copyright {
            labelCopyright.text = copyright
            stackViewCopyright.isHidden = false
            viewBottomDecorative.isHidden = false
        } else {
            stackViewCopyright.isHidden = true
            viewBottomDecorative.isHidden = true
        }
    }
    
    @IBAction func imageViewPressed(_ sender: Any) {
        let galleryVC = ImagesGalleryViewController.initAndLoad(imagesUrl: [apod.thumbUrl], position: 0)
        CustomNavigationController.instance.present(to: galleryVC, animated: true)
    }
}
