//
//  SpaceLibraryItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/11/22.
//

import UIKit

class SpaceLibraryItemCell: UICollectionViewCell {
    
    @IBOutlet private weak var imageView: ImageView!
    @IBOutlet private weak var audioView: View!
    @IBOutlet private weak var videoView: View!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private let kBorderWidth: CGFloat = 1
    
    public func configure(spaceItem: SpaceItem) {
        let mediaType = spaceItem.spaceItemsdatas.first!.mediaType
        
        imageView.setImage(with: spaceItem.links?.first?.href) { [weak self] _ in
            guard let strongSelf = self else { return }
            
            if mediaType == .audio, strongSelf.imageView.image == UIImage(named: "placeholderIcon") {
                strongSelf.imageView.borderWidth = strongSelf.kBorderWidth
                strongSelf.imageView.borderColor = Colors.secondaryColor.value
            } else {
                strongSelf.imageView.borderWidth = 0
                strongSelf.imageView.borderColor = UIColor.clear
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
