//
//  ReloadCollectionViewCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 9/11/22.
//

import UIKit
import Lottie

class ReloadCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var animationView: AnimationView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        animationView.loopMode = .loop
        animationView.play()
    }

}
