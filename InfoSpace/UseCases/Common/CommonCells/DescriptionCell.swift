//
//  DescriptionCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/11/22.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!
    
    func configure(description: String) {
        labelDescription.text = description
    }
    
}
