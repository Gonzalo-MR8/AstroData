//
//  FirebaseDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import Foundation

enum WebServiceError: Error {
    case noData
    case decondingError
    case generic(error: Error)
}

class FirebaseDataDataManager {
    
    let baseUrl: String
    
    init() {
        var url = Bundle.string(for: InfoConstants.kFirebaseDataUrl)!
        
        if !url.hasSuffix("/") {
            url = url + "/"
        }
        
        baseUrl = url
    }
    
    internal func createWS(path: String) -> WebService {
        let commonHeaders = [String:String]()
        
        let url = baseUrl + path
        let webService = WebService(url: url, customHeaders: commonHeaders)

        return webService
    }

}
