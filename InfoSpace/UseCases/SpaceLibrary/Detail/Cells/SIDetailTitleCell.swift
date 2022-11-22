//
//  SIDetailTitleCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 20/11/22.
//

import UIKit

class SIDetailTitleCell: UITableViewCell {

    @IBOutlet weak var labelTitle: Label!
    
    func configure(title: String) {
        labelTitle.text = title
    }
    
}
