//
//  ContentTypeItemCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/10/22.
//

import UIKit

class ContentTypeItemCell: UICollectionViewCell {

    @IBOutlet weak var itemView: View!
    @IBOutlet weak var textLabel: UILabel!
    
    let kSelectedBorderWidth: CGFloat = 0
    let kUnselectedBorderWidth: CGFloat = 2
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(text: String, isSelected: Bool) {
        textLabel.text = text
        
        switch isSelected {
        case true:
            itemView.borderWidth = kSelectedBorderWidth
            itemView.borderGradient = false
            textLabel.textColor = Colors.white.value
        case false:
            itemView.borderWidth = kUnselectedBorderWidth
            itemView.borderGradient = true
            textLabel.textColor = Colors.black.value
        }
    }
}
