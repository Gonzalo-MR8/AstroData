//
//  SpaceLibraryItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 1/11/22.
//

import UIKit

class SpaceLibraryItemCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func configure(spaceItem: SpaceItem) {
        if let itemLink = spaceItem.links?.first {
            imageView.setImage(with: itemLink.href)
        }
    }

}
