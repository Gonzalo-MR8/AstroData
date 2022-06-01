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

class FirebaseDataManager {
    
    let baseUrl: String
    
    init() {
        var url = "https://infospace-4c8c9-default-rtdb.europe-west1.firebasedatabase.app/"
        
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
