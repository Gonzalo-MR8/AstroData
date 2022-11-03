//
//  ButtonsFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 3/11/22.
//

import UIKit

protocol ButtonsFilterCellProtocol: AnyObject {
    func applyButtonPressed()
    func resetButtonPressed()
}

class ButtonsFilterCell: UITableViewCell {
    
    weak var delegate: ButtonsFilterCellProtocol?
    
    @IBAction func applyButtonPressed(_ sender: Any) {
        delegate?.applyButtonPressed()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        delegate?.resetButtonPressed()
    }
}
