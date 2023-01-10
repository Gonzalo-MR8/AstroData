//
//  DashboardItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import UIKit

class DashboardItemCell: UICollectionViewCell {

    @IBOutlet private weak var blur: UIVisualEffectView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    func configure(dashboardItem: DashboardItem) {
        labelTitle.text = dashboardItem.title
        imageView.image = UIImage(named: dashboardItem.assetImageName)
        blur.layer.cornerRadius = 12
        blur.clipsToBounds = true
    }
}
