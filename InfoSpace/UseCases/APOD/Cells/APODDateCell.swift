//
//  APODDateCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODDateCell: UITableViewCell {

    @IBOutlet private weak var datePicker: UIDatePicker!
    
    var changeDatePicker: ((Date) -> Void)?
    
    var lastSelectedDate: Date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.maximumDate = Date()
    }
    
    func updateSelectedDate(state: Bool) {
        DispatchQueue.main.async { [self] in
            if state {
                lastSelectedDate = datePicker.date
            } else {
                datePicker.date = lastSelectedDate
            }
        }
    }
    
    @IBAction func datePickerEditingEnd(_ sender: Any) {
        changeDatePicker?(datePicker.date)
    }
}
