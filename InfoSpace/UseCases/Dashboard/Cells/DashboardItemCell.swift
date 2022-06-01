//
//  DashboardItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import UIKit

class DashboardItemCell: UICollectionViewCell {

    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(dashboardItem: DashboardItem) {
        labelTitle.text = dashboardItem.title
        imageView.image = UIImage(named: dashboardItem.assetImageName)
        blur.layer.cornerRadius = 12
        blur.clipsToBounds = true
    }
}
