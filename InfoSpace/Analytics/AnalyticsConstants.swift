//
//  AnalyticsConstants.swift
//  InfoSpace
//
//  Created by GonzaloMR on 14/3/23.
//

import Foundation

// MARK: - Events
struct AnalyticsConstantsEvents {
    // Common
    static let kAnalyticsOpenUrl = "open_url"

    // Planet Detail
    static let kAnalyticsPlanetDetailEnter          = "planet_detail_enter"
    static let kAnalyticsPlanetDetailExpandImages   = "planet_detail_expand"
    static let kAnalyticsPlanetDetailDeexpandImages = "planet_detail_deexpand"

    // APOD
    static let kAnalyticsAPODEnter      = "apod_enter"
    static let kAnalyticsAPODChangeDate = "apod_change_date"

    // Space Library
    static let kAnalyticsSpaceLibraryEnter          = "space_library_enter"
    static let kAnalyticsSpaceLibraryOpenFilters    = "space_library_open_filters"
    static let kAnalyticsSpaceLibraryChangeFilters  = "space_library_change_filters"
    static let kAnalyticsSpaceLibraryResetFilters   = "space_library_reset_filters"

    // Space Library Detail
    static let kAnalyticsSpaceLibraryDetailEnter = "space_library_detail_enter"

    // Images Gallery
    static let kAnalyticsImagesGalleryEnter             = "images_gallery_enter"
    static let kAnalyticsImagesGalleryCloseByDrag       = "images_gallery_close_by_drag"
    static let kAnalyticsImagesGalleryDownloadPressed   = "images_gallery_download_image_pressed"
    static let kAnalyticsImagesGalleryDownloadAccept    = "images_gallery_download_image_accept"
    static let kAnalyticsImagesGalleryDownloadCancel    = "images_gallery_download_image_cancel"
}

// MARK: - Parameters
struct AnalyticsConstantsParameters {
    // Commons
    static let kAnalyticsParamNameOrigin = "origin"
    static let kAnalyticsParamNameUrl    = "url"
    static let kAnalyticsParamNameDate   = "date"

    // Space Library Detail
    static let kAnalyticsParamNameId    = "id"
    static let kAnalyticsParamNameTitle = "title"
    static let kAnalyticsParamNameType  = "type"
}

// MARK: - ScreenNames
struct AnalyticsConstantsScreenNames {
    // OnBoarding
    static let kAnalyticsScreenNameDashboard            = "dashboard"
    static let kAnalyticsScreenNamePlanetDetail         = "planet_detail"
    static let kAnalyticsScreenNameAPOD                 = "apod"
    static let kAnalyticsScreenNameSpaceLibrary         = "space_library"
    static let kAnalyticsScreenNameSpaceLibraryDetail   = "space_library_detail"
}
