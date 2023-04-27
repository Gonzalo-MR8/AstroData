//
//  AnalyticsManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 14/3/23.
//

import Foundation

final class AnalyticsManager {
    
    static let shared = AnalyticsManager()

    private init() {}

    func send(event: AnalyticsEvent?) {
        guard let event = event else { return }

        // Analytics.logEvent(event.name, parameters: event.parameters)

        #if DEBUG
        print("Analytics event sent: \(event)")
        #endif
    }

    func send(name: String) {
        let event = AnalyticsEvent(name: name)

        // Analytics.logEvent(event.name, parameters: event.parameters)

        #if DEBUG
        print("Analytics event sent: \(event)")
        #endif
    }
}
