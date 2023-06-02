//
//  AlertSimpleView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 5/5/23.
//

import UIKit

enum AlertSimpleType {
    case spaceLibrary
    case apod
    case search
}

class AlertSimpleView: CIView {

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var noShowAgainView: CIView!

    private var alertType: AlertSimpleType = .spaceLibrary

    func configure(alertType: AlertSimpleType) {
        setupNib()

        self.alertType = alertType
        noShowAgainView.isHidden = true

        switch alertType {
        case .spaceLibrary:
            textLabel.text = "SIMPLE_ALERT_TEXT_APOD_SL".localized
        case .apod:
            textLabel.text = "SIMPLE_ALERT_TEXT_APOD_SL".localized
        case .search:
            textLabel.text = "SIMPLE_ALERT_TEXT_SEARCH".localized
        }
    }

    @IBAction func noShowAgainPressed(_ sender: Any) {
        noShowAgainView.isHidden.toggle()
    }

    @IBAction func acceptPressed(_ sender: Any) {
        switch alertType {
        case .spaceLibrary:
            if noShowAgainView.isHidden == false {
                UserDefaults.standard.spaceLAlertNoShowAgain = true
            }
        case .apod:
            if noShowAgainView.isHidden == false {
                UserDefaults.standard.apodAlertNoShowAgain = true
            }
        case .search:
            if noShowAgainView.isHidden == false {
                UserDefaults.standard.searchAlertNoShowAgain = true
            }
        }

        CustomNavigationController.instance.closeAlertSimpleView()
    }
}
