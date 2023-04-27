//
//  ApodEndPoint.swift
//  InfoSpace
//
//  Created by GonzaloMR on 12/2/23.
//

import Foundation

enum ApodEndPoint {
    case getApod(date: Date?)
}

extension ApodEndPoint: EndPoint {
    var basePath: String {
        return Bundle.string(for: InfoConstants.kNasaBaseUrl) ?? ""
    }
    
    var path: String {
        switch self {
        case .getApod:
            return "planetary/apod"
        }
    }
    
    var method: HttpMethod {
        return .get
    }
    
    var postBody: [String: String]? {
        return nil
    }
    
    var urlParameters: [String: String]? {
        let kParameterApiKey = "api_key"
        let kParameterDate = "date"
        
        var commonParameters = [String: String]()
        commonParameters[kParameterApiKey] = Bundle.string(for: InfoConstants.kNasaApiKey) ?? ""
        
        switch self {
        case .getApod(let date):
            var getApodParameters = commonParameters
            
            guard let date = date else {
                return getApodParameters
            }
            
            let formatter = DateFormatter.dateFormatterLocale
            formatter.dateFormat = Constants.kShortDateFormat
            
            getApodParameters[kParameterDate] = formatter.string(from: date)
            
            return getApodParameters
        }
    }
    
    var customHeaders: [String: String]? {
        return nil
    }
}
