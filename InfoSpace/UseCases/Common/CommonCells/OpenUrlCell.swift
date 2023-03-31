//
//  OpenUrlCell.swift
//  InfoSpace
//
//  Created by GonzaloMR on 22/11/22.
//

import UIKit

class OpenUrlCell: UITableViewCell {

    @IBOutlet private weak var buttonOpenUrl: Button!
    
    private var url: URL!

    private var analyticsScreen: AnalyticsScreen!

    func configure(url: URL, analyticsScreen: AnalyticsScreen) {
        self.url = url
        self.analyticsScreen = analyticsScreen
    }
    
    @IBAction func buttonOpenUrlPressed(_ sender: Any) {
        let parameters = [AnalyticsConstantsParameters.kAnalyticsParamNameUrl: url.absoluteString,
                          AnalyticsConstantsParameters.kAnalyticsParamNameOrigin: analyticsScreen.origin]
        let event = AnalyticsEvent(name: AnalyticsConstantsEvents.kAnalyticsOpenUrl, parameters: parameters)
        AnalyticsManager.shared.send(event: event)

        CustomNavigationController.instance.openUrl(url, animated: true)
    }
    
}
