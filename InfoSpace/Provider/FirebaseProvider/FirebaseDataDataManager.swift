//
//  FirebaseDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 31/5/22.
//

import Foundation

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
        let url = baseUrl + path
        let webService = WebService(url: url)

        return webService
    }

}
