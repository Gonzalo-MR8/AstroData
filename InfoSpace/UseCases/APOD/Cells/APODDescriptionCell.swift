//
//  APODDescriptionCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODDescriptionCell: UITableViewCell {

    @IBOutlet weak var labelDescription: UILabel!
    
    func configure(description: String) {
        labelDescription.text = description
    }
}
