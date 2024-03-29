//
//  PlanetsEndPoint.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/2/23.
//

import Foundation

enum PlanetsEndPoint {
    case getPlanets
}

extension PlanetsEndPoint: EndPoint {
    var basePath: String {
        return Bundle.string(for: InfoConstants.kFirebaseDataUrl) ?? ""
    }
    
    var path: String {
        switch self {
        case .getPlanets:
            guard Locale.currentLanguage == .spanish else { return "planets.json" }

            return "planetas.json"
        }
    }
    
    var method: HttpMethod { .get }
    
    var postBody: [String: String]? { nil }
    
    var urlParameters: [String: String]? { nil }
    
    var customHeaders: [String: String]? { nil }
}
