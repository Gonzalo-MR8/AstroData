//
//  PlanetImageCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 8/6/22.
//

import UIKit

class PlanetImageCell: UICollectionViewCell {

    @IBOutlet weak var imageView: ImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configure(stringUrl: String) {
        imageView.setImage(with: stringUrl)
    }
}
