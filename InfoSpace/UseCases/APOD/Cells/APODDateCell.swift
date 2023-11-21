//
//  APODDateCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 21/6/22.
//

import UIKit

class APODDateCell: UITableViewCell {

    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var buttonPreviousDate: CIButton!
    @IBOutlet private weak var buttonNextDate: CIButton!

    var changeDatePicker: ((Date) -> Void)?
    
    var lastSelectedDate: Date = Date()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        datePicker.maximumDate = Date()
    }
    
    func updateSelectedDate(state: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if state {
                lastSelectedDate = datePicker.date
            } else {
                datePicker.date = lastSelectedDate
            }
        }
    }
    
    private func enableDisabledButtons(pickerDate: Date) {
        if pickerDate == Date() {
            buttonNextDate.gradientStartColor = Colors.tertiaryColor50.value
            buttonNextDate.gradientEndColor = Colors.primaryColor50.value
            buttonNextDate.isEnabled = false
        } else {
            buttonNextDate.gradientStartColor = Colors.tertiaryColor.value
            buttonNextDate.gradientEndColor = Colors.primaryColor.value
            buttonNextDate.isEnabled = true
        }

        if let minimunDate = datePicker.minimumDate, minimunDate == pickerDate {
            buttonPreviousDate.gradientStartColor = Colors.tertiaryColor50.value
            buttonPreviousDate.gradientEndColor = Colors.primaryColor50.value
            buttonPreviousDate.isEnabled = false
        } else {
            buttonPreviousDate.gradientStartColor = Colors.tertiaryColor.value
            buttonPreviousDate.gradientEndColor = Colors.primaryColor.value
            buttonPreviousDate.isEnabled = true
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

    @IBAction func buttonPreviousDatePressed(_ sender: Any) {
        let calendar = Calendar.current

        if let date = calendar.date(byAdding: .day, value: -1, to: datePicker.date) {
            enableDisabledButtons(pickerDate: date)
            changeDatePicker?(date)
            datePicker.setDate(date, animated: true)
        }
    }

    @IBAction func buttonNextDatePressed(_ sender: Any) {
        let calendar = Calendar.current

        if let date = calendar.date(byAdding: .day, value: 1, to: datePicker.date) {
            enableDisabledButtons(pickerDate: date)
            changeDatePicker?(date)
            datePicker.setDate(date, animated: true)
        }
    }
}
