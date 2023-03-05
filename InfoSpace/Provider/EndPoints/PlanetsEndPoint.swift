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
        return Bundle.string(for: InfoConstants.kFirebaseDataUrl)!
    }
    
    var path: String {
        switch self {
        case .getPlanets:
            return "planetas.json"
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var postBody: [String: String]? {
        return nil
    }
    
    var urlParameters: [String: String]? {
        return nil
    }
    
    var customHeaders: [String: String]? {
        return nil
    }
}
