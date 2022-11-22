//
//  SpaceLibraryItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/11/22.
//

import UIKit

class SpaceLibraryItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: ImageView!
    @IBOutlet weak var audioView: View!    
    @IBOutlet weak var videoView: View!
    
    func configure(spaceItem: SpaceItem) {
        if let itemLink = spaceItem.links.first {
            imageView.setImage(with: itemLink.href)
        }
        
        switch spaceItem.spaceItemdata.mediaType {
        case .image:
            audioView.isHidden = true
            videoView.isHidden = true
        case .video:
            audioView.isHidden = true
            videoView.isHidden = false
        case .audio:
            videoView.isHidden = true
            audioView.isHidden = false
        }
    }

}
