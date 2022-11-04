//
//  SearchFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 29/10/22.
//

import UIKit

protocol SearchFilterCellProtocol: AnyObject {
    func searchTextChanged(text: String?)
}

class SearchFilterCell: UITableViewCell {
    
    @IBOutlet private weak var searchTextField: UITextField!
    
    weak var delegate: SearchFilterCellProtocol?
    
    func reset() {
        searchTextField.text = nil
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        delegate?.searchTextChanged(text: searchTextField.text)
    }
}