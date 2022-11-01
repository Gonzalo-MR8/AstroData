//
//  YearsFilterCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 30/10/22.
//

import UIKit

class YearsFilterCell: UITableViewCell {

    @IBOutlet weak var yearStartTextField: UITextField!
    @IBOutlet weak var yearEndTextField: UITextField!
    
    private var toolBar: UIToolbar!
    private let picker = UIPickerView()
    
    private let kToolbarHeight: CGFloat = 40
    private let kToolBarFontSize: CGFloat = 14
    
    private let kCornerRadius: CGFloat = 16.0
    
    private let placeholderText = "Ninguno"
    private let placeholderYearStartText = "Año de inicio"
    private let placeholderYearEndText = "Año de fin"
    
    var years: [String] = ["1920", "1920","1920","1920","1920","1920","1920","1920","1920","1920","1920","1920","1920","1920"]
    
    func configure() {
        createYearsPickers()
    }
    
    // MARK: - Year picker
    
    private func createYearsPickers() {
        //let fontData = Fonts.dictFonts[FontTypes.kBodyRegular]!
        //let font = UIFont(name: fontData.name, size: kCountryToolBarFontSize)!
        
        // Tool bar
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: bounds.width, height: kToolbarHeight))
        
        toolBar.barTintColor = Colors.tertiaryColor.value
        
        let buttonCancel = UIButton.init()
        buttonCancel.setTitle("Cancelar", for: .normal)
        buttonCancel.setTitleColor(Colors.white.value, for: .normal)
        buttonCancel.addTarget(self, action: #selector(yearsPickerCancelPressed(_:)), for: .touchUpInside)
        //buttonCancel.titleLabel?.font = font
        
        let buttonToolBarCancel = UIBarButtonItem(customView: buttonCancel)
        
        let buttonAccept = UIButton.init()
        buttonAccept.setTitle("Aceptar", for: .normal)
        buttonAccept.setTitleColor(Colors.white.value, for: .normal)
        buttonAccept.addTarget(self, action: #selector(yearsPickerAcceptPressed(_:)), for: .touchUpInside)
        //buttonAccept.titleLabel?.font = font
        
        let buttonToolBarAccept = UIBarButtonItem(customView: buttonAccept)
        
        let labelText = UILabel()
        labelText.textAlignment = .center
        labelText.text = "Filtro de años"
        labelText.textColor = Colors.white.value
        //labelText.font = font
        
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
        
        yearStartTextField.text = rowStart == 0 ? nil : yearStart!
        
        let rowEnd = picker.selectedRow(inComponent: 1)
        let yearEnd = rowEnd == 0 ? nil : years[rowEnd - 1]
        
        //changeCenter?(center)
        yearEndTextField.text = rowEnd == 0 ? nil : yearEnd!
        
        yearStartTextField.resignFirstResponder()
        yearEndTextField.resignFirstResponder()
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension YearsFilterCell: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let yearName = row == 0 ? placeholderText : years[row - 1]
        
        return NSAttributedString(string: yearName, attributes: [NSAttributedString.Key.foregroundColor: Colors.tertiaryColor.value])
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count + 1
    }
}
