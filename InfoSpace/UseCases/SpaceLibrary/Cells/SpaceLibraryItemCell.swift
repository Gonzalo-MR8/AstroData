//
//  SpaceLibraryItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/11/22.
//

import UIKit

class SpaceLibraryItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: CIImageView!
    @IBOutlet private weak var audioView: CIView!
    @IBOutlet private weak var videoView: CIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private let kBorderWidth: CGFloat = 1
    
    public func configure(spaceItem: SpaceItem) {
        guard let mediaType = spaceItem.spaceItemsdatas.first?.mediaType else { return }
        
        imageView.setImage(with: spaceItem.links?.first?.href) { [weak self] _ in
            guard let self else { return }
            
            if mediaType == .audio, imageView.image == UIImage(named: "placeholderIcon") {
                imageView.borderWidth = kBorderWidth
                imageView.borderColor = Colors.secondaryColor.value
            } else {
                imageView.borderWidth = 0
                imageView.borderColor = UIColor.clear
            }
        }
        
        switch mediaType {
        case .image:
            audioView.isHidden = true
            videoView.isHidden = true
            titleLabel.isHidden = true
        case .video:
            audioView.isHidden = true
            videoView.isHidden = false
            titleLabel.isHidden = true
        case .audio:
            videoView.isHidden = true
            audioView.isHidden = false
            titleLabel.isHidden = false
            titleLabel.text = spaceItem.spaceItemsdatas.first?.title
        }
    }

}
