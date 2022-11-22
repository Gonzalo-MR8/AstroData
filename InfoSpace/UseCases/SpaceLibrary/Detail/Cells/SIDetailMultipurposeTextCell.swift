//
//  SIDetailMultipurposeTextCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/11/22.
//

import UIKit

class SIDetailMultipurposeTextCell: UITableViewCell {
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelText: UILabel!
    
    func configure(title: String, text: String) {
        labelTitle.text = title
        labelText.text = text
    }
}
