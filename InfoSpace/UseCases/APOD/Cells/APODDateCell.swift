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
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }

            if state {
                strongSelf.lastSelectedDate = strongSelf.datePicker.date
            } else {
                strongSelf.datePicker.date = strongSelf.lastSelectedDate
            }
        }
    }
    
    @IBAction func datePickerEditingEnd(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.kShortDateFormat
        
        let parameters = [AnalyticsConstantsParameters.kAnalyticsParamNameDate: dateFormatter.string(from: datePicker.date)]
        let event = AnalyticsEvent(name: AnalyticsConstantsEvents.kAnalyticsAPODChangeDate, parameters: parameters)
        AnalyticsManager.shared.send(event: event)

        changeDatePicker?(datePicker.date)
    }
}
