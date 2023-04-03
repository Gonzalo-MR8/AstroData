//
//  Analytics.swift
//  InfoSpace
//
//  Created by GonzaloMR on 14/3/23.
//

import Foundation

struct AnalyticsEvent {
    let name: String
    let parameters: [String: Any]?

    init(name: String, parameters: [String: Any]? = nil) {
        self.name = name

        var allParameters = [String: Any]()

        if let parameters = parameters {
            allParameters = allParameters.merging(parameters) { $1 }
        }

        self.parameters = allParameters
    }
}

extension AnalyticsEvent: CustomStringConvertible {
    var description: String {
        var result = "Event: \(name) / Parameters: ["

        if let parametersStr = parameters?.map({ "\($0.key)=\($0.value)" }) {
            result.append(parametersStr.joined(separator: " | "))
        }

        result.append("]")

        return result
    }
}

enum AnalyticsScreen {
    case dashboard
    case planetDetail
    case apod
    case spaceLibrary
    case spaceLibraryDetail

    var planetDetailEnterAnalyticsEvent: AnalyticsEvent {
        let parameters = [
            AnalyticsConstantsParameters.kAnalyticsParamNameOrigin: origin
        ]

        let analyticsEvent = AnalyticsEvent(name: AnalyticsConstantsEvents.kAnalyticsPlanetDetailEnter, parameters: parameters)

        return analyticsEvent
    }

    var apodEnterAnalyticsEvent: AnalyticsEvent {
        let parameters = [
            AnalyticsConstantsParameters.kAnalyticsParamNameOrigin: origin
        ]

        let analyticsEvent = AnalyticsEvent(name: AnalyticsConstantsEvents.kAnalyticsAPODEnter, parameters: parameters)

        return analyticsEvent
    }

    var spaceLibraryEnterAnalyticsEvent: AnalyticsEvent {
        let parameters = [
            AnalyticsConstantsParameters.kAnalyticsParamNameOrigin: origin
        ]

        let analyticsEvent = AnalyticsEvent(name: AnalyticsConstantsEvents.kAnalyticsSpaceLibraryEnter, parameters: parameters)

        return analyticsEvent
    }
    
    var imagesGalleryEnterAnalyticsEvent: AnalyticsEvent {
        let parameters = [
            AnalyticsConstantsParameters.kAnalyticsParamNameOrigin: origin
        ]

        let analyticsEvent = AnalyticsEvent(name: AnalyticsConstantsEvents.kAnalyticsImagesGalleryEnter, parameters: parameters)

        return analyticsEvent
    }

    var origin: String {
        switch self {
        case .dashboard:
            return AnalyticsConstantsScreenNames.kAnalyticsScreenNameDashboard
        case .planetDetail:
            return AnalyticsConstantsScreenNames.kAnalyticsScreenNamePlanetDetail
        case .apod:
            return AnalyticsConstantsScreenNames.kAnalyticsScreenNameAPOD
        case .spaceLibrary:
            return AnalyticsConstantsScreenNames.kAnalyticsScreenNameSpaceLibrary
        case .spaceLibraryDetail:
            return AnalyticsConstantsScreenNames.kAnalyticsScreenNameSpaceLibraryDetail
        }
    }
}
