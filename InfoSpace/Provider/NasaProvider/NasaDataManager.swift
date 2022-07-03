//
//  NasaDataManager.swift
//  InfoSpace
//
//  Created by GonzaloMR on 13/6/22.
//

import Foundation

class NasaDataManager {
    
    private let kParameterApiKey = "api_key"
    
    let baseUrl: String
    
    init() {
        var url = Bundle.string(for: InfoConstants.kNasaBaseUrl)!
        
        if !url.hasSuffix("/") {
            url = url + "/"
        }
        
        baseUrl = url
    }
    
    internal func createWS(path: String) -> WebService {
        var commonParameters = [String:String]()
        
        commonParameters[kParameterApiKey] = Bundle.string(for: InfoConstants.kNasaApiKey)!
        
        let url = baseUrl + path
        let webService = WebService(url: url, urlParameters: commonParameters)

        return webService
    }

}
