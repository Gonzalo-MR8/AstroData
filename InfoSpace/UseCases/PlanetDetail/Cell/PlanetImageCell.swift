//
//  PlanetImageCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/6/22.
//

import UIKit

class PlanetImageCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: CIImageView!

    public func configure(stringUrl: String) {
        imageView.setImage(with: stringUrl)
    }
}
