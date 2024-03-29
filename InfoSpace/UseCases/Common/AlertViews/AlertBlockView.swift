//
//  AlertBlockView.swift
//  InfoSpace
//
//  Created by GonzaloMR on 4/5/23.
//

import UIKit
import Lottie

enum AlertBlockType {
    case internet
    case update
}

class AlertBlockView: CIView {

    @IBOutlet private weak var animationView: AnimationView!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var button: CIButton!

    private var alertType: AlertBlockType = .internet

    func configure(alertType: AlertBlockType) {
        setupNib()
        animationView.loopMode = .loop

        self.alertType = alertType

        switch alertType {
        case .internet:
            animationView.animation = Animation.named("noInternet")
            animationView.animationSpeed = 0.75
            textLabel.text = "NO_INTERNET".localized
            button.setTitle("TRY_AGAIN", for: .normal)
        case .update:
            animationView.animation = Animation.named("update")
            animationView.animationSpeed = 1
            textLabel.text = "NEW_UPDATE".localized
            button.setTitle("UPDATE", for: .normal)
        }

        animationView.play()
    }

    @IBAction func buttonPressed(_ sender: Any) {
        switch alertType {
        case .internet:
            if NetworkManager.shared.isConnected == true {
                CustomNavigationController.instance.closeAlertBlockView()
            }
        case .update:
            let appId = "6449099410"
            guard let countryCode = NSLocale.current.regionCode, let appURL = URL.init(string: "https://apps.apple.com/\(countryCode.lowercased())/app/astrodata/id" + appId) else { return }

            CustomNavigationController.instance.openUrl(appURL)
        }
    }

}
