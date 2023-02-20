//
//  NasaLibraryEndPoint.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/2/23.
//

import Foundation

enum NasaLibraryEndPoint {
    case getLibraryDefault(page: String)
    case getLibraryFilters(filters: SpaceLibraryFilters)
    case getSLastPageItemDefault
    case getSLastPageItemFilters(filters: SpaceLibraryFilters)
    case getMediaURLs(jsonUrl: String)
}

extension NasaLibraryEndPoint: EndPoint {
    var basePath: String {
        switch self {
        case .getMediaURLs(jsonUrl: _):
            return ""
        default:
            return Bundle.string(for: InfoConstants.kNasaLibraryBaseUrl)!
        }
    }
    
    var path: String {
        switch self {
        case .getMediaURLs(jsonUrl: let jsonUrl):
            return jsonUrl
        default:
            return ""
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var postBody: [String : String]? {
        return nil
    }
    
    var urlParameters: [String : String]? {
        let kParameterSearchText = "q"
        let kParameterYearStart = "year_start"
        let kParameterYearEnd = "year_end"
        let kParameterMediaType = "media_type"
        
        var parameters = [String:String]()
        
        switch self {
        case .getLibraryDefault(let page):
            parameters[kParameterYearStart] = Utils.shared.getCurrentYear().description
            parameters[ParametersConstants.kParameterPage] = page
        case .getLibraryFilters(let filters), .getSLastPageItemFilters(filters: let filters):
            parameters[ParametersConstants.kParameterPage] = String(filters.page)
            
            if let searchText = filters.searchText {
                parameters[kParameterSearchText] = searchText
            }
            
            if let yearEnd = filters.yearEnd {
                parameters[kParameterYearEnd] = yearEnd
            }
            
            if let yearStart = filters.yearStart {
                parameters[kParameterYearStart] = yearStart
            }
            
            guard let mediaTypes = filters.mediaTypes else {
                return parameters
            }
            
            var mediaTypesString: String?
            
            mediaTypes.forEach { type in
                if mediaTypesString == nil {
                    mediaTypesString = type.rawValue
                } else {
                    mediaTypesString = mediaTypesString! + ",\(type.rawValue)"
                }
            }
            
            if let mediaTypesString = mediaTypesString {
                parameters[kParameterMediaType] = mediaTypesString
            }
        case .getSLastPageItemDefault:
            parameters[kParameterYearStart] = Utils.shared.getCurrentYear().description
            parameters[ParametersConstants.kParameterPage] = ParametersConstants.kLastPageNumber
        default:
            return nil
        }
        
        return parameters
    }
    
    var customHeaders: [String : String]? {
        return nil
    }
}
