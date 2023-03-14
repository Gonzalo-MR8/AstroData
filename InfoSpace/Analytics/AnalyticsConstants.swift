//
//  AnalyticsConstants.swift
//  InfoSpace
//
//  Created by GonzaloMR on 14/3/23.
//

import Foundation

// MARK: - Events
struct AnalyticsConstantsEvents {
    // OnBoarding
    static let kAnalyticsPlanetDetailEnter = "planet_detail_enter"
    static let kAnalyticsPlanetDetailExpandImages = "planet_detail_expand_enter"
    static let kAnalyticsPlanetDetailDeexpandImages = "planet_detail_deexpand_enter"
}

// MARK: - Parameters
struct AnalyticsConstantsParameters {
    // Commons
    static let kAnalyticsParamNameOrigin            = "origin"
    static let kAnalyticsParamNameError             = "error"
    static let kAnalyticsParamNameUrl               = "url"
}

// MARK: - ScreenNames
struct AnalyticsConstantsScreenNames {
    // OnBoarding
    static let kAnalyticsScreenNameDashboard = "dashboard"
}
