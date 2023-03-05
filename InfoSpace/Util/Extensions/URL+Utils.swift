//
//  URL+Utils.swift
//  InfoSpace
//
//  Created by GonzaloMR on 23/11/22.
//

import Foundation

extension URL {
    private var queryParameters: [String: String]? {
        guard
            let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
            let queryItems = components.queryItems else { return nil }
        return queryItems.reduce(into: [String: String]()) { (result, item) in
            result[item.name] = item.value
        }
    }
    
    init?(completedString: String) {
        if let url = URL(string: completedString) {
            self = url
        } else {
            let replacedString = completedString.replacingOccurrences(of: " ", with: "%20")
            
            if let url = URL(string: replacedString) {
                self = url
            } else {
                let replacedString = completedString.replacingOccurrences(of: " ", with: "+")
                
                if let url = URL(string: replacedString) {
                    self = url
                } else {
                    return nil
                }
            }
        }
    }
    
    public func getQueryStringParameter(param: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
