//
//  TitleCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/11/22.
//

import UIKit

class TitleCell: UITableViewCell {

    @IBOutlet private weak var labelTitle: CILabel!
    
    func configure(title: String) {
        labelTitle.text = title
    }
    
}
