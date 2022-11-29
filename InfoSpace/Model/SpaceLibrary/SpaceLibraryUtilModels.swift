//
//  SpaceLibraryUtilModels.swift
//  InfoSpace
//
//  Created by GonzaloMR on 2/11/22.
//

import Foundation

struct SpaceLibraryFilters {
    var page: String
    var yearStart, yearEnd, searchText: String?
    var mediaTypes: [MediaType]?
}

// MARK: - SLastPageItem
struct SLastPageItem: Codable {
    let collection: SLCollection
}

// MARK: - SLCollection
struct SLCollection: Codable {
    let version: String
    let href: String
    let links: [SLLink]
}

// MARK: - SLLink
struct SLLink: Codable {
    let rel, prompt: String
    let href: String
}
