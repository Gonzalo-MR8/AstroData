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
    
    @IBOutlet private weak var searchTextField: UITextField! {
        didSet {
            searchTextField.attributedPlaceholder = NSAttributedString(string: "FILTER_VIEW_SEARCH".localized, attributes: [NSAttributedString.Key.foregroundColor: Colors.textSecondaryColor.value])
            searchTextField.layer.borderColor = Colors.textSecondaryColor.value.cgColor
            searchTextField.layer.cornerRadius = 8
            searchTextField.layer.borderWidth = 1
        }
    }
    
    weak var delegate: SearchFilterCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchTextField.delegate = self
    }
    
    func reset() {
        searchTextField.text = nil
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        delegate?.searchTextChanged(text: searchTextField.text)
    }
}

extension SearchFilterCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
}
