//
//  APODTitleCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODTitleCell: UITableViewCell {

    @IBOutlet weak var labelTitle: Label!
    
    func configure(title: String) {
        labelTitle.text = title
    }
}
