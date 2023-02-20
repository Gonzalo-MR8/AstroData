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
    var order: Order
    
    init() {
        self.page = "1"
        self.order = .highestToLowest
    }
}

// MARK: - SLastPageItem
struct SLastPageItem: Codable {
    let collection: SLCollection
    
    public func getPage() -> String? {
        guard let strUrl = collection.getPrevLink(),
              let url = URL(string: strUrl),
              let page = url.getQueryStringParameter(param: ParametersConstants.kParameterPage) else {
            return nil
        }
        
        return page
    }
}

// MARK: - SLCollection
struct SLCollection: Codable {
    let version: String
    let href: String
    let links: [SLink]?
    
    public func getPrevLink() -> String? {
        let kPrevString = "prev"
        
        guard let link = links?.first(where: { $0.rel.lowercased() == kPrevString.lowercased() }) else {
            return nil
        }
        
        return link.href
    }
}

// MARK: - SLink
struct SLink: Codable {
    let rel, prompt: String
    let href: String
}
