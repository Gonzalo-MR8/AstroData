//
//  YearsFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/10/22.
//

import UIKit

protocol YearsFilterCellProtocol: AnyObject {
    func changeYearsSelected(yearStart: String?, yearEnd: String?)
}

class YearsFilterCell: UITableViewCell {

    @IBOutlet private weak var yearStartTextField: UITextField! {
        didSet {
            yearStartTextField.attributedPlaceholder = NSAttributedString(string: "FILTER_VIEW_YEAR_BEGIN".localized, attributes: [NSAttributedString.Key.foregroundColor: Colors.textSecondaryColor.value])
        }
    }
    
    @IBOutlet private weak var yearEndTextField: UITextField! {
        didSet {
            yearEndTextField.attributedPlaceholder = NSAttributedString(string: "FILTER_VIEW_YEAR_END".localized,                                                                       attributes: [NSAttributedString.Key.foregroundColor: Colors.textSecondaryColor.value])
        }
    }
    
    private var toolBar: UIToolbar!
    private let picker = UIPickerView()
    
    private let kToolbarHeight: CGFloat = 40
    private let kToolBarButtonsFontSize: CGFloat = 16
    private let kToolBarTitleFontSize: CGFloat = 24
    
    private let kCornerRadius: CGFloat = 16.0
    
    private let placeholderText = "FILTER_VIEW_ANYONE".localized
    
    var years: [String] = []
    private var lastRow = 0
    
    weak var delegate: YearsFilterCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        generateYears()
        createYearsPickers()
        
        yearStartTextField.text = Utils.shared.getCurrentYear().description
        picker.selectRow(lastRow, inComponent: 0, animated: false)
    }

    private func generateYears() {
        let lastYear = 1900
        
        for i in lastYear...Utils.shared.getCurrentYear() {
            years.append(String(i))
            lastRow += 1
        }
    }
    
    // MARK: - Year picker
    
    private func createYearsPickers() {
        let fontDataButtons = FontData(name: FontNames.kNotoSansJPRegular)
        let fontButtons = UIFont(name: fontDataButtons.name, size: kToolBarButtonsFontSize)!
        
        let fontDataTitle = FontData(name: FontNames.kSpaceRangerCond)
        let fontTitle = UIFont(name: fontDataTitle.name, size: kToolBarTitleFontSize)!
        
        // Tool bar
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: kToolbarHeight))
        
        toolBar.barTintColor = Colors.secondaryColor.value
        
        let buttonCancel = UIButton.init()
        buttonCancel.setTitle("CANCEL".localized, for: .normal)
        buttonCancel.setTitleColor(Colors.white.value, for: .normal)
        buttonCancel.addTarget(self, action: #selector(yearsPickerCancelPressed(_:)), for: .touchUpInside)
        buttonCancel.titleLabel?.font = fontButtons
        
        let buttonToolBarCancel = UIBarButtonItem(customView: buttonCancel)
        
        let buttonAccept = UIButton.init()
        buttonAccept.setTitle("ACCEPT".localized, for: .normal)
        buttonAccept.setTitleColor(Colors.white.value, for: .normal)
        buttonAccept.addTarget(self, action: #selector(yearsPickerAcceptPressed(_:)), for: .touchUpInside)
        buttonAccept.titleLabel?.font = fontButtons
        
        let buttonToolBarAccept = UIBarButtonItem(customView: buttonAccept)
        
        let labelText = UILabel()
        labelText.textAlignment = .center
        labelText.text = "FILTER_VIEW_YEARS_FILTER".localized
        labelText.textColor = Colors.white.value
        labelText.font = fontTitle
        
        let labelToolBarText = UIBarButtonItem(customView: labelText)
        
        toolBar.items = [
            buttonToolBarCancel,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            labelToolBarText,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            buttonToolBarAccept
        ]
        
        // Years picker
        picker.dataSource = self
        picker.delegate = self
        picker.backgroundColor = Colors.white.value
        
        yearStartTextField.tintColor = .clear
        
        yearStartTextField.inputAccessoryView = toolBar
        yearStartTextField.inputAssistantItem.leadingBarButtonGroups = []
        yearStartTextField.inputAssistantItem.trailingBarButtonGroups = []
        
        yearStartTextField.inputView = picker
        
        yearEndTextField.tintColor = .clear
        
        yearEndTextField.inputAccessoryView = toolBar
        yearEndTextField.inputAssistantItem.leadingBarButtonGroups = []
        yearEndTextField.inputAssistantItem.trailingBarButtonGroups = []
        
        yearEndTextField.inputView = picker
    }
    
    @objc private func yearsPickerCancelPressed(_ sender: Any) {
        yearStartTextField.resignFirstResponder()
        yearEndTextField.resignFirstResponder()
    }

    @objc private func yearsPickerAcceptPressed(_ sender: Any) {
        let rowStart = picker.selectedRow(inComponent: 0)
        let yearStart = rowStart == 0 ? nil : years[rowStart - 1]
        
        let rowEnd = picker.selectedRow(inComponent: 1)
        let yearEnd = rowEnd == 0 ? nil : years[rowEnd - 1]
        
        if rowStart > rowEnd, rowEnd != 0 {
            CustomNavigationController.instance.presentDefaultAlert(title: "ERROR".localized, message: "FILTER_VIEW_SELECT_YEAR_ERROR".localized)
        } else {
            yearStartTextField.text = rowStart == 0 ? nil : yearStart!
            yearEndTextField.text = rowEnd == 0 ? nil : yearEnd!
            
            delegate?.changeYearsSelected(yearStart: yearStart, yearEnd: yearEnd)
        }
        
        yearStartTextField.resignFirstResponder()
        yearEndTextField.resignFirstResponder()
    }
    
    func reset() {
        yearStartTextField.text = Utils.shared.getCurrentYear().description
        yearEndTextField.text = nil
        picker.selectRow(lastRow, inComponent: 0, animated: false)
        picker.selectRow(0, inComponent: 1, animated: false)
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension YearsFilterCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let yearName = row == 0 ? placeholderText : years[row - 1]
        
        return NSAttributedString(string: yearName, attributes: [NSAttributedString.Key.foregroundColor: Colors.secondaryColor.value])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count + 1
    }
}
