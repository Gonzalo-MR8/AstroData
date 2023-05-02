//
//  PlanetCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import UIKit

class PlanetCell: UICollectionViewCell {

    private let kScaleMultiplier: CGFloat = 1.1
    private let kAnimationDuration: TimeInterval = 0.2
    
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelDescription: UILabel!
    @IBOutlet private weak var labelSatelites: UILabel!
    @IBOutlet private weak var imageViewPlanet: UIImageView!

    func configure(planet: Planet) {
        labelTitle.text = planet.title
        labelDescription.text = planet.description
        labelSatelites.text = String(planet.satellites ?? 0)
        imageViewPlanet.setImage(with: planet.headerImageUrl)
    }
    
    func transformToLarge() {
        UIView.animate(withDuration: kAnimationDuration) { [weak self] in
            guard let self else { return }

            transform = CGAffineTransform(scaleX: kScaleMultiplier, y: kScaleMultiplier)
        }
    }
    
    func transformToStandard() {
        UIView.animate(withDuration: kAnimationDuration) {
            self.transform = CGAffineTransform.identity
        }
    }
}
